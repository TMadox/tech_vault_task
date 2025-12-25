// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CurrenciesTableTable extends CurrenciesTable
    with TableInfo<$CurrenciesTableTable, CurrenciesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyNameMeta = const VerificationMeta(
    'currencyName',
  );
  @override
  late final GeneratedColumn<String> currencyName = GeneratedColumn<String>(
    'currency_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencySymbolMeta = const VerificationMeta(
    'currencySymbol',
  );
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
    'currency_symbol',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currencyName,
    currencySymbol,
    countryCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurrenciesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('currency_name')) {
      context.handle(
        _currencyNameMeta,
        currencyName.isAcceptableOrUnknown(
          data['currency_name']!,
          _currencyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyNameMeta);
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
        _currencySymbolMeta,
        currencySymbol.isAcceptableOrUnknown(
          data['currency_symbol']!,
          _currencySymbolMeta,
        ),
      );
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CurrenciesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrenciesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      currencyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_name'],
      )!,
      currencySymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_symbol'],
      ),
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      ),
    );
  }

  @override
  $CurrenciesTableTable createAlias(String alias) {
    return $CurrenciesTableTable(attachedDatabase, alias);
  }
}

class CurrenciesTableData extends DataClass
    implements Insertable<CurrenciesTableData> {
  final String id;
  final String currencyName;
  final String? currencySymbol;
  final String? countryCode;
  const CurrenciesTableData({
    required this.id,
    required this.currencyName,
    this.currencySymbol,
    this.countryCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['currency_name'] = Variable<String>(currencyName);
    if (!nullToAbsent || currencySymbol != null) {
      map['currency_symbol'] = Variable<String>(currencySymbol);
    }
    if (!nullToAbsent || countryCode != null) {
      map['country_code'] = Variable<String>(countryCode);
    }
    return map;
  }

  CurrenciesTableCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesTableCompanion(
      id: Value(id),
      currencyName: Value(currencyName),
      currencySymbol: currencySymbol == null && nullToAbsent
          ? const Value.absent()
          : Value(currencySymbol),
      countryCode: countryCode == null && nullToAbsent
          ? const Value.absent()
          : Value(countryCode),
    );
  }

  factory CurrenciesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrenciesTableData(
      id: serializer.fromJson<String>(json['id']),
      currencyName: serializer.fromJson<String>(json['currencyName']),
      currencySymbol: serializer.fromJson<String?>(json['currencySymbol']),
      countryCode: serializer.fromJson<String?>(json['countryCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'currencyName': serializer.toJson<String>(currencyName),
      'currencySymbol': serializer.toJson<String?>(currencySymbol),
      'countryCode': serializer.toJson<String?>(countryCode),
    };
  }

  CurrenciesTableData copyWith({
    String? id,
    String? currencyName,
    Value<String?> currencySymbol = const Value.absent(),
    Value<String?> countryCode = const Value.absent(),
  }) => CurrenciesTableData(
    id: id ?? this.id,
    currencyName: currencyName ?? this.currencyName,
    currencySymbol: currencySymbol.present
        ? currencySymbol.value
        : this.currencySymbol,
    countryCode: countryCode.present ? countryCode.value : this.countryCode,
  );
  CurrenciesTableData copyWithCompanion(CurrenciesTableCompanion data) {
    return CurrenciesTableData(
      id: data.id.present ? data.id.value : this.id,
      currencyName: data.currencyName.present
          ? data.currencyName.value
          : this.currencyName,
      currencySymbol: data.currencySymbol.present
          ? data.currencySymbol.value
          : this.currencySymbol,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesTableData(')
          ..write('id: $id, ')
          ..write('currencyName: $currencyName, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('countryCode: $countryCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, currencyName, currencySymbol, countryCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrenciesTableData &&
          other.id == this.id &&
          other.currencyName == this.currencyName &&
          other.currencySymbol == this.currencySymbol &&
          other.countryCode == this.countryCode);
}

class CurrenciesTableCompanion extends UpdateCompanion<CurrenciesTableData> {
  final Value<String> id;
  final Value<String> currencyName;
  final Value<String?> currencySymbol;
  final Value<String?> countryCode;
  final Value<int> rowid;
  const CurrenciesTableCompanion({
    this.id = const Value.absent(),
    this.currencyName = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrenciesTableCompanion.insert({
    required String id,
    required String currencyName,
    this.currencySymbol = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       currencyName = Value(currencyName);
  static Insertable<CurrenciesTableData> custom({
    Expression<String>? id,
    Expression<String>? currencyName,
    Expression<String>? currencySymbol,
    Expression<String>? countryCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyName != null) 'currency_name': currencyName,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (countryCode != null) 'country_code': countryCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrenciesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? currencyName,
    Value<String?>? currencySymbol,
    Value<String?>? countryCode,
    Value<int>? rowid,
  }) {
    return CurrenciesTableCompanion(
      id: id ?? this.id,
      currencyName: currencyName ?? this.currencyName,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      countryCode: countryCode ?? this.countryCode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (currencyName.present) {
      map['currency_name'] = Variable<String>(currencyName.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesTableCompanion(')
          ..write('id: $id, ')
          ..write('currencyName: $currencyName, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('countryCode: $countryCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoricalRatesTableTable extends HistoricalRatesTable
    with TableInfo<$HistoricalRatesTableTable, HistoricalRatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoricalRatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fromCurrencyMeta = const VerificationMeta(
    'fromCurrency',
  );
  @override
  late final GeneratedColumn<String> fromCurrency = GeneratedColumn<String>(
    'from_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toCurrencyMeta = const VerificationMeta(
    'toCurrency',
  );
  @override
  late final GeneratedColumn<String> toCurrency = GeneratedColumn<String>(
    'to_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromCurrency,
    toCurrency,
    date,
    rate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historical_rates_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoricalRatesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_currency')) {
      context.handle(
        _fromCurrencyMeta,
        fromCurrency.isAcceptableOrUnknown(
          data['from_currency']!,
          _fromCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromCurrencyMeta);
    }
    if (data.containsKey('to_currency')) {
      context.handle(
        _toCurrencyMeta,
        toCurrency.isAcceptableOrUnknown(data['to_currency']!, _toCurrencyMeta),
      );
    } else if (isInserting) {
      context.missing(_toCurrencyMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {fromCurrency, toCurrency, date},
  ];
  @override
  HistoricalRatesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoricalRatesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fromCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_currency'],
      )!,
      toCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_currency'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
    );
  }

  @override
  $HistoricalRatesTableTable createAlias(String alias) {
    return $HistoricalRatesTableTable(attachedDatabase, alias);
  }
}

class HistoricalRatesTableData extends DataClass
    implements Insertable<HistoricalRatesTableData> {
  final int id;
  final String fromCurrency;
  final String toCurrency;
  final DateTime date;
  final double rate;
  const HistoricalRatesTableData({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.date,
    required this.rate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_currency'] = Variable<String>(fromCurrency);
    map['to_currency'] = Variable<String>(toCurrency);
    map['date'] = Variable<DateTime>(date);
    map['rate'] = Variable<double>(rate);
    return map;
  }

  HistoricalRatesTableCompanion toCompanion(bool nullToAbsent) {
    return HistoricalRatesTableCompanion(
      id: Value(id),
      fromCurrency: Value(fromCurrency),
      toCurrency: Value(toCurrency),
      date: Value(date),
      rate: Value(rate),
    );
  }

  factory HistoricalRatesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoricalRatesTableData(
      id: serializer.fromJson<int>(json['id']),
      fromCurrency: serializer.fromJson<String>(json['fromCurrency']),
      toCurrency: serializer.fromJson<String>(json['toCurrency']),
      date: serializer.fromJson<DateTime>(json['date']),
      rate: serializer.fromJson<double>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromCurrency': serializer.toJson<String>(fromCurrency),
      'toCurrency': serializer.toJson<String>(toCurrency),
      'date': serializer.toJson<DateTime>(date),
      'rate': serializer.toJson<double>(rate),
    };
  }

  HistoricalRatesTableData copyWith({
    int? id,
    String? fromCurrency,
    String? toCurrency,
    DateTime? date,
    double? rate,
  }) => HistoricalRatesTableData(
    id: id ?? this.id,
    fromCurrency: fromCurrency ?? this.fromCurrency,
    toCurrency: toCurrency ?? this.toCurrency,
    date: date ?? this.date,
    rate: rate ?? this.rate,
  );
  HistoricalRatesTableData copyWithCompanion(
    HistoricalRatesTableCompanion data,
  ) {
    return HistoricalRatesTableData(
      id: data.id.present ? data.id.value : this.id,
      fromCurrency: data.fromCurrency.present
          ? data.fromCurrency.value
          : this.fromCurrency,
      toCurrency: data.toCurrency.present
          ? data.toCurrency.value
          : this.toCurrency,
      date: data.date.present ? data.date.value : this.date,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoricalRatesTableData(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('date: $date, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fromCurrency, toCurrency, date, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoricalRatesTableData &&
          other.id == this.id &&
          other.fromCurrency == this.fromCurrency &&
          other.toCurrency == this.toCurrency &&
          other.date == this.date &&
          other.rate == this.rate);
}

class HistoricalRatesTableCompanion
    extends UpdateCompanion<HistoricalRatesTableData> {
  final Value<int> id;
  final Value<String> fromCurrency;
  final Value<String> toCurrency;
  final Value<DateTime> date;
  final Value<double> rate;
  const HistoricalRatesTableCompanion({
    this.id = const Value.absent(),
    this.fromCurrency = const Value.absent(),
    this.toCurrency = const Value.absent(),
    this.date = const Value.absent(),
    this.rate = const Value.absent(),
  });
  HistoricalRatesTableCompanion.insert({
    this.id = const Value.absent(),
    required String fromCurrency,
    required String toCurrency,
    required DateTime date,
    required double rate,
  }) : fromCurrency = Value(fromCurrency),
       toCurrency = Value(toCurrency),
       date = Value(date),
       rate = Value(rate);
  static Insertable<HistoricalRatesTableData> custom({
    Expression<int>? id,
    Expression<String>? fromCurrency,
    Expression<String>? toCurrency,
    Expression<DateTime>? date,
    Expression<double>? rate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromCurrency != null) 'from_currency': fromCurrency,
      if (toCurrency != null) 'to_currency': toCurrency,
      if (date != null) 'date': date,
      if (rate != null) 'rate': rate,
    });
  }

  HistoricalRatesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? fromCurrency,
    Value<String>? toCurrency,
    Value<DateTime>? date,
    Value<double>? rate,
  }) {
    return HistoricalRatesTableCompanion(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      date: date ?? this.date,
      rate: rate ?? this.rate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromCurrency.present) {
      map['from_currency'] = Variable<String>(fromCurrency.value);
    }
    if (toCurrency.present) {
      map['to_currency'] = Variable<String>(toCurrency.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoricalRatesTableCompanion(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('date: $date, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CurrenciesTableTable currenciesTable = $CurrenciesTableTable(
    this,
  );
  late final $HistoricalRatesTableTable historicalRatesTable =
      $HistoricalRatesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    currenciesTable,
    historicalRatesTable,
  ];
}

typedef $$CurrenciesTableTableCreateCompanionBuilder =
    CurrenciesTableCompanion Function({
      required String id,
      required String currencyName,
      Value<String?> currencySymbol,
      Value<String?> countryCode,
      Value<int> rowid,
    });
typedef $$CurrenciesTableTableUpdateCompanionBuilder =
    CurrenciesTableCompanion Function({
      Value<String> id,
      Value<String> currencyName,
      Value<String?> currencySymbol,
      Value<String?> countryCode,
      Value<int> rowid,
    });

class $$CurrenciesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesTableTable> {
  $$CurrenciesTableTableFilterComposer({
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

  ColumnFilters<String> get currencyName => $composableBuilder(
    column: $table.currencyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CurrenciesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesTableTable> {
  $$CurrenciesTableTableOrderingComposer({
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

  ColumnOrderings<String> get currencyName => $composableBuilder(
    column: $table.currencyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CurrenciesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesTableTable> {
  $$CurrenciesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currencyName => $composableBuilder(
    column: $table.currencyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => column,
  );

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );
}

class $$CurrenciesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CurrenciesTableTable,
          CurrenciesTableData,
          $$CurrenciesTableTableFilterComposer,
          $$CurrenciesTableTableOrderingComposer,
          $$CurrenciesTableTableAnnotationComposer,
          $$CurrenciesTableTableCreateCompanionBuilder,
          $$CurrenciesTableTableUpdateCompanionBuilder,
          (
            CurrenciesTableData,
            BaseReferences<
              _$AppDatabase,
              $CurrenciesTableTable,
              CurrenciesTableData
            >,
          ),
          CurrenciesTableData,
          PrefetchHooks Function()
        > {
  $$CurrenciesTableTableTableManager(
    _$AppDatabase db,
    $CurrenciesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> currencyName = const Value.absent(),
                Value<String?> currencySymbol = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurrenciesTableCompanion(
                id: id,
                currencyName: currencyName,
                currencySymbol: currencySymbol,
                countryCode: countryCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String currencyName,
                Value<String?> currencySymbol = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurrenciesTableCompanion.insert(
                id: id,
                currencyName: currencyName,
                currencySymbol: currencySymbol,
                countryCode: countryCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CurrenciesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CurrenciesTableTable,
      CurrenciesTableData,
      $$CurrenciesTableTableFilterComposer,
      $$CurrenciesTableTableOrderingComposer,
      $$CurrenciesTableTableAnnotationComposer,
      $$CurrenciesTableTableCreateCompanionBuilder,
      $$CurrenciesTableTableUpdateCompanionBuilder,
      (
        CurrenciesTableData,
        BaseReferences<
          _$AppDatabase,
          $CurrenciesTableTable,
          CurrenciesTableData
        >,
      ),
      CurrenciesTableData,
      PrefetchHooks Function()
    >;
typedef $$HistoricalRatesTableTableCreateCompanionBuilder =
    HistoricalRatesTableCompanion Function({
      Value<int> id,
      required String fromCurrency,
      required String toCurrency,
      required DateTime date,
      required double rate,
    });
typedef $$HistoricalRatesTableTableUpdateCompanionBuilder =
    HistoricalRatesTableCompanion Function({
      Value<int> id,
      Value<String> fromCurrency,
      Value<String> toCurrency,
      Value<DateTime> date,
      Value<double> rate,
    });

class $$HistoricalRatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $HistoricalRatesTableTable> {
  $$HistoricalRatesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistoricalRatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoricalRatesTableTable> {
  $$HistoricalRatesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistoricalRatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoricalRatesTableTable> {
  $$HistoricalRatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);
}

class $$HistoricalRatesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistoricalRatesTableTable,
          HistoricalRatesTableData,
          $$HistoricalRatesTableTableFilterComposer,
          $$HistoricalRatesTableTableOrderingComposer,
          $$HistoricalRatesTableTableAnnotationComposer,
          $$HistoricalRatesTableTableCreateCompanionBuilder,
          $$HistoricalRatesTableTableUpdateCompanionBuilder,
          (
            HistoricalRatesTableData,
            BaseReferences<
              _$AppDatabase,
              $HistoricalRatesTableTable,
              HistoricalRatesTableData
            >,
          ),
          HistoricalRatesTableData,
          PrefetchHooks Function()
        > {
  $$HistoricalRatesTableTableTableManager(
    _$AppDatabase db,
    $HistoricalRatesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoricalRatesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoricalRatesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HistoricalRatesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fromCurrency = const Value.absent(),
                Value<String> toCurrency = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> rate = const Value.absent(),
              }) => HistoricalRatesTableCompanion(
                id: id,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                date: date,
                rate: rate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fromCurrency,
                required String toCurrency,
                required DateTime date,
                required double rate,
              }) => HistoricalRatesTableCompanion.insert(
                id: id,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                date: date,
                rate: rate,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistoricalRatesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoricalRatesTableTable,
      HistoricalRatesTableData,
      $$HistoricalRatesTableTableFilterComposer,
      $$HistoricalRatesTableTableOrderingComposer,
      $$HistoricalRatesTableTableAnnotationComposer,
      $$HistoricalRatesTableTableCreateCompanionBuilder,
      $$HistoricalRatesTableTableUpdateCompanionBuilder,
      (
        HistoricalRatesTableData,
        BaseReferences<
          _$AppDatabase,
          $HistoricalRatesTableTable,
          HistoricalRatesTableData
        >,
      ),
      HistoricalRatesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrenciesTableTableTableManager get currenciesTable =>
      $$CurrenciesTableTableTableManager(_db, _db.currenciesTable);
  $$HistoricalRatesTableTableTableManager get historicalRatesTable =>
      $$HistoricalRatesTableTableTableManager(_db, _db.historicalRatesTable);
}
