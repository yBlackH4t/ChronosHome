// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banco.dart';

// ignore_for_file: type=lint
class $ProdutosTable extends Produtos with TableInfo<$ProdutosTable, Produto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdutosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
    'marca',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fotoMeta = const VerificationMeta('foto');
  @override
  late final GeneratedColumn<String> foto = GeneratedColumn<String>(
    'foto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estoqueMinimoMeta = const VerificationMeta(
    'estoqueMinimo',
  );
  @override
  late final GeneratedColumn<int> estoqueMinimo = GeneratedColumn<int>(
    'estoque_minimo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _diasValidadeAbertoMeta =
      const VerificationMeta('diasValidadeAberto');
  @override
  late final GeneratedColumn<int> diasValidadeAberto = GeneratedColumn<int>(
    'dias_validade_aberto',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _criadoEmMeta = const VerificationMeta(
    'criadoEm',
  );
  @override
  late final GeneratedColumn<DateTime> criadoEm = GeneratedColumn<DateTime>(
    'criado_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    marca,
    categoria,
    foto,
    estoqueMinimo,
    diasValidadeAberto,
    criadoEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produtos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Produto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
        _marcaMeta,
        marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta),
      );
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('foto')) {
      context.handle(
        _fotoMeta,
        foto.isAcceptableOrUnknown(data['foto']!, _fotoMeta),
      );
    }
    if (data.containsKey('estoque_minimo')) {
      context.handle(
        _estoqueMinimoMeta,
        estoqueMinimo.isAcceptableOrUnknown(
          data['estoque_minimo']!,
          _estoqueMinimoMeta,
        ),
      );
    }
    if (data.containsKey('dias_validade_aberto')) {
      context.handle(
        _diasValidadeAbertoMeta,
        diasValidadeAberto.isAcceptableOrUnknown(
          data['dias_validade_aberto']!,
          _diasValidadeAbertoMeta,
        ),
      );
    }
    if (data.containsKey('criado_em')) {
      context.handle(
        _criadoEmMeta,
        criadoEm.isAcceptableOrUnknown(data['criado_em']!, _criadoEmMeta),
      );
    } else if (isInserting) {
      context.missing(_criadoEmMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Produto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Produto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      marca: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}marca'],
      ),
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      ),
      foto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto'],
      ),
      estoqueMinimo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estoque_minimo'],
      )!,
      diasValidadeAberto: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dias_validade_aberto'],
      ),
      criadoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}criado_em'],
      )!,
    );
  }

  @override
  $ProdutosTable createAlias(String alias) {
    return $ProdutosTable(attachedDatabase, alias);
  }
}

class Produto extends DataClass implements Insertable<Produto> {
  final String id;
  final String nome;
  final String? marca;
  final String? categoria;

  /// Endereço da foto (Open Food Facts) ou caminho de um arquivo no celular.
  final String? foto;

  /// Abaixo disso o produto entra na lista de compras.
  final int estoqueMinimo;

  /// Depois de aberto, dura quantos dias (ex.: maionese, 5). Vazio = não avisa.
  final int? diasValidadeAberto;
  final DateTime criadoEm;
  const Produto({
    required this.id,
    required this.nome,
    this.marca,
    this.categoria,
    this.foto,
    required this.estoqueMinimo,
    this.diasValidadeAberto,
    required this.criadoEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || marca != null) {
      map['marca'] = Variable<String>(marca);
    }
    if (!nullToAbsent || categoria != null) {
      map['categoria'] = Variable<String>(categoria);
    }
    if (!nullToAbsent || foto != null) {
      map['foto'] = Variable<String>(foto);
    }
    map['estoque_minimo'] = Variable<int>(estoqueMinimo);
    if (!nullToAbsent || diasValidadeAberto != null) {
      map['dias_validade_aberto'] = Variable<int>(diasValidadeAberto);
    }
    map['criado_em'] = Variable<DateTime>(criadoEm);
    return map;
  }

  ProdutosCompanion toCompanion(bool nullToAbsent) {
    return ProdutosCompanion(
      id: Value(id),
      nome: Value(nome),
      marca: marca == null && nullToAbsent
          ? const Value.absent()
          : Value(marca),
      categoria: categoria == null && nullToAbsent
          ? const Value.absent()
          : Value(categoria),
      foto: foto == null && nullToAbsent ? const Value.absent() : Value(foto),
      estoqueMinimo: Value(estoqueMinimo),
      diasValidadeAberto: diasValidadeAberto == null && nullToAbsent
          ? const Value.absent()
          : Value(diasValidadeAberto),
      criadoEm: Value(criadoEm),
    );
  }

  factory Produto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Produto(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      marca: serializer.fromJson<String?>(json['marca']),
      categoria: serializer.fromJson<String?>(json['categoria']),
      foto: serializer.fromJson<String?>(json['foto']),
      estoqueMinimo: serializer.fromJson<int>(json['estoqueMinimo']),
      diasValidadeAberto: serializer.fromJson<int?>(json['diasValidadeAberto']),
      criadoEm: serializer.fromJson<DateTime>(json['criadoEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'marca': serializer.toJson<String?>(marca),
      'categoria': serializer.toJson<String?>(categoria),
      'foto': serializer.toJson<String?>(foto),
      'estoqueMinimo': serializer.toJson<int>(estoqueMinimo),
      'diasValidadeAberto': serializer.toJson<int?>(diasValidadeAberto),
      'criadoEm': serializer.toJson<DateTime>(criadoEm),
    };
  }

  Produto copyWith({
    String? id,
    String? nome,
    Value<String?> marca = const Value.absent(),
    Value<String?> categoria = const Value.absent(),
    Value<String?> foto = const Value.absent(),
    int? estoqueMinimo,
    Value<int?> diasValidadeAberto = const Value.absent(),
    DateTime? criadoEm,
  }) => Produto(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    marca: marca.present ? marca.value : this.marca,
    categoria: categoria.present ? categoria.value : this.categoria,
    foto: foto.present ? foto.value : this.foto,
    estoqueMinimo: estoqueMinimo ?? this.estoqueMinimo,
    diasValidadeAberto: diasValidadeAberto.present
        ? diasValidadeAberto.value
        : this.diasValidadeAberto,
    criadoEm: criadoEm ?? this.criadoEm,
  );
  Produto copyWithCompanion(ProdutosCompanion data) {
    return Produto(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      marca: data.marca.present ? data.marca.value : this.marca,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      foto: data.foto.present ? data.foto.value : this.foto,
      estoqueMinimo: data.estoqueMinimo.present
          ? data.estoqueMinimo.value
          : this.estoqueMinimo,
      diasValidadeAberto: data.diasValidadeAberto.present
          ? data.diasValidadeAberto.value
          : this.diasValidadeAberto,
      criadoEm: data.criadoEm.present ? data.criadoEm.value : this.criadoEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Produto(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('marca: $marca, ')
          ..write('categoria: $categoria, ')
          ..write('foto: $foto, ')
          ..write('estoqueMinimo: $estoqueMinimo, ')
          ..write('diasValidadeAberto: $diasValidadeAberto, ')
          ..write('criadoEm: $criadoEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    marca,
    categoria,
    foto,
    estoqueMinimo,
    diasValidadeAberto,
    criadoEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Produto &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.marca == this.marca &&
          other.categoria == this.categoria &&
          other.foto == this.foto &&
          other.estoqueMinimo == this.estoqueMinimo &&
          other.diasValidadeAberto == this.diasValidadeAberto &&
          other.criadoEm == this.criadoEm);
}

class ProdutosCompanion extends UpdateCompanion<Produto> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String?> marca;
  final Value<String?> categoria;
  final Value<String?> foto;
  final Value<int> estoqueMinimo;
  final Value<int?> diasValidadeAberto;
  final Value<DateTime> criadoEm;
  final Value<int> rowid;
  const ProdutosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.marca = const Value.absent(),
    this.categoria = const Value.absent(),
    this.foto = const Value.absent(),
    this.estoqueMinimo = const Value.absent(),
    this.diasValidadeAberto = const Value.absent(),
    this.criadoEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProdutosCompanion.insert({
    required String id,
    required String nome,
    this.marca = const Value.absent(),
    this.categoria = const Value.absent(),
    this.foto = const Value.absent(),
    this.estoqueMinimo = const Value.absent(),
    this.diasValidadeAberto = const Value.absent(),
    required DateTime criadoEm,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nome = Value(nome),
       criadoEm = Value(criadoEm);
  static Insertable<Produto> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? marca,
    Expression<String>? categoria,
    Expression<String>? foto,
    Expression<int>? estoqueMinimo,
    Expression<int>? diasValidadeAberto,
    Expression<DateTime>? criadoEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (marca != null) 'marca': marca,
      if (categoria != null) 'categoria': categoria,
      if (foto != null) 'foto': foto,
      if (estoqueMinimo != null) 'estoque_minimo': estoqueMinimo,
      if (diasValidadeAberto != null)
        'dias_validade_aberto': diasValidadeAberto,
      if (criadoEm != null) 'criado_em': criadoEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProdutosCompanion copyWith({
    Value<String>? id,
    Value<String>? nome,
    Value<String?>? marca,
    Value<String?>? categoria,
    Value<String?>? foto,
    Value<int>? estoqueMinimo,
    Value<int?>? diasValidadeAberto,
    Value<DateTime>? criadoEm,
    Value<int>? rowid,
  }) {
    return ProdutosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      marca: marca ?? this.marca,
      categoria: categoria ?? this.categoria,
      foto: foto ?? this.foto,
      estoqueMinimo: estoqueMinimo ?? this.estoqueMinimo,
      diasValidadeAberto: diasValidadeAberto ?? this.diasValidadeAberto,
      criadoEm: criadoEm ?? this.criadoEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (foto.present) {
      map['foto'] = Variable<String>(foto.value);
    }
    if (estoqueMinimo.present) {
      map['estoque_minimo'] = Variable<int>(estoqueMinimo.value);
    }
    if (diasValidadeAberto.present) {
      map['dias_validade_aberto'] = Variable<int>(diasValidadeAberto.value);
    }
    if (criadoEm.present) {
      map['criado_em'] = Variable<DateTime>(criadoEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdutosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('marca: $marca, ')
          ..write('categoria: $categoria, ')
          ..write('foto: $foto, ')
          ..write('estoqueMinimo: $estoqueMinimo, ')
          ..write('diasValidadeAberto: $diasValidadeAberto, ')
          ..write('criadoEm: $criadoEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CodigosBarrasTable extends CodigosBarras
    with TableInfo<$CodigosBarrasTable, CodigoBarras> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CodigosBarrasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produtoIdMeta = const VerificationMeta(
    'produtoId',
  );
  @override
  late final GeneratedColumn<String> produtoId = GeneratedColumn<String>(
    'produto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES produtos (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [codigo, produtoId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'codigos_barras';
  @override
  VerificationContext validateIntegrity(
    Insertable<CodigoBarras> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('produto_id')) {
      context.handle(
        _produtoIdMeta,
        produtoId.isAcceptableOrUnknown(data['produto_id']!, _produtoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produtoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {codigo};
  @override
  CodigoBarras map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CodigoBarras(
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      produtoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produto_id'],
      )!,
    );
  }

  @override
  $CodigosBarrasTable createAlias(String alias) {
    return $CodigosBarrasTable(attachedDatabase, alias);
  }
}

class CodigoBarras extends DataClass implements Insertable<CodigoBarras> {
  final String codigo;
  final String produtoId;
  const CodigoBarras({required this.codigo, required this.produtoId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['codigo'] = Variable<String>(codigo);
    map['produto_id'] = Variable<String>(produtoId);
    return map;
  }

  CodigosBarrasCompanion toCompanion(bool nullToAbsent) {
    return CodigosBarrasCompanion(
      codigo: Value(codigo),
      produtoId: Value(produtoId),
    );
  }

  factory CodigoBarras.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CodigoBarras(
      codigo: serializer.fromJson<String>(json['codigo']),
      produtoId: serializer.fromJson<String>(json['produtoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'codigo': serializer.toJson<String>(codigo),
      'produtoId': serializer.toJson<String>(produtoId),
    };
  }

  CodigoBarras copyWith({String? codigo, String? produtoId}) => CodigoBarras(
    codigo: codigo ?? this.codigo,
    produtoId: produtoId ?? this.produtoId,
  );
  CodigoBarras copyWithCompanion(CodigosBarrasCompanion data) {
    return CodigoBarras(
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      produtoId: data.produtoId.present ? data.produtoId.value : this.produtoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CodigoBarras(')
          ..write('codigo: $codigo, ')
          ..write('produtoId: $produtoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(codigo, produtoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CodigoBarras &&
          other.codigo == this.codigo &&
          other.produtoId == this.produtoId);
}

class CodigosBarrasCompanion extends UpdateCompanion<CodigoBarras> {
  final Value<String> codigo;
  final Value<String> produtoId;
  final Value<int> rowid;
  const CodigosBarrasCompanion({
    this.codigo = const Value.absent(),
    this.produtoId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CodigosBarrasCompanion.insert({
    required String codigo,
    required String produtoId,
    this.rowid = const Value.absent(),
  }) : codigo = Value(codigo),
       produtoId = Value(produtoId);
  static Insertable<CodigoBarras> custom({
    Expression<String>? codigo,
    Expression<String>? produtoId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (codigo != null) 'codigo': codigo,
      if (produtoId != null) 'produto_id': produtoId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CodigosBarrasCompanion copyWith({
    Value<String>? codigo,
    Value<String>? produtoId,
    Value<int>? rowid,
  }) {
    return CodigosBarrasCompanion(
      codigo: codigo ?? this.codigo,
      produtoId: produtoId ?? this.produtoId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (produtoId.present) {
      map['produto_id'] = Variable<String>(produtoId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CodigosBarrasCompanion(')
          ..write('codigo: $codigo, ')
          ..write('produtoId: $produtoId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocaisTable extends Locais with TableInfo<$LocaisTable, Local> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocaisTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nome];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locais';
  @override
  VerificationContext validateIntegrity(
    Insertable<Local> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Local map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Local(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
    );
  }

  @override
  $LocaisTable createAlias(String alias) {
    return $LocaisTable(attachedDatabase, alias);
  }
}

class Local extends DataClass implements Insertable<Local> {
  final String id;
  final String nome;
  const Local({required this.id, required this.nome});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    return map;
  }

  LocaisCompanion toCompanion(bool nullToAbsent) {
    return LocaisCompanion(id: Value(id), nome: Value(nome));
  }

  factory Local.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Local(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
    };
  }

  Local copyWith({String? id, String? nome}) =>
      Local(id: id ?? this.id, nome: nome ?? this.nome);
  Local copyWithCompanion(LocaisCompanion data) {
    return Local(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Local(')
          ..write('id: $id, ')
          ..write('nome: $nome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Local && other.id == this.id && other.nome == this.nome);
}

class LocaisCompanion extends UpdateCompanion<Local> {
  final Value<String> id;
  final Value<String> nome;
  final Value<int> rowid;
  const LocaisCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocaisCompanion.insert({
    required String id,
    required String nome,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nome = Value(nome);
  static Insertable<Local> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocaisCompanion copyWith({
    Value<String>? id,
    Value<String>? nome,
    Value<int>? rowid,
  }) {
    return LocaisCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocaisCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnidadesTable extends Unidades with TableInfo<$UnidadesTable, Unidade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnidadesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produtoIdMeta = const VerificationMeta(
    'produtoId',
  );
  @override
  late final GeneratedColumn<String> produtoId = GeneratedColumn<String>(
    'produto_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES produtos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locais (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EstadoUnidade, String> estado =
      GeneratedColumn<String>(
        'estado',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EstadoUnidade>($UnidadesTable.$converterestado);
  static const VerificationMeta _entrouEmMeta = const VerificationMeta(
    'entrouEm',
  );
  @override
  late final GeneratedColumn<DateTime> entrouEm = GeneratedColumn<DateTime>(
    'entrou_em',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abertoEmMeta = const VerificationMeta(
    'abertoEm',
  );
  @override
  late final GeneratedColumn<DateTime> abertoEm = GeneratedColumn<DateTime>(
    'aberto_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saiuEmMeta = const VerificationMeta('saiuEm');
  @override
  late final GeneratedColumn<DateTime> saiuEm = GeneratedColumn<DateTime>(
    'saiu_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _venceEmMeta = const VerificationMeta(
    'venceEm',
  );
  @override
  late final GeneratedColumn<DateTime> venceEm = GeneratedColumn<DateTime>(
    'vence_em',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    produtoId,
    localId,
    estado,
    entrouEm,
    abertoEm,
    saiuEm,
    venceEm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unidades';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unidade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('produto_id')) {
      context.handle(
        _produtoIdMeta,
        produtoId.isAcceptableOrUnknown(data['produto_id']!, _produtoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produtoIdMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('entrou_em')) {
      context.handle(
        _entrouEmMeta,
        entrouEm.isAcceptableOrUnknown(data['entrou_em']!, _entrouEmMeta),
      );
    } else if (isInserting) {
      context.missing(_entrouEmMeta);
    }
    if (data.containsKey('aberto_em')) {
      context.handle(
        _abertoEmMeta,
        abertoEm.isAcceptableOrUnknown(data['aberto_em']!, _abertoEmMeta),
      );
    }
    if (data.containsKey('saiu_em')) {
      context.handle(
        _saiuEmMeta,
        saiuEm.isAcceptableOrUnknown(data['saiu_em']!, _saiuEmMeta),
      );
    }
    if (data.containsKey('vence_em')) {
      context.handle(
        _venceEmMeta,
        venceEm.isAcceptableOrUnknown(data['vence_em']!, _venceEmMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unidade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unidade(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      produtoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produto_id'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      ),
      estado: $UnidadesTable.$converterestado.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}estado'],
        )!,
      ),
      entrouEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entrou_em'],
      )!,
      abertoEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}aberto_em'],
      ),
      saiuEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saiu_em'],
      ),
      venceEm: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}vence_em'],
      ),
    );
  }

  @override
  $UnidadesTable createAlias(String alias) {
    return $UnidadesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EstadoUnidade, String, String> $converterestado =
      const EnumNameConverter<EstadoUnidade>(EstadoUnidade.values);
}

class Unidade extends DataClass implements Insertable<Unidade> {
  final String id;
  final String produtoId;
  final String? localId;
  final EstadoUnidade estado;
  final DateTime entrouEm;
  final DateTime? abertoEm;

  /// Quando acabou ou foi descartada.
  final DateTime? saiuEm;

  /// Validade impressa na embalagem (opcional).
  final DateTime? venceEm;
  const Unidade({
    required this.id,
    required this.produtoId,
    this.localId,
    required this.estado,
    required this.entrouEm,
    this.abertoEm,
    this.saiuEm,
    this.venceEm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['produto_id'] = Variable<String>(produtoId);
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    {
      map['estado'] = Variable<String>(
        $UnidadesTable.$converterestado.toSql(estado),
      );
    }
    map['entrou_em'] = Variable<DateTime>(entrouEm);
    if (!nullToAbsent || abertoEm != null) {
      map['aberto_em'] = Variable<DateTime>(abertoEm);
    }
    if (!nullToAbsent || saiuEm != null) {
      map['saiu_em'] = Variable<DateTime>(saiuEm);
    }
    if (!nullToAbsent || venceEm != null) {
      map['vence_em'] = Variable<DateTime>(venceEm);
    }
    return map;
  }

  UnidadesCompanion toCompanion(bool nullToAbsent) {
    return UnidadesCompanion(
      id: Value(id),
      produtoId: Value(produtoId),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      estado: Value(estado),
      entrouEm: Value(entrouEm),
      abertoEm: abertoEm == null && nullToAbsent
          ? const Value.absent()
          : Value(abertoEm),
      saiuEm: saiuEm == null && nullToAbsent
          ? const Value.absent()
          : Value(saiuEm),
      venceEm: venceEm == null && nullToAbsent
          ? const Value.absent()
          : Value(venceEm),
    );
  }

  factory Unidade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unidade(
      id: serializer.fromJson<String>(json['id']),
      produtoId: serializer.fromJson<String>(json['produtoId']),
      localId: serializer.fromJson<String?>(json['localId']),
      estado: $UnidadesTable.$converterestado.fromJson(
        serializer.fromJson<String>(json['estado']),
      ),
      entrouEm: serializer.fromJson<DateTime>(json['entrouEm']),
      abertoEm: serializer.fromJson<DateTime?>(json['abertoEm']),
      saiuEm: serializer.fromJson<DateTime?>(json['saiuEm']),
      venceEm: serializer.fromJson<DateTime?>(json['venceEm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'produtoId': serializer.toJson<String>(produtoId),
      'localId': serializer.toJson<String?>(localId),
      'estado': serializer.toJson<String>(
        $UnidadesTable.$converterestado.toJson(estado),
      ),
      'entrouEm': serializer.toJson<DateTime>(entrouEm),
      'abertoEm': serializer.toJson<DateTime?>(abertoEm),
      'saiuEm': serializer.toJson<DateTime?>(saiuEm),
      'venceEm': serializer.toJson<DateTime?>(venceEm),
    };
  }

  Unidade copyWith({
    String? id,
    String? produtoId,
    Value<String?> localId = const Value.absent(),
    EstadoUnidade? estado,
    DateTime? entrouEm,
    Value<DateTime?> abertoEm = const Value.absent(),
    Value<DateTime?> saiuEm = const Value.absent(),
    Value<DateTime?> venceEm = const Value.absent(),
  }) => Unidade(
    id: id ?? this.id,
    produtoId: produtoId ?? this.produtoId,
    localId: localId.present ? localId.value : this.localId,
    estado: estado ?? this.estado,
    entrouEm: entrouEm ?? this.entrouEm,
    abertoEm: abertoEm.present ? abertoEm.value : this.abertoEm,
    saiuEm: saiuEm.present ? saiuEm.value : this.saiuEm,
    venceEm: venceEm.present ? venceEm.value : this.venceEm,
  );
  Unidade copyWithCompanion(UnidadesCompanion data) {
    return Unidade(
      id: data.id.present ? data.id.value : this.id,
      produtoId: data.produtoId.present ? data.produtoId.value : this.produtoId,
      localId: data.localId.present ? data.localId.value : this.localId,
      estado: data.estado.present ? data.estado.value : this.estado,
      entrouEm: data.entrouEm.present ? data.entrouEm.value : this.entrouEm,
      abertoEm: data.abertoEm.present ? data.abertoEm.value : this.abertoEm,
      saiuEm: data.saiuEm.present ? data.saiuEm.value : this.saiuEm,
      venceEm: data.venceEm.present ? data.venceEm.value : this.venceEm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unidade(')
          ..write('id: $id, ')
          ..write('produtoId: $produtoId, ')
          ..write('localId: $localId, ')
          ..write('estado: $estado, ')
          ..write('entrouEm: $entrouEm, ')
          ..write('abertoEm: $abertoEm, ')
          ..write('saiuEm: $saiuEm, ')
          ..write('venceEm: $venceEm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    produtoId,
    localId,
    estado,
    entrouEm,
    abertoEm,
    saiuEm,
    venceEm,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unidade &&
          other.id == this.id &&
          other.produtoId == this.produtoId &&
          other.localId == this.localId &&
          other.estado == this.estado &&
          other.entrouEm == this.entrouEm &&
          other.abertoEm == this.abertoEm &&
          other.saiuEm == this.saiuEm &&
          other.venceEm == this.venceEm);
}

class UnidadesCompanion extends UpdateCompanion<Unidade> {
  final Value<String> id;
  final Value<String> produtoId;
  final Value<String?> localId;
  final Value<EstadoUnidade> estado;
  final Value<DateTime> entrouEm;
  final Value<DateTime?> abertoEm;
  final Value<DateTime?> saiuEm;
  final Value<DateTime?> venceEm;
  final Value<int> rowid;
  const UnidadesCompanion({
    this.id = const Value.absent(),
    this.produtoId = const Value.absent(),
    this.localId = const Value.absent(),
    this.estado = const Value.absent(),
    this.entrouEm = const Value.absent(),
    this.abertoEm = const Value.absent(),
    this.saiuEm = const Value.absent(),
    this.venceEm = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnidadesCompanion.insert({
    required String id,
    required String produtoId,
    this.localId = const Value.absent(),
    required EstadoUnidade estado,
    required DateTime entrouEm,
    this.abertoEm = const Value.absent(),
    this.saiuEm = const Value.absent(),
    this.venceEm = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       produtoId = Value(produtoId),
       estado = Value(estado),
       entrouEm = Value(entrouEm);
  static Insertable<Unidade> custom({
    Expression<String>? id,
    Expression<String>? produtoId,
    Expression<String>? localId,
    Expression<String>? estado,
    Expression<DateTime>? entrouEm,
    Expression<DateTime>? abertoEm,
    Expression<DateTime>? saiuEm,
    Expression<DateTime>? venceEm,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (produtoId != null) 'produto_id': produtoId,
      if (localId != null) 'local_id': localId,
      if (estado != null) 'estado': estado,
      if (entrouEm != null) 'entrou_em': entrouEm,
      if (abertoEm != null) 'aberto_em': abertoEm,
      if (saiuEm != null) 'saiu_em': saiuEm,
      if (venceEm != null) 'vence_em': venceEm,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnidadesCompanion copyWith({
    Value<String>? id,
    Value<String>? produtoId,
    Value<String?>? localId,
    Value<EstadoUnidade>? estado,
    Value<DateTime>? entrouEm,
    Value<DateTime?>? abertoEm,
    Value<DateTime?>? saiuEm,
    Value<DateTime?>? venceEm,
    Value<int>? rowid,
  }) {
    return UnidadesCompanion(
      id: id ?? this.id,
      produtoId: produtoId ?? this.produtoId,
      localId: localId ?? this.localId,
      estado: estado ?? this.estado,
      entrouEm: entrouEm ?? this.entrouEm,
      abertoEm: abertoEm ?? this.abertoEm,
      saiuEm: saiuEm ?? this.saiuEm,
      venceEm: venceEm ?? this.venceEm,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (produtoId.present) {
      map['produto_id'] = Variable<String>(produtoId.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(
        $UnidadesTable.$converterestado.toSql(estado.value),
      );
    }
    if (entrouEm.present) {
      map['entrou_em'] = Variable<DateTime>(entrouEm.value);
    }
    if (abertoEm.present) {
      map['aberto_em'] = Variable<DateTime>(abertoEm.value);
    }
    if (saiuEm.present) {
      map['saiu_em'] = Variable<DateTime>(saiuEm.value);
    }
    if (venceEm.present) {
      map['vence_em'] = Variable<DateTime>(venceEm.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnidadesCompanion(')
          ..write('id: $id, ')
          ..write('produtoId: $produtoId, ')
          ..write('localId: $localId, ')
          ..write('estado: $estado, ')
          ..write('entrouEm: $entrouEm, ')
          ..write('abertoEm: $abertoEm, ')
          ..write('saiuEm: $saiuEm, ')
          ..write('venceEm: $venceEm, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MovimentosTable extends Movimentos
    with TableInfo<$MovimentosTable, Movimento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimentosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unidadeIdMeta = const VerificationMeta(
    'unidadeId',
  );
  @override
  late final GeneratedColumn<String> unidadeId = GeneratedColumn<String>(
    'unidade_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES unidades (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AcaoMovimento, String> acao =
      GeneratedColumn<String>(
        'acao',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AcaoMovimento>($MovimentosTable.$converteracao);
  static const VerificationMeta _quandoMeta = const VerificationMeta('quando');
  @override
  late final GeneratedColumn<DateTime> quando = GeneratedColumn<DateTime>(
    'quando',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locais (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, unidadeId, acao, quando, localId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimentos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Movimento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('unidade_id')) {
      context.handle(
        _unidadeIdMeta,
        unidadeId.isAcceptableOrUnknown(data['unidade_id']!, _unidadeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unidadeIdMeta);
    }
    if (data.containsKey('quando')) {
      context.handle(
        _quandoMeta,
        quando.isAcceptableOrUnknown(data['quando']!, _quandoMeta),
      );
    } else if (isInserting) {
      context.missing(_quandoMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movimento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Movimento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      unidadeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidade_id'],
      )!,
      acao: $MovimentosTable.$converteracao.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}acao'],
        )!,
      ),
      quando: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}quando'],
      )!,
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      ),
    );
  }

  @override
  $MovimentosTable createAlias(String alias) {
    return $MovimentosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AcaoMovimento, String, String> $converteracao =
      const EnumNameConverter<AcaoMovimento>(AcaoMovimento.values);
}

class Movimento extends DataClass implements Insertable<Movimento> {
  final String id;
  final String unidadeId;
  final AcaoMovimento acao;
  final DateTime quando;

  /// Para "mover": o local de destino.
  final String? localId;
  const Movimento({
    required this.id,
    required this.unidadeId,
    required this.acao,
    required this.quando,
    this.localId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unidade_id'] = Variable<String>(unidadeId);
    {
      map['acao'] = Variable<String>(
        $MovimentosTable.$converteracao.toSql(acao),
      );
    }
    map['quando'] = Variable<DateTime>(quando);
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    return map;
  }

  MovimentosCompanion toCompanion(bool nullToAbsent) {
    return MovimentosCompanion(
      id: Value(id),
      unidadeId: Value(unidadeId),
      acao: Value(acao),
      quando: Value(quando),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
    );
  }

  factory Movimento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Movimento(
      id: serializer.fromJson<String>(json['id']),
      unidadeId: serializer.fromJson<String>(json['unidadeId']),
      acao: $MovimentosTable.$converteracao.fromJson(
        serializer.fromJson<String>(json['acao']),
      ),
      quando: serializer.fromJson<DateTime>(json['quando']),
      localId: serializer.fromJson<String?>(json['localId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unidadeId': serializer.toJson<String>(unidadeId),
      'acao': serializer.toJson<String>(
        $MovimentosTable.$converteracao.toJson(acao),
      ),
      'quando': serializer.toJson<DateTime>(quando),
      'localId': serializer.toJson<String?>(localId),
    };
  }

  Movimento copyWith({
    String? id,
    String? unidadeId,
    AcaoMovimento? acao,
    DateTime? quando,
    Value<String?> localId = const Value.absent(),
  }) => Movimento(
    id: id ?? this.id,
    unidadeId: unidadeId ?? this.unidadeId,
    acao: acao ?? this.acao,
    quando: quando ?? this.quando,
    localId: localId.present ? localId.value : this.localId,
  );
  Movimento copyWithCompanion(MovimentosCompanion data) {
    return Movimento(
      id: data.id.present ? data.id.value : this.id,
      unidadeId: data.unidadeId.present ? data.unidadeId.value : this.unidadeId,
      acao: data.acao.present ? data.acao.value : this.acao,
      quando: data.quando.present ? data.quando.value : this.quando,
      localId: data.localId.present ? data.localId.value : this.localId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Movimento(')
          ..write('id: $id, ')
          ..write('unidadeId: $unidadeId, ')
          ..write('acao: $acao, ')
          ..write('quando: $quando, ')
          ..write('localId: $localId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, unidadeId, acao, quando, localId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movimento &&
          other.id == this.id &&
          other.unidadeId == this.unidadeId &&
          other.acao == this.acao &&
          other.quando == this.quando &&
          other.localId == this.localId);
}

class MovimentosCompanion extends UpdateCompanion<Movimento> {
  final Value<String> id;
  final Value<String> unidadeId;
  final Value<AcaoMovimento> acao;
  final Value<DateTime> quando;
  final Value<String?> localId;
  final Value<int> rowid;
  const MovimentosCompanion({
    this.id = const Value.absent(),
    this.unidadeId = const Value.absent(),
    this.acao = const Value.absent(),
    this.quando = const Value.absent(),
    this.localId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovimentosCompanion.insert({
    required String id,
    required String unidadeId,
    required AcaoMovimento acao,
    required DateTime quando,
    this.localId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       unidadeId = Value(unidadeId),
       acao = Value(acao),
       quando = Value(quando);
  static Insertable<Movimento> custom({
    Expression<String>? id,
    Expression<String>? unidadeId,
    Expression<String>? acao,
    Expression<DateTime>? quando,
    Expression<String>? localId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unidadeId != null) 'unidade_id': unidadeId,
      if (acao != null) 'acao': acao,
      if (quando != null) 'quando': quando,
      if (localId != null) 'local_id': localId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovimentosCompanion copyWith({
    Value<String>? id,
    Value<String>? unidadeId,
    Value<AcaoMovimento>? acao,
    Value<DateTime>? quando,
    Value<String?>? localId,
    Value<int>? rowid,
  }) {
    return MovimentosCompanion(
      id: id ?? this.id,
      unidadeId: unidadeId ?? this.unidadeId,
      acao: acao ?? this.acao,
      quando: quando ?? this.quando,
      localId: localId ?? this.localId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (unidadeId.present) {
      map['unidade_id'] = Variable<String>(unidadeId.value);
    }
    if (acao.present) {
      map['acao'] = Variable<String>(
        $MovimentosTable.$converteracao.toSql(acao.value),
      );
    }
    if (quando.present) {
      map['quando'] = Variable<DateTime>(quando.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimentosCompanion(')
          ..write('id: $id, ')
          ..write('unidadeId: $unidadeId, ')
          ..write('acao: $acao, ')
          ..write('quando: $quando, ')
          ..write('localId: $localId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

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
  late final $ProdutosTable produtos = $ProdutosTable(this);
  late final $CodigosBarrasTable codigosBarras = $CodigosBarrasTable(this);
  late final $LocaisTable locais = $LocaisTable(this);
  late final $UnidadesTable unidades = $UnidadesTable(this);
  late final $MovimentosTable movimentos = $MovimentosTable(this);
  late final $LeiturasTable leituras = $LeiturasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    produtos,
    codigosBarras,
    locais,
    unidades,
    movimentos,
    leituras,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'produtos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('codigos_barras', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'produtos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('unidades', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'locais',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('unidades', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'unidades',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movimentos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'locais',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movimentos', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$ProdutosTableCreateCompanionBuilder = ProdutosCompanion Function({
  required String id,
  required String nome,
  Value<String?> marca,
  Value<String?> categoria,
  Value<String?> foto,
  Value<int> estoqueMinimo,
  Value<int?> diasValidadeAberto,
  required DateTime criadoEm,
  Value<int> rowid,
});
typedef $$ProdutosTableUpdateCompanionBuilder = ProdutosCompanion Function({
  Value<String> id,
  Value<String> nome,
  Value<String?> marca,
  Value<String?> categoria,
  Value<String?> foto,
  Value<int> estoqueMinimo,
  Value<int?> diasValidadeAberto,
  Value<DateTime> criadoEm,
  Value<int> rowid,
});

final class $$ProdutosTableReferences
    extends BaseReferences<_$Banco, $ProdutosTable, Produto> {
  $$ProdutosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CodigosBarrasTable, List<CodigoBarras>>
  _codigosBarrasRefsTable(_$Banco db) => MultiTypedResultKey.fromTable(
    db.codigosBarras,
    aliasName: 'produtos__id__codigos_barras__produto_id',
  );

  $$CodigosBarrasTableProcessedTableManager get codigosBarrasRefs {
    final manager = $$CodigosBarrasTableTableManager(
      $_db,
      $_db.codigosBarras,
    ).filter((f) => f.produtoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_codigosBarrasRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UnidadesTable, List<Unidade>> _unidadesRefsTable(
    _$Banco db,
  ) => MultiTypedResultKey.fromTable(
    db.unidades,
    aliasName: 'produtos__id__unidades__produto_id',
  );

  $$UnidadesTableProcessedTableManager get unidadesRefs {
    final manager = $$UnidadesTableTableManager(
      $_db,
      $_db.unidades,
    ).filter((f) => f.produtoId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_unidadesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProdutosTableFilterComposer extends Composer<_$Banco, $ProdutosTable> {
  $$ProdutosTableFilterComposer({
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

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foto => $composableBuilder(
    column: $table.foto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estoqueMinimo => $composableBuilder(
    column: $table.estoqueMinimo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diasValidadeAberto => $composableBuilder(
    column: $table.diasValidadeAberto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> codigosBarrasRefs(
    Expression<bool> Function($$CodigosBarrasTableFilterComposer f) f,
  ) {
    final $$CodigosBarrasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.codigosBarras,
      getReferencedColumn: (t) => t.produtoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CodigosBarrasTableFilterComposer(
            $db: $db,
            $table: $db.codigosBarras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> unidadesRefs(
    Expression<bool> Function($$UnidadesTableFilterComposer f) f,
  ) {
    final $$UnidadesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unidades,
      getReferencedColumn: (t) => t.produtoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesTableFilterComposer(
            $db: $db,
            $table: $db.unidades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProdutosTableOrderingComposer
    extends Composer<_$Banco, $ProdutosTable> {
  $$ProdutosTableOrderingComposer({
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

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marca => $composableBuilder(
    column: $table.marca,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foto => $composableBuilder(
    column: $table.foto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estoqueMinimo => $composableBuilder(
    column: $table.estoqueMinimo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diasValidadeAberto => $composableBuilder(
    column: $table.diasValidadeAberto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get criadoEm => $composableBuilder(
    column: $table.criadoEm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProdutosTableAnnotationComposer
    extends Composer<_$Banco, $ProdutosTable> {
  $$ProdutosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get foto =>
      $composableBuilder(column: $table.foto, builder: (column) => column);

  GeneratedColumn<int> get estoqueMinimo => $composableBuilder(
    column: $table.estoqueMinimo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diasValidadeAberto => $composableBuilder(
    column: $table.diasValidadeAberto,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get criadoEm =>
      $composableBuilder(column: $table.criadoEm, builder: (column) => column);

  Expression<T> codigosBarrasRefs<T extends Object>(
    Expression<T> Function($$CodigosBarrasTableAnnotationComposer a) f,
  ) {
    final $$CodigosBarrasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.codigosBarras,
      getReferencedColumn: (t) => t.produtoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CodigosBarrasTableAnnotationComposer(
            $db: $db,
            $table: $db.codigosBarras,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> unidadesRefs<T extends Object>(
    Expression<T> Function($$UnidadesTableAnnotationComposer a) f,
  ) {
    final $$UnidadesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unidades,
      getReferencedColumn: (t) => t.produtoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesTableAnnotationComposer(
            $db: $db,
            $table: $db.unidades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProdutosTableTableManager
    extends
        RootTableManager<
          _$Banco,
          $ProdutosTable,
          Produto,
          $$ProdutosTableFilterComposer,
          $$ProdutosTableOrderingComposer,
          $$ProdutosTableAnnotationComposer,
          $$ProdutosTableCreateCompanionBuilder,
          $$ProdutosTableUpdateCompanionBuilder,
          (Produto, $$ProdutosTableReferences),
          Produto,
          PrefetchHooks Function({bool codigosBarrasRefs, bool unidadesRefs})
        > {
  $$ProdutosTableTableManager(_$Banco db, $ProdutosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdutosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdutosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdutosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String?> marca = const Value.absent(),
                Value<String?> categoria = const Value.absent(),
                Value<String?> foto = const Value.absent(),
                Value<int> estoqueMinimo = const Value.absent(),
                Value<int?> diasValidadeAberto = const Value.absent(),
                Value<DateTime> criadoEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProdutosCompanion(
                id: id,
                nome: nome,
                marca: marca,
                categoria: categoria,
                foto: foto,
                estoqueMinimo: estoqueMinimo,
                diasValidadeAberto: diasValidadeAberto,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nome,
                Value<String?> marca = const Value.absent(),
                Value<String?> categoria = const Value.absent(),
                Value<String?> foto = const Value.absent(),
                Value<int> estoqueMinimo = const Value.absent(),
                Value<int?> diasValidadeAberto = const Value.absent(),
                required DateTime criadoEm,
                Value<int> rowid = const Value.absent(),
              }) => ProdutosCompanion.insert(
                id: id,
                nome: nome,
                marca: marca,
                categoria: categoria,
                foto: foto,
                estoqueMinimo: estoqueMinimo,
                diasValidadeAberto: diasValidadeAberto,
                criadoEm: criadoEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProdutosTable, Produto>(table),
                  $$ProdutosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({codigosBarrasRefs = false, unidadesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (codigosBarrasRefs) db.codigosBarras,
                    if (unidadesRefs) db.unidades,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (codigosBarrasRefs)
                        await $_getPrefetchedData<
                          Produto,
                          $ProdutosTable,
                          CodigoBarras
                        >(
                          currentTable: table,
                          referencedTable: $$ProdutosTableReferences
                              ._codigosBarrasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProdutosTableReferences(
                                db,
                                table,
                                p0,
                              ).codigosBarrasRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.produtoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (unidadesRefs)
                        await $_getPrefetchedData<
                          Produto,
                          $ProdutosTable,
                          Unidade
                        >(
                          currentTable: table,
                          referencedTable: $$ProdutosTableReferences
                              ._unidadesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProdutosTableReferences(
                                db,
                                table,
                                p0,
                              ).unidadesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.produtoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProdutosTableProcessedTableManager =
    ProcessedTableManager<
      _$Banco,
      $ProdutosTable,
      Produto,
      $$ProdutosTableFilterComposer,
      $$ProdutosTableOrderingComposer,
      $$ProdutosTableAnnotationComposer,
      $$ProdutosTableCreateCompanionBuilder,
      $$ProdutosTableUpdateCompanionBuilder,
      (Produto, $$ProdutosTableReferences),
      Produto,
      PrefetchHooks Function({bool codigosBarrasRefs, bool unidadesRefs})
    >;
typedef $$CodigosBarrasTableCreateCompanionBuilder =
    CodigosBarrasCompanion Function({
      required String codigo,
      required String produtoId,
      Value<int> rowid,
    });
typedef $$CodigosBarrasTableUpdateCompanionBuilder =
    CodigosBarrasCompanion Function({
      Value<String> codigo,
      Value<String> produtoId,
      Value<int> rowid,
    });

final class $$CodigosBarrasTableReferences
    extends BaseReferences<_$Banco, $CodigosBarrasTable, CodigoBarras> {
  $$CodigosBarrasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProdutosTable _produtoIdTable(_$Banco db) =>
      db.produtos.createAlias('codigos_barras__produto_id__produtos__id');

  $$ProdutosTableProcessedTableManager get produtoId {
    final $_column = $_itemColumn<String>('produto_id')!;

    final manager = $$ProdutosTableTableManager(
      $_db,
      $_db.produtos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produtoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CodigosBarrasTableFilterComposer
    extends Composer<_$Banco, $CodigosBarrasTable> {
  $$CodigosBarrasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  $$ProdutosTableFilterComposer get produtoId {
    final $$ProdutosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableFilterComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CodigosBarrasTableOrderingComposer
    extends Composer<_$Banco, $CodigosBarrasTable> {
  $$CodigosBarrasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProdutosTableOrderingComposer get produtoId {
    final $$ProdutosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableOrderingComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CodigosBarrasTableAnnotationComposer
    extends Composer<_$Banco, $CodigosBarrasTable> {
  $$CodigosBarrasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  $$ProdutosTableAnnotationComposer get produtoId {
    final $$ProdutosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableAnnotationComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CodigosBarrasTableTableManager
    extends
        RootTableManager<
          _$Banco,
          $CodigosBarrasTable,
          CodigoBarras,
          $$CodigosBarrasTableFilterComposer,
          $$CodigosBarrasTableOrderingComposer,
          $$CodigosBarrasTableAnnotationComposer,
          $$CodigosBarrasTableCreateCompanionBuilder,
          $$CodigosBarrasTableUpdateCompanionBuilder,
          (CodigoBarras, $$CodigosBarrasTableReferences),
          CodigoBarras,
          PrefetchHooks Function({bool produtoId})
        > {
  $$CodigosBarrasTableTableManager(_$Banco db, $CodigosBarrasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CodigosBarrasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CodigosBarrasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CodigosBarrasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> codigo = const Value.absent(),
                Value<String> produtoId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CodigosBarrasCompanion(
                codigo: codigo,
                produtoId: produtoId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String codigo,
                required String produtoId,
                Value<int> rowid = const Value.absent(),
              }) => CodigosBarrasCompanion.insert(
                codigo: codigo,
                produtoId: produtoId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CodigosBarrasTable, CodigoBarras>(table),
                  $$CodigosBarrasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({produtoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (produtoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.produtoId,
                        referencedTable: $$CodigosBarrasTableReferences
                            ._produtoIdTable(db),
                        referencedColumn: $$CodigosBarrasTableReferences
                            ._produtoIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CodigosBarrasTableProcessedTableManager =
    ProcessedTableManager<
      _$Banco,
      $CodigosBarrasTable,
      CodigoBarras,
      $$CodigosBarrasTableFilterComposer,
      $$CodigosBarrasTableOrderingComposer,
      $$CodigosBarrasTableAnnotationComposer,
      $$CodigosBarrasTableCreateCompanionBuilder,
      $$CodigosBarrasTableUpdateCompanionBuilder,
      (CodigoBarras, $$CodigosBarrasTableReferences),
      CodigoBarras,
      PrefetchHooks Function({bool produtoId})
    >;
typedef $$LocaisTableCreateCompanionBuilder = LocaisCompanion Function({
  required String id,
  required String nome,
  Value<int> rowid,
});
typedef $$LocaisTableUpdateCompanionBuilder = LocaisCompanion Function({
  Value<String> id,
  Value<String> nome,
  Value<int> rowid,
});

final class $$LocaisTableReferences
    extends BaseReferences<_$Banco, $LocaisTable, Local> {
  $$LocaisTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UnidadesTable, List<Unidade>> _unidadesRefsTable(
    _$Banco db,
  ) => MultiTypedResultKey.fromTable(
    db.unidades,
    aliasName: 'locais__id__unidades__local_id',
  );

  $$UnidadesTableProcessedTableManager get unidadesRefs {
    final manager = $$UnidadesTableTableManager(
      $_db,
      $_db.unidades,
    ).filter((f) => f.localId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_unidadesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MovimentosTable, List<Movimento>>
  _movimentosRefsTable(_$Banco db) => MultiTypedResultKey.fromTable(
    db.movimentos,
    aliasName: 'locais__id__movimentos__local_id',
  );

  $$MovimentosTableProcessedTableManager get movimentosRefs {
    final manager = $$MovimentosTableTableManager(
      $_db,
      $_db.movimentos,
    ).filter((f) => f.localId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimentosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocaisTableFilterComposer extends Composer<_$Banco, $LocaisTable> {
  $$LocaisTableFilterComposer({
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

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> unidadesRefs(
    Expression<bool> Function($$UnidadesTableFilterComposer f) f,
  ) {
    final $$UnidadesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unidades,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesTableFilterComposer(
            $db: $db,
            $table: $db.unidades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimentosRefs(
    Expression<bool> Function($$MovimentosTableFilterComposer f) f,
  ) {
    final $$MovimentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimentos,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimentosTableFilterComposer(
            $db: $db,
            $table: $db.movimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocaisTableOrderingComposer extends Composer<_$Banco, $LocaisTable> {
  $$LocaisTableOrderingComposer({
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

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocaisTableAnnotationComposer extends Composer<_$Banco, $LocaisTable> {
  $$LocaisTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  Expression<T> unidadesRefs<T extends Object>(
    Expression<T> Function($$UnidadesTableAnnotationComposer a) f,
  ) {
    final $$UnidadesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.unidades,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesTableAnnotationComposer(
            $db: $db,
            $table: $db.unidades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimentosRefs<T extends Object>(
    Expression<T> Function($$MovimentosTableAnnotationComposer a) f,
  ) {
    final $$MovimentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimentos,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimentosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocaisTableTableManager
    extends
        RootTableManager<
          _$Banco,
          $LocaisTable,
          Local,
          $$LocaisTableFilterComposer,
          $$LocaisTableOrderingComposer,
          $$LocaisTableAnnotationComposer,
          $$LocaisTableCreateCompanionBuilder,
          $$LocaisTableUpdateCompanionBuilder,
          (Local, $$LocaisTableReferences),
          Local,
          PrefetchHooks Function({bool unidadesRefs, bool movimentosRefs})
        > {
  $$LocaisTableTableManager(_$Banco db, $LocaisTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocaisTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocaisTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocaisTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => LocaisCompanion(id: id, nome: nome, rowid: rowid),
          createCompanionCallback: ({
            required String id,
            required String nome,
            Value<int> rowid = const Value.absent(),
          }) => LocaisCompanion.insert(id: id, nome: nome, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocaisTable, Local>(table),
                  $$LocaisTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({unidadesRefs = false, movimentosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (unidadesRefs) db.unidades,
                    if (movimentosRefs) db.movimentos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (unidadesRefs)
                        await $_getPrefetchedData<Local, $LocaisTable, Unidade>(
                          currentTable: table,
                          referencedTable: $$LocaisTableReferences
                              ._unidadesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocaisTableReferences(
                                db,
                                table,
                                p0,
                              ).unidadesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.localId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimentosRefs)
                        await $_getPrefetchedData<
                          Local,
                          $LocaisTable,
                          Movimento
                        >(
                          currentTable: table,
                          referencedTable: $$LocaisTableReferences
                              ._movimentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LocaisTableReferences(
                                db,
                                table,
                                p0,
                              ).movimentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.localId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LocaisTableProcessedTableManager =
    ProcessedTableManager<
      _$Banco,
      $LocaisTable,
      Local,
      $$LocaisTableFilterComposer,
      $$LocaisTableOrderingComposer,
      $$LocaisTableAnnotationComposer,
      $$LocaisTableCreateCompanionBuilder,
      $$LocaisTableUpdateCompanionBuilder,
      (Local, $$LocaisTableReferences),
      Local,
      PrefetchHooks Function({bool unidadesRefs, bool movimentosRefs})
    >;
typedef $$UnidadesTableCreateCompanionBuilder = UnidadesCompanion Function({
  required String id,
  required String produtoId,
  Value<String?> localId,
  required EstadoUnidade estado,
  required DateTime entrouEm,
  Value<DateTime?> abertoEm,
  Value<DateTime?> saiuEm,
  Value<DateTime?> venceEm,
  Value<int> rowid,
});
typedef $$UnidadesTableUpdateCompanionBuilder = UnidadesCompanion Function({
  Value<String> id,
  Value<String> produtoId,
  Value<String?> localId,
  Value<EstadoUnidade> estado,
  Value<DateTime> entrouEm,
  Value<DateTime?> abertoEm,
  Value<DateTime?> saiuEm,
  Value<DateTime?> venceEm,
  Value<int> rowid,
});

final class $$UnidadesTableReferences
    extends BaseReferences<_$Banco, $UnidadesTable, Unidade> {
  $$UnidadesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProdutosTable _produtoIdTable(_$Banco db) =>
      db.produtos.createAlias('unidades__produto_id__produtos__id');

  $$ProdutosTableProcessedTableManager get produtoId {
    final $_column = $_itemColumn<String>('produto_id')!;

    final manager = $$ProdutosTableTableManager(
      $_db,
      $_db.produtos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produtoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocaisTable _localIdTable(_$Banco db) =>
      db.locais.createAlias('unidades__local_id__locais__id');

  $$LocaisTableProcessedTableManager? get localId {
    final $_column = $_itemColumn<String>('local_id');
    if ($_column == null) return null;
    final manager = $$LocaisTableTableManager(
      $_db,
      $_db.locais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MovimentosTable, List<Movimento>>
  _movimentosRefsTable(_$Banco db) => MultiTypedResultKey.fromTable(
    db.movimentos,
    aliasName: 'unidades__id__movimentos__unidade_id',
  );

  $$MovimentosTableProcessedTableManager get movimentosRefs {
    final manager = $$MovimentosTableTableManager(
      $_db,
      $_db.movimentos,
    ).filter((f) => f.unidadeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimentosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnidadesTableFilterComposer extends Composer<_$Banco, $UnidadesTable> {
  $$UnidadesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<EstadoUnidade, EstadoUnidade, String>
  get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get entrouEm => $composableBuilder(
    column: $table.entrouEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get abertoEm => $composableBuilder(
    column: $table.abertoEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get saiuEm => $composableBuilder(
    column: $table.saiuEm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get venceEm => $composableBuilder(
    column: $table.venceEm,
    builder: (column) => ColumnFilters(column),
  );

  $$ProdutosTableFilterComposer get produtoId {
    final $$ProdutosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableFilterComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableFilterComposer get localId {
    final $$LocaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableFilterComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movimentosRefs(
    Expression<bool> Function($$MovimentosTableFilterComposer f) f,
  ) {
    final $$MovimentosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimentos,
      getReferencedColumn: (t) => t.unidadeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimentosTableFilterComposer(
            $db: $db,
            $table: $db.movimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnidadesTableOrderingComposer
    extends Composer<_$Banco, $UnidadesTable> {
  $$UnidadesTableOrderingComposer({
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

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entrouEm => $composableBuilder(
    column: $table.entrouEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get abertoEm => $composableBuilder(
    column: $table.abertoEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get saiuEm => $composableBuilder(
    column: $table.saiuEm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get venceEm => $composableBuilder(
    column: $table.venceEm,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProdutosTableOrderingComposer get produtoId {
    final $$ProdutosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableOrderingComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableOrderingComposer get localId {
    final $$LocaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableOrderingComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UnidadesTableAnnotationComposer
    extends Composer<_$Banco, $UnidadesTable> {
  $$UnidadesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstadoUnidade, String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<DateTime> get entrouEm =>
      $composableBuilder(column: $table.entrouEm, builder: (column) => column);

  GeneratedColumn<DateTime> get abertoEm =>
      $composableBuilder(column: $table.abertoEm, builder: (column) => column);

  GeneratedColumn<DateTime> get saiuEm =>
      $composableBuilder(column: $table.saiuEm, builder: (column) => column);

  GeneratedColumn<DateTime> get venceEm =>
      $composableBuilder(column: $table.venceEm, builder: (column) => column);

  $$ProdutosTableAnnotationComposer get produtoId {
    final $$ProdutosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produtoId,
      referencedTable: $db.produtos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdutosTableAnnotationComposer(
            $db: $db,
            $table: $db.produtos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableAnnotationComposer get localId {
    final $$LocaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableAnnotationComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> movimentosRefs<T extends Object>(
    Expression<T> Function($$MovimentosTableAnnotationComposer a) f,
  ) {
    final $$MovimentosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimentos,
      getReferencedColumn: (t) => t.unidadeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimentosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimentos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UnidadesTableTableManager
    extends
        RootTableManager<
          _$Banco,
          $UnidadesTable,
          Unidade,
          $$UnidadesTableFilterComposer,
          $$UnidadesTableOrderingComposer,
          $$UnidadesTableAnnotationComposer,
          $$UnidadesTableCreateCompanionBuilder,
          $$UnidadesTableUpdateCompanionBuilder,
          (Unidade, $$UnidadesTableReferences),
          Unidade,
          PrefetchHooks Function({
            bool produtoId,
            bool localId,
            bool movimentosRefs,
          })
        > {
  $$UnidadesTableTableManager(_$Banco db, $UnidadesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnidadesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnidadesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnidadesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> produtoId = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<EstadoUnidade> estado = const Value.absent(),
                Value<DateTime> entrouEm = const Value.absent(),
                Value<DateTime?> abertoEm = const Value.absent(),
                Value<DateTime?> saiuEm = const Value.absent(),
                Value<DateTime?> venceEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnidadesCompanion(
                id: id,
                produtoId: produtoId,
                localId: localId,
                estado: estado,
                entrouEm: entrouEm,
                abertoEm: abertoEm,
                saiuEm: saiuEm,
                venceEm: venceEm,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String produtoId,
                Value<String?> localId = const Value.absent(),
                required EstadoUnidade estado,
                required DateTime entrouEm,
                Value<DateTime?> abertoEm = const Value.absent(),
                Value<DateTime?> saiuEm = const Value.absent(),
                Value<DateTime?> venceEm = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnidadesCompanion.insert(
                id: id,
                produtoId: produtoId,
                localId: localId,
                estado: estado,
                entrouEm: entrouEm,
                abertoEm: abertoEm,
                saiuEm: saiuEm,
                venceEm: venceEm,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UnidadesTable, Unidade>(table),
                  $$UnidadesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({produtoId = false, localId = false, movimentosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (movimentosRefs) db.movimentos],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (produtoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.produtoId,
                            referencedTable: $$UnidadesTableReferences
                                ._produtoIdTable(db),
                            referencedColumn: $$UnidadesTableReferences
                                ._produtoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (localId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.localId,
                            referencedTable: $$UnidadesTableReferences
                                ._localIdTable(db),
                            referencedColumn: $$UnidadesTableReferences
                                ._localIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimentosRefs)
                        await $_getPrefetchedData<
                          Unidade,
                          $UnidadesTable,
                          Movimento
                        >(
                          currentTable: table,
                          referencedTable: $$UnidadesTableReferences
                              ._movimentosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnidadesTableReferences(
                                db,
                                table,
                                p0,
                              ).movimentosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unidadeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UnidadesTableProcessedTableManager =
    ProcessedTableManager<
      _$Banco,
      $UnidadesTable,
      Unidade,
      $$UnidadesTableFilterComposer,
      $$UnidadesTableOrderingComposer,
      $$UnidadesTableAnnotationComposer,
      $$UnidadesTableCreateCompanionBuilder,
      $$UnidadesTableUpdateCompanionBuilder,
      (Unidade, $$UnidadesTableReferences),
      Unidade,
      PrefetchHooks Function({
        bool produtoId,
        bool localId,
        bool movimentosRefs,
      })
    >;
typedef $$MovimentosTableCreateCompanionBuilder = MovimentosCompanion Function({
  required String id,
  required String unidadeId,
  required AcaoMovimento acao,
  required DateTime quando,
  Value<String?> localId,
  Value<int> rowid,
});
typedef $$MovimentosTableUpdateCompanionBuilder = MovimentosCompanion Function({
  Value<String> id,
  Value<String> unidadeId,
  Value<AcaoMovimento> acao,
  Value<DateTime> quando,
  Value<String?> localId,
  Value<int> rowid,
});

final class $$MovimentosTableReferences
    extends BaseReferences<_$Banco, $MovimentosTable, Movimento> {
  $$MovimentosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnidadesTable _unidadeIdTable(_$Banco db) =>
      db.unidades.createAlias('movimentos__unidade_id__unidades__id');

  $$UnidadesTableProcessedTableManager get unidadeId {
    final $_column = $_itemColumn<String>('unidade_id')!;

    final manager = $$UnidadesTableTableManager(
      $_db,
      $_db.unidades,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unidadeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocaisTable _localIdTable(_$Banco db) =>
      db.locais.createAlias('movimentos__local_id__locais__id');

  $$LocaisTableProcessedTableManager? get localId {
    final $_column = $_itemColumn<String>('local_id');
    if ($_column == null) return null;
    final manager = $$LocaisTableTableManager(
      $_db,
      $_db.locais,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_localIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimentosTableFilterComposer
    extends Composer<_$Banco, $MovimentosTable> {
  $$MovimentosTableFilterComposer({
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

  ColumnWithTypeConverterFilters<AcaoMovimento, AcaoMovimento, String>
  get acao => $composableBuilder(
    column: $table.acao,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get quando => $composableBuilder(
    column: $table.quando,
    builder: (column) => ColumnFilters(column),
  );

  $$UnidadesTableFilterComposer get unidadeId {
    final $$UnidadesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unidadeId,
      referencedTable: $db.unidades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesTableFilterComposer(
            $db: $db,
            $table: $db.unidades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableFilterComposer get localId {
    final $$LocaisTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableFilterComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimentosTableOrderingComposer
    extends Composer<_$Banco, $MovimentosTable> {
  $$MovimentosTableOrderingComposer({
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

  ColumnOrderings<String> get acao => $composableBuilder(
    column: $table.acao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get quando => $composableBuilder(
    column: $table.quando,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnidadesTableOrderingComposer get unidadeId {
    final $$UnidadesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unidadeId,
      referencedTable: $db.unidades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesTableOrderingComposer(
            $db: $db,
            $table: $db.unidades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableOrderingComposer get localId {
    final $$LocaisTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableOrderingComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimentosTableAnnotationComposer
    extends Composer<_$Banco, $MovimentosTable> {
  $$MovimentosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AcaoMovimento, String> get acao =>
      $composableBuilder(column: $table.acao, builder: (column) => column);

  GeneratedColumn<DateTime> get quando =>
      $composableBuilder(column: $table.quando, builder: (column) => column);

  $$UnidadesTableAnnotationComposer get unidadeId {
    final $$UnidadesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unidadeId,
      referencedTable: $db.unidades,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnidadesTableAnnotationComposer(
            $db: $db,
            $table: $db.unidades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocaisTableAnnotationComposer get localId {
    final $$LocaisTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.locais,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocaisTableAnnotationComposer(
            $db: $db,
            $table: $db.locais,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimentosTableTableManager
    extends
        RootTableManager<
          _$Banco,
          $MovimentosTable,
          Movimento,
          $$MovimentosTableFilterComposer,
          $$MovimentosTableOrderingComposer,
          $$MovimentosTableAnnotationComposer,
          $$MovimentosTableCreateCompanionBuilder,
          $$MovimentosTableUpdateCompanionBuilder,
          (Movimento, $$MovimentosTableReferences),
          Movimento,
          PrefetchHooks Function({bool unidadeId, bool localId})
        > {
  $$MovimentosTableTableManager(_$Banco db, $MovimentosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimentosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimentosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimentosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> unidadeId = const Value.absent(),
                Value<AcaoMovimento> acao = const Value.absent(),
                Value<DateTime> quando = const Value.absent(),
                Value<String?> localId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovimentosCompanion(
                id: id,
                unidadeId: unidadeId,
                acao: acao,
                quando: quando,
                localId: localId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String unidadeId,
                required AcaoMovimento acao,
                required DateTime quando,
                Value<String?> localId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MovimentosCompanion.insert(
                id: id,
                unidadeId: unidadeId,
                acao: acao,
                quando: quando,
                localId: localId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MovimentosTable, Movimento>(table),
                  $$MovimentosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unidadeId = false, localId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (unidadeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.unidadeId,
                        referencedTable: $$MovimentosTableReferences
                            ._unidadeIdTable(db),
                        referencedColumn: $$MovimentosTableReferences
                            ._unidadeIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (localId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.localId,
                        referencedTable: $$MovimentosTableReferences
                            ._localIdTable(db),
                        referencedColumn: $$MovimentosTableReferences
                            ._localIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MovimentosTableProcessedTableManager =
    ProcessedTableManager<
      _$Banco,
      $MovimentosTable,
      Movimento,
      $$MovimentosTableFilterComposer,
      $$MovimentosTableOrderingComposer,
      $$MovimentosTableAnnotationComposer,
      $$MovimentosTableCreateCompanionBuilder,
      $$MovimentosTableUpdateCompanionBuilder,
      (Movimento, $$MovimentosTableReferences),
      Movimento,
      PrefetchHooks Function({bool unidadeId, bool localId})
    >;
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
  $$ProdutosTableTableManager get produtos =>
      $$ProdutosTableTableManager(_db, _db.produtos);
  $$CodigosBarrasTableTableManager get codigosBarras =>
      $$CodigosBarrasTableTableManager(_db, _db.codigosBarras);
  $$LocaisTableTableManager get locais =>
      $$LocaisTableTableManager(_db, _db.locais);
  $$UnidadesTableTableManager get unidades =>
      $$UnidadesTableTableManager(_db, _db.unidades);
  $$MovimentosTableTableManager get movimentos =>
      $$MovimentosTableTableManager(_db, _db.movimentos);
  $$LeiturasTableTableManager get leituras =>
      $$LeiturasTableTableManager(_db, _db.leituras);
}
