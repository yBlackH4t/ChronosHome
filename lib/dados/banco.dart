import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

part 'banco.g.dart';

/// Tabela da prova do passo 2: cada código lido pela câmera.
/// O modelo de dados de verdade (produtos, unidades, movimentos) entra no passo 3.
class Leituras extends Table {
  TextColumn get id => text()();
  TextColumn get codigo => text()();
  TextColumn get formato => text()();
  DateTimeColumn get lidoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Leituras])
class Banco extends _$Banco {
  Banco(super.executor);

  static const _uuid = Uuid();

  @override
  int get schemaVersion => 1;

  Future<void> registrarLeitura(String codigo, String formato) {
    return into(leituras).insert(
      LeiturasCompanion.insert(
        id: _uuid.v4(),
        codigo: codigo,
        formato: formato,
        lidoEm: DateTime.now(),
      ),
    );
  }

  /// As leituras mais recentes primeiro; a lista se atualiza sozinha.
  Stream<List<Leitura>> observarUltimas({int limite = 20}) {
    return (select(leituras)
          ..orderBy([(l) => OrderingTerm.desc(l.lidoEm)])
          ..limit(limite))
        .watch();
  }

  Future<int> contarLeituras() async {
    final total = leituras.id.count();
    final linha = await (selectOnly(leituras)..addColumns([total])).getSingle();
    return linha.read(total) ?? 0;
  }

  /// Versão do SQLCipher; vazia quando o banco é um SQLite comum (sem criptografia).
  Future<String?> versaoDoSqlcipher() async {
    final linhas = await customSelect('PRAGMA cipher_version').get();
    if (linhas.isEmpty) return null;
    return linhas.first.data.values.first?.toString();
  }
}
