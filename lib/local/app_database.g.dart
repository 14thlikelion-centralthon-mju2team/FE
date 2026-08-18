// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $OfflineActionQueueTable extends OfflineActionQueue
    with TableInfo<$OfflineActionQueueTable, OfflineActionQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineActionQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientEventIdMeta = const VerificationMeta(
    'clientEventId',
  );
  @override
  late final GeneratedColumn<String> clientEventId = GeneratedColumn<String>(
    'client_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<String> planId = GeneratedColumn<String>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _queuedAtMeta = const VerificationMeta(
    'queuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> queuedAt = GeneratedColumn<DateTime>(
    'queued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientEventId,
    planId,
    payloadJson,
    queuedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_action_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineActionQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_event_id')) {
      context.handle(
        _clientEventIdMeta,
        clientEventId.isAcceptableOrUnknown(
          data['client_event_id']!,
          _clientEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientEventIdMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('queued_at')) {
      context.handle(
        _queuedAtMeta,
        queuedAt.isAcceptableOrUnknown(data['queued_at']!, _queuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_queuedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientEventId};
  @override
  OfflineActionQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineActionQueueData(
      clientEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_event_id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      queuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}queued_at'],
      )!,
    );
  }

  @override
  $OfflineActionQueueTable createAlias(String alias) {
    return $OfflineActionQueueTable(attachedDatabase, alias);
  }
}

class OfflineActionQueueData extends DataClass
    implements Insertable<OfflineActionQueueData> {
  /// (userId, clientEventId) UNIQUE가 서버 쪽 멱등성 키다(TR-03).
  /// 로컬에서도 이 값을 PK로 둬서 같은 사건이 중복 큐잉되지 않게 한다.
  final String clientEventId;
  final String planId;
  final String payloadJson;
  final DateTime queuedAt;
  const OfflineActionQueueData({
    required this.clientEventId,
    required this.planId,
    required this.payloadJson,
    required this.queuedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_event_id'] = Variable<String>(clientEventId);
    map['plan_id'] = Variable<String>(planId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['queued_at'] = Variable<DateTime>(queuedAt);
    return map;
  }

  OfflineActionQueueCompanion toCompanion(bool nullToAbsent) {
    return OfflineActionQueueCompanion(
      clientEventId: Value(clientEventId),
      planId: Value(planId),
      payloadJson: Value(payloadJson),
      queuedAt: Value(queuedAt),
    );
  }

  factory OfflineActionQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineActionQueueData(
      clientEventId: serializer.fromJson<String>(json['clientEventId']),
      planId: serializer.fromJson<String>(json['planId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      queuedAt: serializer.fromJson<DateTime>(json['queuedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientEventId': serializer.toJson<String>(clientEventId),
      'planId': serializer.toJson<String>(planId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'queuedAt': serializer.toJson<DateTime>(queuedAt),
    };
  }

  OfflineActionQueueData copyWith({
    String? clientEventId,
    String? planId,
    String? payloadJson,
    DateTime? queuedAt,
  }) => OfflineActionQueueData(
    clientEventId: clientEventId ?? this.clientEventId,
    planId: planId ?? this.planId,
    payloadJson: payloadJson ?? this.payloadJson,
    queuedAt: queuedAt ?? this.queuedAt,
  );
  OfflineActionQueueData copyWithCompanion(OfflineActionQueueCompanion data) {
    return OfflineActionQueueData(
      clientEventId: data.clientEventId.present
          ? data.clientEventId.value
          : this.clientEventId,
      planId: data.planId.present ? data.planId.value : this.planId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      queuedAt: data.queuedAt.present ? data.queuedAt.value : this.queuedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineActionQueueData(')
          ..write('clientEventId: $clientEventId, ')
          ..write('planId: $planId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('queuedAt: $queuedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(clientEventId, planId, payloadJson, queuedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineActionQueueData &&
          other.clientEventId == this.clientEventId &&
          other.planId == this.planId &&
          other.payloadJson == this.payloadJson &&
          other.queuedAt == this.queuedAt);
}

class OfflineActionQueueCompanion
    extends UpdateCompanion<OfflineActionQueueData> {
  final Value<String> clientEventId;
  final Value<String> planId;
  final Value<String> payloadJson;
  final Value<DateTime> queuedAt;
  final Value<int> rowid;
  const OfflineActionQueueCompanion({
    this.clientEventId = const Value.absent(),
    this.planId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.queuedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineActionQueueCompanion.insert({
    required String clientEventId,
    required String planId,
    required String payloadJson,
    required DateTime queuedAt,
    this.rowid = const Value.absent(),
  }) : clientEventId = Value(clientEventId),
       planId = Value(planId),
       payloadJson = Value(payloadJson),
       queuedAt = Value(queuedAt);
  static Insertable<OfflineActionQueueData> custom({
    Expression<String>? clientEventId,
    Expression<String>? planId,
    Expression<String>? payloadJson,
    Expression<DateTime>? queuedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientEventId != null) 'client_event_id': clientEventId,
      if (planId != null) 'plan_id': planId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (queuedAt != null) 'queued_at': queuedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineActionQueueCompanion copyWith({
    Value<String>? clientEventId,
    Value<String>? planId,
    Value<String>? payloadJson,
    Value<DateTime>? queuedAt,
    Value<int>? rowid,
  }) {
    return OfflineActionQueueCompanion(
      clientEventId: clientEventId ?? this.clientEventId,
      planId: planId ?? this.planId,
      payloadJson: payloadJson ?? this.payloadJson,
      queuedAt: queuedAt ?? this.queuedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientEventId.present) {
      map['client_event_id'] = Variable<String>(clientEventId.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<String>(planId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (queuedAt.present) {
      map['queued_at'] = Variable<DateTime>(queuedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineActionQueueCompanion(')
          ..write('clientEventId: $clientEventId, ')
          ..write('planId: $planId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('queuedAt: $queuedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OfflineActionQueueTable offlineActionQueue =
      $OfflineActionQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [offlineActionQueue];
}

typedef $$OfflineActionQueueTableCreateCompanionBuilder =
    OfflineActionQueueCompanion Function({
      required String clientEventId,
      required String planId,
      required String payloadJson,
      required DateTime queuedAt,
      Value<int> rowid,
    });
typedef $$OfflineActionQueueTableUpdateCompanionBuilder =
    OfflineActionQueueCompanion Function({
      Value<String> clientEventId,
      Value<String> planId,
      Value<String> payloadJson,
      Value<DateTime> queuedAt,
      Value<int> rowid,
    });

class $$OfflineActionQueueTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineActionQueueTable> {
  $$OfflineActionQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineActionQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineActionQueueTable> {
  $$OfflineActionQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get planId => $composableBuilder(
    column: $table.planId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get queuedAt => $composableBuilder(
    column: $table.queuedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineActionQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineActionQueueTable> {
  $$OfflineActionQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientEventId => $composableBuilder(
    column: $table.clientEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get queuedAt =>
      $composableBuilder(column: $table.queuedAt, builder: (column) => column);
}

class $$OfflineActionQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineActionQueueTable,
          OfflineActionQueueData,
          $$OfflineActionQueueTableFilterComposer,
          $$OfflineActionQueueTableOrderingComposer,
          $$OfflineActionQueueTableAnnotationComposer,
          $$OfflineActionQueueTableCreateCompanionBuilder,
          $$OfflineActionQueueTableUpdateCompanionBuilder,
          (
            OfflineActionQueueData,
            BaseReferences<
              _$AppDatabase,
              $OfflineActionQueueTable,
              OfflineActionQueueData
            >,
          ),
          OfflineActionQueueData,
          PrefetchHooks Function()
        > {
  $$OfflineActionQueueTableTableManager(
    _$AppDatabase db,
    $OfflineActionQueueTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineActionQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineActionQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineActionQueueTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clientEventId = const Value.absent(),
                Value<String> planId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> queuedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineActionQueueCompanion(
                clientEventId: clientEventId,
                planId: planId,
                payloadJson: payloadJson,
                queuedAt: queuedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientEventId,
                required String planId,
                required String payloadJson,
                required DateTime queuedAt,
                Value<int> rowid = const Value.absent(),
              }) => OfflineActionQueueCompanion.insert(
                clientEventId: clientEventId,
                planId: planId,
                payloadJson: payloadJson,
                queuedAt: queuedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineActionQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineActionQueueTable,
      OfflineActionQueueData,
      $$OfflineActionQueueTableFilterComposer,
      $$OfflineActionQueueTableOrderingComposer,
      $$OfflineActionQueueTableAnnotationComposer,
      $$OfflineActionQueueTableCreateCompanionBuilder,
      $$OfflineActionQueueTableUpdateCompanionBuilder,
      (
        OfflineActionQueueData,
        BaseReferences<
          _$AppDatabase,
          $OfflineActionQueueTable,
          OfflineActionQueueData
        >,
      ),
      OfflineActionQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OfflineActionQueueTableTableManager get offlineActionQueue =>
      $$OfflineActionQueueTableTableManager(_db, _db.offlineActionQueue);
}
