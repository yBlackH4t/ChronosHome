import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'tabelas.dart';

export 'tabelas.dart';

part 'banco.g.dart';

/// Pedido que as regras de estado não permitem (ex.: abrir algo que já acabou).
class TransicaoInvalida implements Exception {
  const TransicaoInvalida(this.mensagem);

  final String mensagem;

  @override
  String toString() => mensagem;
}

/// Um produto e quantas unidades dele estão em casa.
class ItemDoEstoque {
  const ItemDoEstoque({
    required this.produto,
    required this.fechados,
    required this.abertos,
    this.abertoDesde,
  });

  final Produto produto;
  final int fechados;
  final int abertos;

  /// Quando foi aberta a unidade aberta há mais tempo (vazio se nenhuma está aberta).
  final DateTime? abertoDesde;

  int get emCasa => fechados + abertos;
}

/// Locais criados junto com o banco.
const locaisPadrao = ['Despensa', 'Geladeira', 'Freezer'];

@DriftDatabase(tables: [Produtos, CodigosBarras, Locais, Unidades, Movimentos])
class Banco extends _$Banco {
  /// [agora] existe para os testes controlarem o relógio.
  Banco(super.executor, {DateTime Function()? agora}) : _agora = agora ?? DateTime.now;

  final DateTime Function() _agora;
  static const _uuid = Uuid();

  // Versão 1: passo 2 (só a tabela leituras).
  // Versão 2: passo 3 (produtos, códigos, locais, unidades, movimentos).
  // Versão 3: passo 4 (sai a tabela leituras da prova).
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _criarLocaisPadrao();
        },
        onUpgrade: (m, de, para) async {
          if (de < 2) {
            await m.createTable(produtos);
            await m.createTable(codigosBarras);
            await m.createTable(locais);
            await m.createTable(unidades);
            await m.createTable(movimentos);
            await _criarLocaisPadrao();
          }
          if (de < 3) {
            await customStatement('DROP TABLE IF EXISTS leituras');
          }
        },
        beforeOpen: (detalhes) async {
          // O SQLite só respeita as referências entre tabelas com isto ligado.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _criarLocaisPadrao() async {
    for (final nome in locaisPadrao) {
      await into(locais).insert(LocaisCompanion.insert(id: _uuid.v4(), nome: nome));
    }
  }

  // ---------------------------------------------------------------- produtos

  Future<String> cadastrarProduto({
    required String nome,
    String? marca,
    String? categoria,
    String? foto,
    int estoqueMinimo = 0,
    int? diasValidadeAberto,
    List<String> codigos = const [],
  }) {
    return transaction(() async {
      final id = _uuid.v4();
      await into(produtos).insert(ProdutosCompanion.insert(
        id: id,
        nome: nome.trim(),
        marca: Value(marca),
        categoria: Value(categoria),
        foto: Value(foto),
        estoqueMinimo: Value(estoqueMinimo),
        diasValidadeAberto: Value(diasValidadeAberto),
        criadoEm: _agora(),
      ));
      for (final codigo in codigos) {
        await adicionarCodigo(id, codigo);
      }
      return id;
    });
  }

  /// Muda os números que alimentam os avisos e a lista de compras.
  /// [diasValidadeAberto] nulo = não avisar.
  Future<void> ajustarProduto(String produtoId, {required int estoqueMinimo, int? diasValidadeAberto}) {
    if (estoqueMinimo < 0 || (diasValidadeAberto != null && diasValidadeAberto < 1)) {
      throw const TransicaoInvalida('Estoque mínimo não pode ser negativo, e o prazo depois de aberto é de pelo menos 1 dia.');
    }
    return (update(produtos)..where((p) => p.id.equals(produtoId))).write(ProdutosCompanion(
      estoqueMinimo: Value(estoqueMinimo),
      diasValidadeAberto: Value(diasValidadeAberto),
    ));
  }

  Future<Produto> produtoPorId(String id) =>
      (select(produtos)..where((p) => p.id.equals(id))).getSingle();

  /// Liga um código de barras a um produto. Se o código já era de outro produto, passa para este.
  Future<void> adicionarCodigo(String produtoId, String codigo) {
    return into(codigosBarras).insertOnConflictUpdate(
      CodigosBarrasCompanion.insert(codigo: codigo.trim(), produtoId: produtoId),
    );
  }

  Future<Produto?> produtoPorCodigo(String codigo) {
    final consulta = select(produtos).join([
      innerJoin(codigosBarras, codigosBarras.produtoId.equalsExp(produtos.id)),
    ])
      ..where(codigosBarras.codigo.equals(codigo.trim()));
    return consulta.map((linha) => linha.readTable(produtos)).getSingleOrNull();
  }

  // ---------------------------------------------------------------- locais

  Future<List<Local>> listarLocais() =>
      (select(locais)..orderBy([(l) => OrderingTerm.asc(l.nome)])).get();

  // ---------------------------------------------------------------- unidades

  /// Chegou das compras: cria [quantidade] unidades fechadas.
  Future<List<String>> darEntrada(
    String produtoId, {
    int quantidade = 1,
    String? localId,
    DateTime? venceEm,
  }) {
    if (quantidade < 1) {
      throw const TransicaoInvalida('A quantidade precisa ser pelo menos 1.');
    }
    return transaction(() async {
      final agora = _agora();
      final ids = <String>[];
      for (var i = 0; i < quantidade; i++) {
        final id = _uuid.v4();
        await into(unidades).insert(UnidadesCompanion.insert(
          id: id,
          produtoId: produtoId,
          localId: Value(localId),
          estado: EstadoUnidade.fechado,
          entrouEm: agora,
          venceEm: Value(venceEm),
        ));
        await _registrar(id, AcaoMovimento.entrada, agora);
        ids.add(id);
      }
      return ids;
    });
  }

  /// fechado → aberto.
  Future<void> abrir(String unidadeId) {
    return transaction(() async {
      final unidade = await _unidade(unidadeId);
      if (unidade.estado != EstadoUnidade.fechado) {
        throw TransicaoInvalida('Só dá para abrir uma unidade fechada (esta está ${unidade.estado.name}).');
      }
      final agora = _agora();
      await (update(unidades)..where((u) => u.id.equals(unidadeId))).write(
        UnidadesCompanion(estado: const Value(EstadoUnidade.aberto), abertoEm: Value(agora)),
      );
      await _registrar(unidadeId, AcaoMovimento.abrir, agora);
    });
  }

  /// fechado ou aberto → acabou (foi consumida).
  Future<void> acabar(String unidadeId) =>
      _sair(unidadeId, EstadoUnidade.acabou, AcaoMovimento.acabou);

  /// fechado ou aberto → descartado (estragou, venceu: conta como desperdício).
  Future<void> descartar(String unidadeId) =>
      _sair(unidadeId, EstadoUnidade.descartado, AcaoMovimento.descartar);

  Future<void> _sair(String unidadeId, EstadoUnidade destino, AcaoMovimento acao) {
    return transaction(() async {
      final unidade = await _unidade(unidadeId);
      if (!_estaEmCasa(unidade)) {
        throw TransicaoInvalida('Esta unidade já saiu de casa (${unidade.estado.name}).');
      }
      final agora = _agora();
      await (update(unidades)..where((u) => u.id.equals(unidadeId))).write(
        UnidadesCompanion(estado: Value(destino), saiuEm: Value(agora)),
      );
      await _registrar(unidadeId, acao, agora);
    });
  }

  /// Muda a unidade de lugar (ex.: da despensa para a geladeira depois de aberta).
  Future<void> mover(String unidadeId, String localId) {
    return transaction(() async {
      final unidade = await _unidade(unidadeId);
      if (!_estaEmCasa(unidade)) {
        throw TransicaoInvalida('Esta unidade já saiu de casa (${unidade.estado.name}).');
      }
      await (update(unidades)..where((u) => u.id.equals(unidadeId)))
          .write(UnidadesCompanion(localId: Value(localId)));
      await _registrar(unidadeId, AcaoMovimento.mover, _agora(), localId: localId);
    });
  }

  /// Unidades que ainda estão em casa (fechadas ou abertas).
  Future<List<Unidade>> unidadesEmCasa(String produtoId) {
    return (select(unidades)
          ..where((u) => u.produtoId.equals(produtoId) & u.estado.isInValues(_emCasa))
          ..orderBy([(u) => OrderingTerm.asc(u.entrouEm)]))
        .get();
  }

  Future<int> quantidadeEmCasa(String produtoId) async =>
      (await unidadesEmCasa(produtoId)).length;

  /// Qual unidade abrir ao bipar: a fechada que vence primeiro; sem validade, a mais antiga.
  Future<Unidade?> unidadeParaAbrir(String produtoId) async {
    final fechadas = (await unidadesEmCasa(produtoId))
        .where((u) => u.estado == EstadoUnidade.fechado)
        .toList()
      ..sort(_vencePrimeiro);
    return fechadas.firstOrNull;
  }

  /// Qual unidade dar como acabada ao bipar: a aberta há mais tempo; se nenhuma, a próxima a abrir.
  Future<Unidade?> unidadeParaAcabar(String produtoId) async {
    final abertas = (await unidadesEmCasa(produtoId))
        .where((u) => u.estado == EstadoUnidade.aberto)
        .toList()
      ..sort((a, b) => a.abertoEm!.compareTo(b.abertoEm!));
    return abertas.firstOrNull ?? await unidadeParaAbrir(produtoId);
  }

  Future<List<Movimento>> historico(String unidadeId) {
    return (select(movimentos)
          ..where((m) => m.unidadeId.equals(unidadeId))
          ..orderBy([(m) => OrderingTerm.asc(m.quando)]))
        .get();
  }

  static const _emCasa = [EstadoUnidade.fechado, EstadoUnidade.aberto];

  static bool _estaEmCasa(Unidade u) => _emCasa.contains(u.estado);

  static int _vencePrimeiro(Unidade a, Unidade b) {
    if (a.venceEm != null && b.venceEm != null) return a.venceEm!.compareTo(b.venceEm!);
    if (a.venceEm != null) return -1;
    if (b.venceEm != null) return 1;
    return a.entrouEm.compareTo(b.entrouEm);
  }

  Future<Unidade> _unidade(String id) async {
    final unidade = await (select(unidades)..where((u) => u.id.equals(id))).getSingleOrNull();
    if (unidade == null) throw TransicaoInvalida('Unidade não encontrada: $id');
    return unidade;
  }

  Future<void> _registrar(String unidadeId, AcaoMovimento acao, DateTime quando, {String? localId}) {
    return into(movimentos).insert(MovimentosCompanion.insert(
      id: _uuid.v4(),
      unidadeId: unidadeId,
      acao: acao,
      quando: quando,
      localId: Value(localId),
    ));
  }

  /// Desfaz uma entrada feita por engano (bipou duas vezes): apaga a unidade e o histórico dela.
  /// Só vale enquanto nada mais aconteceu com a unidade.
  Future<void> desfazerEntrada(String unidadeId) {
    return transaction(() async {
      final unidade = await _unidade(unidadeId);
      final acoes = (await historico(unidadeId)).map((m) => m.acao);
      if (unidade.estado != EstadoUnidade.fechado || acoes.any((a) => a != AcaoMovimento.entrada)) {
        throw const TransicaoInvalida('Esta unidade já foi usada; não dá mais para desfazer a entrada.');
      }
      await (delete(movimentos)..where((m) => m.unidadeId.equals(unidadeId))).go();
      await (delete(unidades)..where((u) => u.id.equals(unidadeId))).go();
    });
  }

  /// Desfaz a última ação de uma unidade (tocou em Abrir, Acabou ou Descartar por engano):
  /// volta o estado anterior e apaga essa linha do histórico.
  Future<void> desfazerUltimaAcao(String unidadeId) {
    return transaction(() async {
      final unidade = await _unidade(unidadeId);
      final ultimo = (await historico(unidadeId)).lastOrNull;
      final UnidadesCompanion volta;
      switch (ultimo?.acao) {
        case AcaoMovimento.abrir when unidade.estado == EstadoUnidade.aberto:
          volta = const UnidadesCompanion(estado: Value(EstadoUnidade.fechado), abertoEm: Value(null));
        case AcaoMovimento.acabou || AcaoMovimento.descartar when !_estaEmCasa(unidade):
          volta = UnidadesCompanion(
            estado: Value(unidade.abertoEm == null ? EstadoUnidade.fechado : EstadoUnidade.aberto),
            saiuEm: const Value(null),
          );
        default:
          throw const TransicaoInvalida('Não há uma ação para desfazer nesta unidade.');
      }
      await (update(unidades)..where((u) => u.id.equals(unidadeId))).write(volta);
      await (delete(movimentos)..where((m) => m.id.equals(ultimo!.id))).go();
    });
  }

  /// Todos os produtos com quantas unidades há em casa; a lista se atualiza sozinha.
  Stream<List<ItemDoEstoque>> observarEstoque() {
    return customSelect(
      'SELECT p.*, '
      "COALESCE(SUM(u.estado = 'fechado'), 0) AS fechados, "
      "COALESCE(SUM(u.estado = 'aberto'), 0) AS abertos, "
      "MIN(CASE WHEN u.estado = 'aberto' THEN u.aberto_em END) AS aberto_desde "
      'FROM produtos p '
      "LEFT JOIN unidades u ON u.produto_id = p.id AND u.estado IN ('fechado', 'aberto') "
      'GROUP BY p.id '
      'ORDER BY p.nome COLLATE NOCASE',
      readsFrom: {produtos, unidades},
    ).watch().map((linhas) => [
          for (final linha in linhas)
            ItemDoEstoque(
              produto: produtos.map(linha.data),
              fechados: linha.read<int>('fechados'),
              abertos: linha.read<int>('abertos'),
              abertoDesde: linha.readNullable<DateTime>('aberto_desde'),
            ),
        ]);
  }

  /// Versão do SQLCipher; vazia quando o banco é um SQLite comum (sem criptografia).
  Future<String?> versaoDoSqlcipher() async {
    final linhas = await customSelect('PRAGMA cipher_version').get();
    if (linhas.isEmpty) return null;
    return linhas.first.data.values.first?.toString();
  }
}
