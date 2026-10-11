// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banco.dart';

// ignore_for_file: type=lint
class $LeiturasTable extends Leituras with TableInfo<$LeiturasTable, Leitura> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeiturasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formatoMeta = const VerificationMeta(
    'formato',
  );
  @override
  late final GeneratedColumn<String> formato = GeneratedColumn<String>(
    'formato',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lidoEmMeta = const VerificationMeta('lidoEm');
  @override
  late final GeneratedColumn<DateTime> lidoEm = GeneratedColumn<DateTime>(
    'lido_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, codigo, formato, lidoEm];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leituras';
  @override
  VerificationContext validateIntegrity(
    Insertable<Leitura> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('formato')) {
      context.handle(
        _formatoMeta,
        formato.isAcceptableOrUnknown(data['formato']!, _formatoMeta),
      );
    } else if (isInserting) {
      context.missing(_formatoMeta);
    }
    if (data.containsKey('lido_em')) {
      context.handle(
        _lidoEmMeta,
        lidoEm.isAcceptableOrUnknown(data['lido_em']!, _lidoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_lidoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Leitura map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Leitura(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      formato: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formato'],
      )!,
      lidoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lido_em'],
      )!,
    );
  }

  @override
  $LeiturasTable createAlias(String alias) {
    return $LeiturasTable(attachedDatabase, alias);
  }
}

class Leitura extends DataClass implements Insertable<Leitura> {
  final String id;
  final String codigo;
  final String formato;
  final DateTime lidoEm;
  const Leitura({
    required this.id,
    required this.codigo,
    required this.formato,
    required this.lidoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['codigo'] = Variable<String>(codigo);
    map['formato'] = Variable<String>(formato);
    map['lido_em'] = Variable<DateTime>(lidoEm);
    return map;
  }

  LeiturasCompanion toCompanion(bool nullToAbsent) {
    return LeiturasCompanion(
      id: Value(id),
      codigo: Value(codigo),
      formato: Value(formato),
      lidoEm: Value(lidoEm),
    );
  }

  factory Leitura.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Leitura(
      id: serializer.fromJson<String>(json['id']),
      codigo: serializer.fromJson<String>(json['codigo']),
      formato: serializer.fromJson<String>(json['formato']),
      lidoEm: serializer.fromJson<DateTime>(json['lidoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'codigo': serializer.toJson<String>(codigo),
      'formato': serializer.toJson<String>(formato),
      'lidoEm': serializer.toJson<DateTime>(lidoEm),
    };
  }

  Leitura copyWith({
    String? id,
    String? codigo,
    String? formato,
    DateTime? lidoEm,
  }) => Leitura(
    id: id ?? this.id,
    codigo: codigo ?? this.codigo,
    formato: formato ?? this.formato,
    lidoEm: lidoEm ?? this.lidoEm,
  );
  Leitura copyWithCompanion(LeiturasCompanion data) {
    return Leitura(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      formato: data.formato.present ? data.formato.value : this.formato,
      lidoEm: data.lidoEm.present ? data.lidoEm.value : this.lidoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Leitura(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('formato: $formato, ')
          ..write('lidoEm: $lidoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, codigo, formato, lidoEm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Leitura &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.formato == this.formato &&
          other.lidoEm == this.lidoEm);
}

class LeiturasCompanion extends UpdateCompanion<Leitura> {
  final Value<String> id;
  final Value<String> codigo;
  final Value<String> formato;
  final Value<DateTime> lidoEm;
  final Value<int> rowid;
  const LeiturasCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.formato = const Value.absent(),
    this.lidoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeiturasCompanion.insert({
    required String id,
    required String codigo,
    required String formato,
    required DateTime lidoEm,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       codigo = Value(codigo),
       formato = Value(formato),
       lidoEm = Value(lidoEm);
  static Insertable<Leitura> custom({
    Expression<String>? id,
    Expression<String>? codigo,
    Expression<String>? formato,
    Expression<DateTime>? lidoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (formato != null) 'formato': formato,
      if (lidoEm != null) 'lido_em': lidoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeiturasCompanion copyWith({
    Value<String>? id,
    Value<String>? codigo,
    Value<String>? formato,
    Value<DateTime>? lidoEm,
    Value<int>? rowid,
  }) {
    return LeiturasCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      formato: formato ?? this.formato,
      lidoEm: lidoEm ?? this.lidoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (formato.present) {
      map['formato'] = Variable<String>(formato.value);
    }
    if (lidoEm.present) {
      map['lido_em'] = Variable<DateTime>(lidoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeiturasCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('formato: $formato, ')
          ..write('lidoEm: $lidoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Banco extends GeneratedDatabase {
  _$Banco(QueryExecutor e) : super(e);
  $BancoManager get managers => $BancoManager(this);
  late final $LeiturasTable leituras = $LeiturasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [leituras];
}

typedef $$LeiturasTableCreateCompanionBuilder = LeiturasCompanion Function({
  required String id,
  required String codigo,
  required String formato,
  required DateTime lidoEm,
  Value<int> rowid,
});
typedef $$LeiturasTableUpdateCompanionBuilder = LeiturasCompanion Function({
  Value<String> id,
  Value<String> codigo,
  Value<String> formato,
  Value<DateTime> lidoEm,
  Value<int> rowid,
});

class $$LeiturasTableFilterComposer extends Composer<_$Banco, $LeiturasTable> {
  $$LeiturasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formato => $composableBuilder(
    column: $table.formato,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lidoEm => $composableBuilder(
    column: $table.lidoEm,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeiturasTableOrderingComposer
    extends Composer<_$Banco, $LeiturasTable> {
  $$LeiturasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formato => $composableBuilder(
    column: $table.formato,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lidoEm => $composableBuilder(
    column: $table.lidoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeiturasTableAnnotationComposer
    extends Composer<_$Banco, $LeiturasTable> {
  $$LeiturasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get formato =>
      $composableBuilder(column: $table.formato, builder: (column) => column);

  GeneratedColumn<DateTime> get lidoEm =>
      $composableBuilder(column: $table.lidoEm, builder: (column) => column);
}

class $$LeiturasTableTableManager
    extends
        RootTableManager<
          _$Banco,
          $LeiturasTable,
          Leitura,
          $$LeiturasTableFilterComposer,
          $$LeiturasTableOrderingComposer,
          $$LeiturasTableAnnotationComposer,
          $$LeiturasTableCreateCompanionBuilder,
          $$LeiturasTableUpdateCompanionBuilder,
          (Leitura, BaseReferences<_$Banco, $LeiturasTable, Leitura>),
          Leitura,
          PrefetchHooks Function()
        > {
  $$LeiturasTableTableManager(_$Banco db, $LeiturasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeiturasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeiturasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeiturasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String> formato = const Value.absent(),
                Value<DateTime> lidoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeiturasCompanion(
                id: id,
                codigo: codigo,
                formato: formato,
                lidoEm: lidoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String codigo,
                required String formato,
                required DateTime lidoEm,
                Value<int> rowid = const Value.absent(),
              }) => LeiturasCompanion.insert(
                id: id,
                codigo: codigo,
                formato: formato,
                lidoEm: lidoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeiturasTable, Leitura>(table),
                  BaseReferences<_$Banco, $LeiturasTable, Leitura>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeiturasTableProcessedTableManager =
    ProcessedTableManager<
      _$Banco,
      $LeiturasTable,
      Leitura,
      $$LeiturasTableFilterComposer,
      $$LeiturasTableOrderingComposer,
      $$LeiturasTableAnnotationComposer,
      $$LeiturasTableCreateCompanionBuilder,
      $$LeiturasTableUpdateCompanionBuilder,
      (Leitura, BaseReferences<_$Banco, $LeiturasTable, Leitura>),
      Leitura,
      PrefetchHooks Function()
    >;

class $BancoManager {
  final _$Banco _db;
  $BancoManager(this._db);
  $$LeiturasTableTableManager get leituras =>
      $$LeiturasTableTableManager(_db, _db.leituras);
}
