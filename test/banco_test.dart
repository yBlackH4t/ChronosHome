import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chronos_home/dados/banco.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late Banco banco;
  late DateTime relogio;

  /// Avança o relógio do banco.
  void passar(Duration tempo) => relogio = relogio.add(tempo);

  setUp(() {
    relogio = DateTime(2026, 10, 11, 9);
    banco = Banco(NativeDatabase.memory(), agora: () => relogio);
  });

  tearDown(() => banco.close());

  Future<String> maionese() => banco.cadastrarProduto(
        nome: 'Maionese',
        marca: 'Hellmann\'s',
        diasValidadeAberto: 5,
        codigos: ['7891234567895'],
      );

  group('banco novo', () {
    test('cria os locais padrão', () async {
      final nomes = (await banco.listarLocais()).map((l) => l.nome);
      expect(nomes, containsAll(locaisPadrao));
    });

    test('o esquema bate com as tabelas declaradas', () async {
      await banco.validateDatabaseSchema();
    });
  });

  group('produtos e códigos', () {
    test('acha o produto pelo código de barras', () async {
      final id = await maionese();

      final achado = await banco.produtoPorCodigo('7891234567895');
      expect(achado?.id, id);
      expect(achado?.nome, 'Maionese');
      expect(await banco.produtoPorCodigo('000'), isNull);
    });

    test('um produto aceita vários códigos', () async {
      final id = await maionese();
      await banco.adicionarCodigo(id, '7890000000001');

      expect((await banco.produtoPorCodigo('7890000000001'))?.id, id);
      expect((await banco.produtoPorCodigo('7891234567895'))?.id, id);
    });
  });

  group('regras de estado', () {
    test('entrada cria unidades fechadas e registra o movimento', () async {
      final id = await maionese();
      final unidades = await banco.darEntrada(id, quantidade: 3);

      expect(unidades, hasLength(3));
      expect(await banco.quantidadeEmCasa(id), 3);
      final emCasa = await banco.unidadesEmCasa(id);
      expect(emCasa.every((u) => u.estado == EstadoUnidade.fechado), isTrue);
      final historico = await banco.historico(unidades.first);
      expect(historico.map((m) => m.acao), [AcaoMovimento.entrada]);
    });

    test('fechado → aberto → acabou, com datas e histórico', () async {
      final id = await maionese();
      final [unidade] = await banco.darEntrada(id);

      passar(const Duration(days: 1));
      await banco.abrir(unidade);
      passar(const Duration(days: 4));
      await banco.acabar(unidade);

      final u = (await (banco.select(banco.unidades)..where((t) => t.id.equals(unidade))).getSingle());
      expect(u.estado, EstadoUnidade.acabou);
      expect(u.abertoEm, DateTime(2026, 10, 12, 9));
      expect(u.saiuEm, DateTime(2026, 10, 16, 9));
      expect(await banco.quantidadeEmCasa(id), 0);
      expect(
        (await banco.historico(unidade)).map((m) => m.acao),
        [AcaoMovimento.entrada, AcaoMovimento.abrir, AcaoMovimento.acabou],
      );
    });

    test('dá para acabar ou descartar direto de fechado', () async {
      final id = await maionese();
      final [a, b] = await banco.darEntrada(id, quantidade: 2);

      await banco.acabar(a);
      await banco.descartar(b);

      expect(await banco.quantidadeEmCasa(id), 0);
    });

    test('não abre o que já está aberto ou já saiu', () async {
      final id = await maionese();
      final [unidade] = await banco.darEntrada(id);
      await banco.abrir(unidade);

      expect(() => banco.abrir(unidade), throwsA(isA<TransicaoInvalida>()));
      await banco.acabar(unidade);
      expect(() => banco.abrir(unidade), throwsA(isA<TransicaoInvalida>()));
      expect(() => banco.acabar(unidade), throwsA(isA<TransicaoInvalida>()));
      expect(() => banco.descartar(unidade), throwsA(isA<TransicaoInvalida>()));
    });

    test('transição recusada não deixa nada pela metade', () async {
      final id = await maionese();
      final [unidade] = await banco.darEntrada(id);
      await banco.descartar(unidade);

      await expectLater(banco.acabar(unidade), throwsA(isA<TransicaoInvalida>()));
      expect((await banco.historico(unidade)).map((m) => m.acao),
          [AcaoMovimento.entrada, AcaoMovimento.descartar]);
    });

    test('mover troca o local e fica no histórico', () async {
      final id = await maionese();
      final locais = await banco.listarLocais();
      final geladeira = locais.firstWhere((l) => l.nome == 'Geladeira');
      final [unidade] = await banco.darEntrada(id);

      await banco.mover(unidade, geladeira.id);

      final [u] = await banco.unidadesEmCasa(id);
      expect(u.localId, geladeira.id);
      final ultimo = (await banco.historico(unidade)).last;
      expect(ultimo.acao, AcaoMovimento.mover);
      expect(ultimo.localId, geladeira.id);
    });

    test('quantidade de entrada precisa ser positiva', () async {
      final id = await maionese();
      expect(() => banco.darEntrada(id, quantidade: 0), throwsA(isA<TransicaoInvalida>()));
    });
  });

  group('qual unidade usar ao bipar', () {
    test('abre primeiro a que vence antes; sem validade, a mais antiga', () async {
      final id = await maionese();
      final [semValidade] = await banco.darEntrada(id);
      passar(const Duration(days: 1));
      final [venceDepois] = await banco.darEntrada(id, venceEm: DateTime(2026, 12, 1));
      final [venceAntes] = await banco.darEntrada(id, venceEm: DateTime(2026, 11, 1));

      expect((await banco.unidadeParaAbrir(id))?.id, venceAntes);
      await banco.abrir(venceAntes);
      expect((await banco.unidadeParaAbrir(id))?.id, venceDepois);
      await banco.abrir(venceDepois);
      expect((await banco.unidadeParaAbrir(id))?.id, semValidade);
    });

    test('acaba primeiro a aberta há mais tempo; se nenhuma aberta, a próxima a abrir', () async {
      final id = await maionese();
      final [a, b] = await banco.darEntrada(id, quantidade: 2);

      expect((await banco.unidadeParaAcabar(id))?.id, a);

      await banco.abrir(b);
      passar(const Duration(hours: 1));
      await banco.abrir(a);
      expect((await banco.unidadeParaAcabar(id))?.id, b);
    });

    test('sem nada em casa, não sugere unidade', () async {
      final id = await maionese();
      expect(await banco.unidadeParaAbrir(id), isNull);
      expect(await banco.unidadeParaAcabar(id), isNull);
    });
  });

  group('desfazer entrada', () {
    test('apaga a unidade e o histórico dela', () async {
      final id = await maionese();
      final [a, _] = await banco.darEntrada(id, quantidade: 2);

      await banco.desfazerEntrada(a);

      expect(await banco.quantidadeEmCasa(id), 1);
      expect(await banco.historico(a), isEmpty);
    });

    test('não desfaz uma unidade que já foi usada', () async {
      final id = await maionese();
      final [a] = await banco.darEntrada(id);
      await banco.abrir(a);

      expect(() => banco.desfazerEntrada(a), throwsA(isA<TransicaoInvalida>()));
    });
  });

  group('desfazer a última ação', () {
    test('abrir por engano: volta a fechado e some do histórico', () async {
      final id = await maionese();
      final [u] = await banco.darEntrada(id);
      await banco.abrir(u);

      await banco.desfazerUltimaAcao(u);

      final [volta] = await banco.unidadesEmCasa(id);
      expect(volta.estado, EstadoUnidade.fechado);
      expect(volta.abertoEm, isNull);
      expect((await banco.historico(u)).map((m) => m.acao), [AcaoMovimento.entrada]);
    });

    test('acabou por engano: volta a aberto se estava aberto', () async {
      final id = await maionese();
      final [u] = await banco.darEntrada(id);
      await banco.abrir(u);
      await banco.acabar(u);

      await banco.desfazerUltimaAcao(u);

      final [volta] = await banco.unidadesEmCasa(id);
      expect(volta.estado, EstadoUnidade.aberto);
      expect(volta.saiuEm, isNull);
      expect(volta.abertoEm, isNotNull);
    });

    test('descartou por engano direto de fechado: volta a fechado', () async {
      final id = await maionese();
      final [u] = await banco.darEntrada(id);
      await banco.descartar(u);

      await banco.desfazerUltimaAcao(u);

      final [volta] = await banco.unidadesEmCasa(id);
      expect(volta.estado, EstadoUnidade.fechado);
    });

    test('só a entrada no histórico: não há o que desfazer aqui', () async {
      final id = await maionese();
      final [u] = await banco.darEntrada(id);

      expect(() => banco.desfazerUltimaAcao(u), throwsA(isA<TransicaoInvalida>()));
    });
  });

  test('ajustar produto muda o mínimo e o prazo e recusa números inválidos', () async {
    final id = await maionese();

    await banco.ajustarProduto(id, estoqueMinimo: 2, diasValidadeAberto: null);
    final p = await banco.produtoPorId(id);
    expect(p.estoqueMinimo, 2);
    expect(p.diasValidadeAberto, isNull);

    expect(() => banco.ajustarProduto(id, estoqueMinimo: -1), throwsA(isA<TransicaoInvalida>()));
    expect(() => banco.ajustarProduto(id, estoqueMinimo: 0, diasValidadeAberto: 0),
        throwsA(isA<TransicaoInvalida>()));
  });

  test('validade: definida na entrada ou depois; o estoque mostra a mais próxima entre as em casa', () async {
    final id = await maionese();
    final [a] = await banco.darEntrada(id, venceEm: DateTime(2026, 11, 1));
    final [b, c] = await banco.darEntrada(id, quantidade: 2);

    await banco.definirValidade([b, c], DateTime(2026, 10, 20));
    expect((await banco.observarEstoque().first).single.venceEm, DateTime(2026, 10, 20));

    // Unidades que saíram de casa não contam e não mudam mais.
    await banco.acabar(b);
    await banco.acabar(c);
    await banco.definirValidade([b], DateTime(2026, 10, 12));
    expect((await banco.observarEstoque().first).single.venceEm, DateTime(2026, 11, 1));
    expect((await banco.unidadeParaAbrir(id))?.id, a);
  });

  test('o histórico para os gráficos traz o produto e respeita a data inicial', () async {
    final id = await maionese();
    final [u] = await banco.darEntrada(id);
    passar(const Duration(days: 3));
    await banco.abrir(u);
    await banco.acabar(u);

    final todos = await banco.movimentosDesde(DateTime(2026, 10, 1));
    expect(todos.map((m) => m.acao), [AcaoMovimento.entrada, AcaoMovimento.abrir, AcaoMovimento.acabou]);
    expect(todos.first.produto.nome, 'Maionese');

    final depois = await banco.movimentosDesde(DateTime(2026, 10, 13));
    expect(depois.map((m) => m.acao), [AcaoMovimento.abrir, AcaoMovimento.acabou]);
  });

  test('o estoque informa desde quando está aberta a unidade mais antiga', () async {
    final id = await maionese();
    final [a, b] = await banco.darEntrada(id, quantidade: 2);
    passar(const Duration(days: 1));
    await banco.abrir(a);
    passar(const Duration(days: 2));
    await banco.abrir(b);

    final [item] = await banco.observarEstoque().first;
    expect(item.abertoDesde, DateTime(2026, 10, 12, 9));
  });

  test('o estoque conta fechados e abertos e ignora o que saiu', () async {
    final id = await maionese();
    await banco.cadastrarProduto(nome: 'Arroz');
    final [a, b, _] = await banco.darEntrada(id, quantidade: 3);
    await banco.abrir(a);
    await banco.acabar(b);

    final estoque = await banco.observarEstoque().first;

    expect(estoque.map((i) => i.produto.nome), ['Arroz', 'Maionese']);
    final maioneseNoEstoque = estoque.last;
    expect(maioneseNoEstoque.fechados, 1);
    expect(maioneseNoEstoque.abertos, 1);
    expect(maioneseNoEstoque.emCasa, 2);
    expect(estoque.first.emCasa, 0);
  });

  group('migrações', () {
    test('versão 1 (passo 2) → atual: cria as tabelas e tira a de leituras', () async {
      final antigo = Banco(NativeDatabase.memory(setup: (db) {
        // O mesmo SQL que o drift gerou na versão 1.
        db.execute('CREATE TABLE IF NOT EXISTS "leituras" ("id" TEXT NOT NULL, "codigo" TEXT NOT NULL, '
            '"formato" TEXT NOT NULL, "lido_em" INTEGER NOT NULL, PRIMARY KEY ("id"))');
        db.execute("INSERT INTO leituras VALUES ('l1', '7891234567895', 'ean13', 0)");
        db.execute('PRAGMA user_version = 1');
      }));
      addTearDown(antigo.close);

      expect((await antigo.listarLocais()).map((l) => l.nome), containsAll(locaisPadrao));
      await antigo.validateDatabaseSchema();
    });

    test('versão 2 (passo 3) → atual: mantém produtos e estoque', () async {
      final pasta = await Directory.systemTemp.createTemp('chronos_home_');
      addTearDown(() => pasta.delete(recursive: true));
      final arquivo = File(p.join(pasta.path, 'v2.db'));

      // Monta um banco versão 2: o esquema atual mais a tabela leituras.
      final v2 = Banco(NativeDatabase(arquivo));
      final id = await v2.cadastrarProduto(nome: 'Café', codigos: ['789']);
      await v2.darEntrada(id, quantidade: 2);
      await v2.customStatement('CREATE TABLE leituras (id TEXT NOT NULL, codigo TEXT NOT NULL, '
          'formato TEXT NOT NULL, lido_em INTEGER NOT NULL, PRIMARY KEY (id))');
      await v2.customStatement('PRAGMA user_version = 2');
      await v2.close();

      final atual = Banco(NativeDatabase(arquivo));
      addTearDown(atual.close);

      expect((await atual.produtoPorCodigo('789'))?.nome, 'Café');
      expect(await atual.quantidadeEmCasa(id), 2);
      await atual.validateDatabaseSchema();
    });
  });
}
