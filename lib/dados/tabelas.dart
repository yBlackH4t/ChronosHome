import 'package:drift/drift.dart';

/// Estados de uma unidade física em casa.
/// fechado → aberto → acabou; de fechado ou aberto também dá para descartar.
enum EstadoUnidade { fechado, aberto, acabou, descartado }

/// O que aconteceu com uma unidade (o histórico, para gráficos e desperdício).
enum AcaoMovimento { entrada, abrir, acabou, descartar, mover }

class Produtos extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text().withLength(min: 1)();
  TextColumn get marca => text().nullable()();
  TextColumn get categoria => text().nullable()();
  /// Endereço da foto (Open Food Facts) ou caminho de um arquivo no celular.
  TextColumn get foto => text().nullable()();
  /// Abaixo disso o produto entra na lista de compras.
  IntColumn get estoqueMinimo => integer().withDefault(const Constant(0))();
  /// Depois de aberto, dura quantos dias (ex.: maionese, 5). Vazio = não avisa.
  IntColumn get diasValidadeAberto => integer().nullable()();
  DateTimeColumn get criadoEm => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Um produto pode ter vários códigos (o fabricante às vezes troca o código da embalagem).
@DataClassName('CodigoBarras')
class CodigosBarras extends Table {
  TextColumn get codigo => text()();
  TextColumn get produtoId => text().references(Produtos, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {codigo};
}

@DataClassName('Local')
class Locais extends Table {
  TextColumn get id => text()();
  TextColumn get nome => text().withLength(min: 1).unique()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cada unidade física em casa (um pote, uma lata). A quantidade é a contagem delas.
@DataClassName('Unidade')
class Unidades extends Table {
  TextColumn get id => text()();
  TextColumn get produtoId => text().references(Produtos, #id, onDelete: KeyAction.cascade)();
  TextColumn get localId => text().nullable().references(Locais, #id, onDelete: KeyAction.setNull)();
  TextColumn get estado => textEnum<EstadoUnidade>()();
  DateTimeColumn get entrouEm => dateTime()();
  DateTimeColumn get abertoEm => dateTime().nullable()();
  /// Quando acabou ou foi descartada.
  DateTimeColumn get saiuEm => dateTime().nullable()();
  /// Validade impressa na embalagem (opcional).
  DateTimeColumn get venceEm => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Movimentos extends Table {
  TextColumn get id => text()();
  TextColumn get unidadeId => text().references(Unidades, #id, onDelete: KeyAction.cascade)();
  TextColumn get acao => textEnum<AcaoMovimento>()();
  DateTimeColumn get quando => dateTime()();
  /// Para "mover": o local de destino.
  TextColumn get localId => text().nullable().references(Locais, #id, onDelete: KeyAction.setNull)();

  @override
  Set<Column> get primaryKey => {id};
}
