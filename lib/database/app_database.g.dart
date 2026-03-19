// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PointLogsTable extends PointLogs
    with TableInfo<$PointLogsTable, PointLogEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _logIdMeta = const VerificationMeta('logId');
  @override
  late final GeneratedColumn<String> logId = GeneratedColumn<String>(
    'log_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LogType, String> logType =
      GeneratedColumn<String>(
        'log_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LogType>($PointLogsTable.$converterlogType);
  @override
  late final GeneratedColumnWithTypeConverter<IconTypeCode, String>
  iconTypeCode = GeneratedColumn<String>(
    'icon_type_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<IconTypeCode>($PointLogsTable.$convertericonTypeCode);
  @override
  late final GeneratedColumnWithTypeConverter<DetailType, String> detailType =
      GeneratedColumn<String>(
        'detail_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DetailType>($PointLogsTable.$converterdetailType);
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsChangeMeta = const VerificationMeta(
    'pointsChange',
  );
  @override
  late final GeneratedColumn<int> pointsChange = GeneratedColumn<int>(
    'points_change',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>(
        'last_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  detailsRaw = GeneratedColumn<String>(
    'details_raw',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Map<String, dynamic>?>($PointLogsTable.$converterdetailsRawn);
  @override
  List<GeneratedColumn> get $columns => [
    logId,
    logType,
    iconTypeCode,
    detailType,
    currencyCode,
    title,
    pointsChange,
    occurredAt,
    lastUpdatedAt,
    detailsRaw,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'point_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PointLogEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('log_id')) {
      context.handle(
        _logIdMeta,
        logId.isAcceptableOrUnknown(data['log_id']!, _logIdMeta),
      );
    } else if (isInserting) {
      context.missing(_logIdMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('points_change')) {
      context.handle(
        _pointsChangeMeta,
        pointsChange.isAcceptableOrUnknown(
          data['points_change']!,
          _pointsChangeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pointsChangeMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {logId};
  @override
  PointLogEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointLogEntity(
      logId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}log_id'],
      )!,
      logType: $PointLogsTable.$converterlogType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}log_type'],
        )!,
      ),
      iconTypeCode: $PointLogsTable.$convertericonTypeCode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}icon_type_code'],
        )!,
      ),
      detailType: $PointLogsTable.$converterdetailType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}detail_type'],
        )!,
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      pointsChange: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_change'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      lastUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated_at'],
      )!,
      detailsRaw: $PointLogsTable.$converterdetailsRawn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}details_raw'],
        ),
      ),
    );
  }

  @override
  $PointLogsTable createAlias(String alias) {
    return $PointLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LogType, String, String> $converterlogType =
      const EnumNameConverter<LogType>(LogType.values);
  static JsonTypeConverter2<IconTypeCode, String, String>
  $convertericonTypeCode = const EnumNameConverter<IconTypeCode>(
    IconTypeCode.values,
  );
  static JsonTypeConverter2<DetailType, String, String> $converterdetailType =
      const EnumNameConverter<DetailType>(DetailType.values);
  static TypeConverter<Map<String, dynamic>, String> $converterdetailsRaw =
      const DetailsConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $converterdetailsRawn =
      NullAwareTypeConverter.wrap($converterdetailsRaw);
}

class PointLogEntity extends DataClass implements Insertable<PointLogEntity> {
  final String logId;
  final LogType logType;
  final IconTypeCode iconTypeCode;
  final DetailType detailType;
  final String currencyCode;
  final String title;
  final int pointsChange;
  final DateTime occurredAt;
  final DateTime lastUpdatedAt;
  final Map<String, dynamic>? detailsRaw;
  const PointLogEntity({
    required this.logId,
    required this.logType,
    required this.iconTypeCode,
    required this.detailType,
    required this.currencyCode,
    required this.title,
    required this.pointsChange,
    required this.occurredAt,
    required this.lastUpdatedAt,
    this.detailsRaw,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['log_id'] = Variable<String>(logId);
    {
      map['log_type'] = Variable<String>(
        $PointLogsTable.$converterlogType.toSql(logType),
      );
    }
    {
      map['icon_type_code'] = Variable<String>(
        $PointLogsTable.$convertericonTypeCode.toSql(iconTypeCode),
      );
    }
    {
      map['detail_type'] = Variable<String>(
        $PointLogsTable.$converterdetailType.toSql(detailType),
      );
    }
    map['currency_code'] = Variable<String>(currencyCode);
    map['title'] = Variable<String>(title);
    map['points_change'] = Variable<int>(pointsChange);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    if (!nullToAbsent || detailsRaw != null) {
      map['details_raw'] = Variable<String>(
        $PointLogsTable.$converterdetailsRawn.toSql(detailsRaw),
      );
    }
    return map;
  }

  PointLogsCompanion toCompanion(bool nullToAbsent) {
    return PointLogsCompanion(
      logId: Value(logId),
      logType: Value(logType),
      iconTypeCode: Value(iconTypeCode),
      detailType: Value(detailType),
      currencyCode: Value(currencyCode),
      title: Value(title),
      pointsChange: Value(pointsChange),
      occurredAt: Value(occurredAt),
      lastUpdatedAt: Value(lastUpdatedAt),
      detailsRaw: detailsRaw == null && nullToAbsent
          ? const Value.absent()
          : Value(detailsRaw),
    );
  }

  factory PointLogEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointLogEntity(
      logId: serializer.fromJson<String>(json['logId']),
      logType: $PointLogsTable.$converterlogType.fromJson(
        serializer.fromJson<String>(json['logType']),
      ),
      iconTypeCode: $PointLogsTable.$convertericonTypeCode.fromJson(
        serializer.fromJson<String>(json['iconTypeCode']),
      ),
      detailType: $PointLogsTable.$converterdetailType.fromJson(
        serializer.fromJson<String>(json['detailType']),
      ),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      title: serializer.fromJson<String>(json['title']),
      pointsChange: serializer.fromJson<int>(json['pointsChange']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
      detailsRaw: serializer.fromJson<Map<String, dynamic>?>(
        json['detailsRaw'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'logId': serializer.toJson<String>(logId),
      'logType': serializer.toJson<String>(
        $PointLogsTable.$converterlogType.toJson(logType),
      ),
      'iconTypeCode': serializer.toJson<String>(
        $PointLogsTable.$convertericonTypeCode.toJson(iconTypeCode),
      ),
      'detailType': serializer.toJson<String>(
        $PointLogsTable.$converterdetailType.toJson(detailType),
      ),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'title': serializer.toJson<String>(title),
      'pointsChange': serializer.toJson<int>(pointsChange),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
      'detailsRaw': serializer.toJson<Map<String, dynamic>?>(detailsRaw),
    };
  }

  PointLogEntity copyWith({
    String? logId,
    LogType? logType,
    IconTypeCode? iconTypeCode,
    DetailType? detailType,
    String? currencyCode,
    String? title,
    int? pointsChange,
    DateTime? occurredAt,
    DateTime? lastUpdatedAt,
    Value<Map<String, dynamic>?> detailsRaw = const Value.absent(),
  }) => PointLogEntity(
    logId: logId ?? this.logId,
    logType: logType ?? this.logType,
    iconTypeCode: iconTypeCode ?? this.iconTypeCode,
    detailType: detailType ?? this.detailType,
    currencyCode: currencyCode ?? this.currencyCode,
    title: title ?? this.title,
    pointsChange: pointsChange ?? this.pointsChange,
    occurredAt: occurredAt ?? this.occurredAt,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    detailsRaw: detailsRaw.present ? detailsRaw.value : this.detailsRaw,
  );
  PointLogEntity copyWithCompanion(PointLogsCompanion data) {
    return PointLogEntity(
      logId: data.logId.present ? data.logId.value : this.logId,
      logType: data.logType.present ? data.logType.value : this.logType,
      iconTypeCode: data.iconTypeCode.present
          ? data.iconTypeCode.value
          : this.iconTypeCode,
      detailType: data.detailType.present
          ? data.detailType.value
          : this.detailType,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      title: data.title.present ? data.title.value : this.title,
      pointsChange: data.pointsChange.present
          ? data.pointsChange.value
          : this.pointsChange,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
      detailsRaw: data.detailsRaw.present
          ? data.detailsRaw.value
          : this.detailsRaw,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PointLogEntity(')
          ..write('logId: $logId, ')
          ..write('logType: $logType, ')
          ..write('iconTypeCode: $iconTypeCode, ')
          ..write('detailType: $detailType, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('title: $title, ')
          ..write('pointsChange: $pointsChange, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('detailsRaw: $detailsRaw')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    logId,
    logType,
    iconTypeCode,
    detailType,
    currencyCode,
    title,
    pointsChange,
    occurredAt,
    lastUpdatedAt,
    detailsRaw,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PointLogEntity &&
          other.logId == this.logId &&
          other.logType == this.logType &&
          other.iconTypeCode == this.iconTypeCode &&
          other.detailType == this.detailType &&
          other.currencyCode == this.currencyCode &&
          other.title == this.title &&
          other.pointsChange == this.pointsChange &&
          other.occurredAt == this.occurredAt &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.detailsRaw == this.detailsRaw);
}

class PointLogsCompanion extends UpdateCompanion<PointLogEntity> {
  final Value<String> logId;
  final Value<LogType> logType;
  final Value<IconTypeCode> iconTypeCode;
  final Value<DetailType> detailType;
  final Value<String> currencyCode;
  final Value<String> title;
  final Value<int> pointsChange;
  final Value<DateTime> occurredAt;
  final Value<DateTime> lastUpdatedAt;
  final Value<Map<String, dynamic>?> detailsRaw;
  final Value<int> rowid;
  const PointLogsCompanion({
    this.logId = const Value.absent(),
    this.logType = const Value.absent(),
    this.iconTypeCode = const Value.absent(),
    this.detailType = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.title = const Value.absent(),
    this.pointsChange = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.detailsRaw = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PointLogsCompanion.insert({
    required String logId,
    required LogType logType,
    required IconTypeCode iconTypeCode,
    required DetailType detailType,
    required String currencyCode,
    required String title,
    required int pointsChange,
    required DateTime occurredAt,
    required DateTime lastUpdatedAt,
    this.detailsRaw = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : logId = Value(logId),
       logType = Value(logType),
       iconTypeCode = Value(iconTypeCode),
       detailType = Value(detailType),
       currencyCode = Value(currencyCode),
       title = Value(title),
       pointsChange = Value(pointsChange),
       occurredAt = Value(occurredAt),
       lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<PointLogEntity> custom({
    Expression<String>? logId,
    Expression<String>? logType,
    Expression<String>? iconTypeCode,
    Expression<String>? detailType,
    Expression<String>? currencyCode,
    Expression<String>? title,
    Expression<int>? pointsChange,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? lastUpdatedAt,
    Expression<String>? detailsRaw,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (logId != null) 'log_id': logId,
      if (logType != null) 'log_type': logType,
      if (iconTypeCode != null) 'icon_type_code': iconTypeCode,
      if (detailType != null) 'detail_type': detailType,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (title != null) 'title': title,
      if (pointsChange != null) 'points_change': pointsChange,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (detailsRaw != null) 'details_raw': detailsRaw,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PointLogsCompanion copyWith({
    Value<String>? logId,
    Value<LogType>? logType,
    Value<IconTypeCode>? iconTypeCode,
    Value<DetailType>? detailType,
    Value<String>? currencyCode,
    Value<String>? title,
    Value<int>? pointsChange,
    Value<DateTime>? occurredAt,
    Value<DateTime>? lastUpdatedAt,
    Value<Map<String, dynamic>?>? detailsRaw,
    Value<int>? rowid,
  }) {
    return PointLogsCompanion(
      logId: logId ?? this.logId,
      logType: logType ?? this.logType,
      iconTypeCode: iconTypeCode ?? this.iconTypeCode,
      detailType: detailType ?? this.detailType,
      currencyCode: currencyCode ?? this.currencyCode,
      title: title ?? this.title,
      pointsChange: pointsChange ?? this.pointsChange,
      occurredAt: occurredAt ?? this.occurredAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      detailsRaw: detailsRaw ?? this.detailsRaw,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (logId.present) {
      map['log_id'] = Variable<String>(logId.value);
    }
    if (logType.present) {
      map['log_type'] = Variable<String>(
        $PointLogsTable.$converterlogType.toSql(logType.value),
      );
    }
    if (iconTypeCode.present) {
      map['icon_type_code'] = Variable<String>(
        $PointLogsTable.$convertericonTypeCode.toSql(iconTypeCode.value),
      );
    }
    if (detailType.present) {
      map['detail_type'] = Variable<String>(
        $PointLogsTable.$converterdetailType.toSql(detailType.value),
      );
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (pointsChange.present) {
      map['points_change'] = Variable<int>(pointsChange.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (detailsRaw.present) {
      map['details_raw'] = Variable<String>(
        $PointLogsTable.$converterdetailsRawn.toSql(detailsRaw.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointLogsCompanion(')
          ..write('logId: $logId, ')
          ..write('logType: $logType, ')
          ..write('iconTypeCode: $iconTypeCode, ')
          ..write('detailType: $detailType, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('title: $title, ')
          ..write('pointsChange: $pointsChange, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('detailsRaw: $detailsRaw, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SitesTable extends Sites with TableInfo<$SitesTable, SiteEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SiteType, String> siteType =
      GeneratedColumn<String>(
        'site_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SiteType>($SitesTable.$convertersiteType);
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceHoursMeta = const VerificationMeta(
    'serviceHours',
  );
  @override
  late final GeneratedColumn<String> serviceHours = GeneratedColumn<String>(
    'service_hours',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaIdMeta = const VerificationMeta('areaId');
  @override
  late final GeneratedColumn<String> areaId = GeneratedColumn<String>(
    'area_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _districtIdMeta = const VerificationMeta(
    'districtId',
  );
  @override
  late final GeneratedColumn<String> districtId = GeneratedColumn<String>(
    'district_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<RecyclableItemType>, String>
  recyclableItems =
      GeneratedColumn<String>(
        'recyclable_items',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<RecyclableItemType>>(
        $SitesTable.$converterrecyclableItems,
      );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    siteType,
    address,
    longitude,
    latitude,
    serviceHours,
    areaId,
    districtId,
    note,
    recyclableItems,
    isFavorite,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sites';
  @override
  VerificationContext validateIntegrity(
    Insertable<SiteEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('service_hours')) {
      context.handle(
        _serviceHoursMeta,
        serviceHours.isAcceptableOrUnknown(
          data['service_hours']!,
          _serviceHoursMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceHoursMeta);
    }
    if (data.containsKey('area_id')) {
      context.handle(
        _areaIdMeta,
        areaId.isAcceptableOrUnknown(data['area_id']!, _areaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_areaIdMeta);
    }
    if (data.containsKey('district_id')) {
      context.handle(
        _districtIdMeta,
        districtId.isAcceptableOrUnknown(data['district_id']!, _districtIdMeta),
      );
    } else if (isInserting) {
      context.missing(_districtIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SiteEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SiteEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      siteType: $SitesTable.$convertersiteType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}site_type'],
        )!,
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      serviceHours: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_hours'],
      )!,
      areaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area_id'],
      )!,
      districtId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      recyclableItems: $SitesTable.$converterrecyclableItems.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recyclable_items'],
        )!,
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $SitesTable createAlias(String alias) {
    return $SitesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SiteType, String, String> $convertersiteType =
      const EnumNameConverter<SiteType>(SiteType.values);
  static TypeConverter<List<RecyclableItemType>, String>
  $converterrecyclableItems = const RecyclableItemsConverter();
}

class SiteEntity extends DataClass implements Insertable<SiteEntity> {
  final String id;
  final String code;
  final String name;
  final SiteType siteType;
  final String address;
  final double longitude;
  final double latitude;
  final String serviceHours;
  final String areaId;
  final String districtId;
  final String? note;
  final List<RecyclableItemType> recyclableItems;
  final bool isFavorite;
  final DateTime cachedAt;
  const SiteEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.siteType,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.serviceHours,
    required this.areaId,
    required this.districtId,
    this.note,
    required this.recyclableItems,
    required this.isFavorite,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    {
      map['site_type'] = Variable<String>(
        $SitesTable.$convertersiteType.toSql(siteType),
      );
    }
    map['address'] = Variable<String>(address);
    map['longitude'] = Variable<double>(longitude);
    map['latitude'] = Variable<double>(latitude);
    map['service_hours'] = Variable<String>(serviceHours);
    map['area_id'] = Variable<String>(areaId);
    map['district_id'] = Variable<String>(districtId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['recyclable_items'] = Variable<String>(
        $SitesTable.$converterrecyclableItems.toSql(recyclableItems),
      );
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  SitesCompanion toCompanion(bool nullToAbsent) {
    return SitesCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      siteType: Value(siteType),
      address: Value(address),
      longitude: Value(longitude),
      latitude: Value(latitude),
      serviceHours: Value(serviceHours),
      areaId: Value(areaId),
      districtId: Value(districtId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      recyclableItems: Value(recyclableItems),
      isFavorite: Value(isFavorite),
      cachedAt: Value(cachedAt),
    );
  }

  factory SiteEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SiteEntity(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      siteType: $SitesTable.$convertersiteType.fromJson(
        serializer.fromJson<String>(json['siteType']),
      ),
      address: serializer.fromJson<String>(json['address']),
      longitude: serializer.fromJson<double>(json['longitude']),
      latitude: serializer.fromJson<double>(json['latitude']),
      serviceHours: serializer.fromJson<String>(json['serviceHours']),
      areaId: serializer.fromJson<String>(json['areaId']),
      districtId: serializer.fromJson<String>(json['districtId']),
      note: serializer.fromJson<String?>(json['note']),
      recyclableItems: serializer.fromJson<List<RecyclableItemType>>(
        json['recyclableItems'],
      ),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'siteType': serializer.toJson<String>(
        $SitesTable.$convertersiteType.toJson(siteType),
      ),
      'address': serializer.toJson<String>(address),
      'longitude': serializer.toJson<double>(longitude),
      'latitude': serializer.toJson<double>(latitude),
      'serviceHours': serializer.toJson<String>(serviceHours),
      'areaId': serializer.toJson<String>(areaId),
      'districtId': serializer.toJson<String>(districtId),
      'note': serializer.toJson<String?>(note),
      'recyclableItems': serializer.toJson<List<RecyclableItemType>>(
        recyclableItems,
      ),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  SiteEntity copyWith({
    String? id,
    String? code,
    String? name,
    SiteType? siteType,
    String? address,
    double? longitude,
    double? latitude,
    String? serviceHours,
    String? areaId,
    String? districtId,
    Value<String?> note = const Value.absent(),
    List<RecyclableItemType>? recyclableItems,
    bool? isFavorite,
    DateTime? cachedAt,
  }) => SiteEntity(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    siteType: siteType ?? this.siteType,
    address: address ?? this.address,
    longitude: longitude ?? this.longitude,
    latitude: latitude ?? this.latitude,
    serviceHours: serviceHours ?? this.serviceHours,
    areaId: areaId ?? this.areaId,
    districtId: districtId ?? this.districtId,
    note: note.present ? note.value : this.note,
    recyclableItems: recyclableItems ?? this.recyclableItems,
    isFavorite: isFavorite ?? this.isFavorite,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  SiteEntity copyWithCompanion(SitesCompanion data) {
    return SiteEntity(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      siteType: data.siteType.present ? data.siteType.value : this.siteType,
      address: data.address.present ? data.address.value : this.address,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      serviceHours: data.serviceHours.present
          ? data.serviceHours.value
          : this.serviceHours,
      areaId: data.areaId.present ? data.areaId.value : this.areaId,
      districtId: data.districtId.present
          ? data.districtId.value
          : this.districtId,
      note: data.note.present ? data.note.value : this.note,
      recyclableItems: data.recyclableItems.present
          ? data.recyclableItems.value
          : this.recyclableItems,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SiteEntity(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('siteType: $siteType, ')
          ..write('address: $address, ')
          ..write('longitude: $longitude, ')
          ..write('latitude: $latitude, ')
          ..write('serviceHours: $serviceHours, ')
          ..write('areaId: $areaId, ')
          ..write('districtId: $districtId, ')
          ..write('note: $note, ')
          ..write('recyclableItems: $recyclableItems, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    siteType,
    address,
    longitude,
    latitude,
    serviceHours,
    areaId,
    districtId,
    note,
    recyclableItems,
    isFavorite,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SiteEntity &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.siteType == this.siteType &&
          other.address == this.address &&
          other.longitude == this.longitude &&
          other.latitude == this.latitude &&
          other.serviceHours == this.serviceHours &&
          other.areaId == this.areaId &&
          other.districtId == this.districtId &&
          other.note == this.note &&
          other.recyclableItems == this.recyclableItems &&
          other.isFavorite == this.isFavorite &&
          other.cachedAt == this.cachedAt);
}

class SitesCompanion extends UpdateCompanion<SiteEntity> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<SiteType> siteType;
  final Value<String> address;
  final Value<double> longitude;
  final Value<double> latitude;
  final Value<String> serviceHours;
  final Value<String> areaId;
  final Value<String> districtId;
  final Value<String?> note;
  final Value<List<RecyclableItemType>> recyclableItems;
  final Value<bool> isFavorite;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const SitesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.siteType = const Value.absent(),
    this.address = const Value.absent(),
    this.longitude = const Value.absent(),
    this.latitude = const Value.absent(),
    this.serviceHours = const Value.absent(),
    this.areaId = const Value.absent(),
    this.districtId = const Value.absent(),
    this.note = const Value.absent(),
    this.recyclableItems = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SitesCompanion.insert({
    required String id,
    required String code,
    required String name,
    required SiteType siteType,
    required String address,
    required double longitude,
    required double latitude,
    required String serviceHours,
    required String areaId,
    required String districtId,
    this.note = const Value.absent(),
    required List<RecyclableItemType> recyclableItems,
    this.isFavorite = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       siteType = Value(siteType),
       address = Value(address),
       longitude = Value(longitude),
       latitude = Value(latitude),
       serviceHours = Value(serviceHours),
       areaId = Value(areaId),
       districtId = Value(districtId),
       recyclableItems = Value(recyclableItems),
       cachedAt = Value(cachedAt);
  static Insertable<SiteEntity> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? siteType,
    Expression<String>? address,
    Expression<double>? longitude,
    Expression<double>? latitude,
    Expression<String>? serviceHours,
    Expression<String>? areaId,
    Expression<String>? districtId,
    Expression<String>? note,
    Expression<String>? recyclableItems,
    Expression<bool>? isFavorite,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (siteType != null) 'site_type': siteType,
      if (address != null) 'address': address,
      if (longitude != null) 'longitude': longitude,
      if (latitude != null) 'latitude': latitude,
      if (serviceHours != null) 'service_hours': serviceHours,
      if (areaId != null) 'area_id': areaId,
      if (districtId != null) 'district_id': districtId,
      if (note != null) 'note': note,
      if (recyclableItems != null) 'recyclable_items': recyclableItems,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SitesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<SiteType>? siteType,
    Value<String>? address,
    Value<double>? longitude,
    Value<double>? latitude,
    Value<String>? serviceHours,
    Value<String>? areaId,
    Value<String>? districtId,
    Value<String?>? note,
    Value<List<RecyclableItemType>>? recyclableItems,
    Value<bool>? isFavorite,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return SitesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      siteType: siteType ?? this.siteType,
      address: address ?? this.address,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      serviceHours: serviceHours ?? this.serviceHours,
      areaId: areaId ?? this.areaId,
      districtId: districtId ?? this.districtId,
      note: note ?? this.note,
      recyclableItems: recyclableItems ?? this.recyclableItems,
      isFavorite: isFavorite ?? this.isFavorite,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (siteType.present) {
      map['site_type'] = Variable<String>(
        $SitesTable.$convertersiteType.toSql(siteType.value),
      );
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (serviceHours.present) {
      map['service_hours'] = Variable<String>(serviceHours.value);
    }
    if (areaId.present) {
      map['area_id'] = Variable<String>(areaId.value);
    }
    if (districtId.present) {
      map['district_id'] = Variable<String>(districtId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (recyclableItems.present) {
      map['recyclable_items'] = Variable<String>(
        $SitesTable.$converterrecyclableItems.toSql(recyclableItems.value),
      );
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SitesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('siteType: $siteType, ')
          ..write('address: $address, ')
          ..write('longitude: $longitude, ')
          ..write('latitude: $latitude, ')
          ..write('serviceHours: $serviceHours, ')
          ..write('areaId: $areaId, ')
          ..write('districtId: $districtId, ')
          ..write('note: $note, ')
          ..write('recyclableItems: $recyclableItems, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SiteStatusesTable extends SiteStatuses
    with TableInfo<$SiteStatusesTable, SiteStatusEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SiteStatusesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
    'site_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayStatusMeta = const VerificationMeta(
    'displayStatus',
  );
  @override
  late final GeneratedColumn<String> displayStatus = GeneratedColumn<String>(
    'display_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardTypeMeta = const VerificationMeta(
    'cardType',
  );
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
    'card_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isOffHoursMeta = const VerificationMeta(
    'isOffHours',
  );
  @override
  late final GeneratedColumn<bool> isOffHours = GeneratedColumn<bool>(
    'is_off_hours',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_off_hours" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<ItemStatus>?, String>
  itemStatusList =
      GeneratedColumn<String>(
        'item_status_list',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<ItemStatus>?>(
        $SiteStatusesTable.$converteritemStatusListn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<BinStatus>?, String>
  binStatusList =
      GeneratedColumn<String>(
        'bin_status_list',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<List<BinStatus>?>(
        $SiteStatusesTable.$converterbinStatusListn,
      );
  static const VerificationMeta _statusCachedAtMeta = const VerificationMeta(
    'statusCachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> statusCachedAt =
      GeneratedColumn<DateTime>(
        'status_cached_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    siteId,
    displayStatus,
    cardType,
    isOffHours,
    itemStatusList,
    binStatusList,
    statusCachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'site_statuses';
  @override
  VerificationContext validateIntegrity(
    Insertable<SiteStatusEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('display_status')) {
      context.handle(
        _displayStatusMeta,
        displayStatus.isAcceptableOrUnknown(
          data['display_status']!,
          _displayStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayStatusMeta);
    }
    if (data.containsKey('card_type')) {
      context.handle(
        _cardTypeMeta,
        cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta),
      );
    }
    if (data.containsKey('is_off_hours')) {
      context.handle(
        _isOffHoursMeta,
        isOffHours.isAcceptableOrUnknown(
          data['is_off_hours']!,
          _isOffHoursMeta,
        ),
      );
    }
    if (data.containsKey('status_cached_at')) {
      context.handle(
        _statusCachedAtMeta,
        statusCachedAt.isAcceptableOrUnknown(
          data['status_cached_at']!,
          _statusCachedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statusCachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {siteId};
  @override
  SiteStatusEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SiteStatusEntity(
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_id'],
      )!,
      displayStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_status'],
      )!,
      cardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_type'],
      ),
      isOffHours: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_off_hours'],
      ),
      itemStatusList: $SiteStatusesTable.$converteritemStatusListn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}item_status_list'],
        ),
      ),
      binStatusList: $SiteStatusesTable.$converterbinStatusListn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}bin_status_list'],
        ),
      ),
      statusCachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}status_cached_at'],
      )!,
    );
  }

  @override
  $SiteStatusesTable createAlias(String alias) {
    return $SiteStatusesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<ItemStatus>, String> $converteritemStatusList =
      const ItemStatusListConverter();
  static TypeConverter<List<ItemStatus>?, String?> $converteritemStatusListn =
      NullAwareTypeConverter.wrap($converteritemStatusList);
  static TypeConverter<List<BinStatus>, String> $converterbinStatusList =
      const BinStatusListConverter();
  static TypeConverter<List<BinStatus>?, String?> $converterbinStatusListn =
      NullAwareTypeConverter.wrap($converterbinStatusList);
}

class SiteStatusEntity extends DataClass
    implements Insertable<SiteStatusEntity> {
  final String siteId;
  final String displayStatus;
  final String? cardType;
  final bool? isOffHours;
  final List<ItemStatus>? itemStatusList;
  final List<BinStatus>? binStatusList;
  final DateTime statusCachedAt;
  const SiteStatusEntity({
    required this.siteId,
    required this.displayStatus,
    this.cardType,
    this.isOffHours,
    this.itemStatusList,
    this.binStatusList,
    required this.statusCachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['site_id'] = Variable<String>(siteId);
    map['display_status'] = Variable<String>(displayStatus);
    if (!nullToAbsent || cardType != null) {
      map['card_type'] = Variable<String>(cardType);
    }
    if (!nullToAbsent || isOffHours != null) {
      map['is_off_hours'] = Variable<bool>(isOffHours);
    }
    if (!nullToAbsent || itemStatusList != null) {
      map['item_status_list'] = Variable<String>(
        $SiteStatusesTable.$converteritemStatusListn.toSql(itemStatusList),
      );
    }
    if (!nullToAbsent || binStatusList != null) {
      map['bin_status_list'] = Variable<String>(
        $SiteStatusesTable.$converterbinStatusListn.toSql(binStatusList),
      );
    }
    map['status_cached_at'] = Variable<DateTime>(statusCachedAt);
    return map;
  }

  SiteStatusesCompanion toCompanion(bool nullToAbsent) {
    return SiteStatusesCompanion(
      siteId: Value(siteId),
      displayStatus: Value(displayStatus),
      cardType: cardType == null && nullToAbsent
          ? const Value.absent()
          : Value(cardType),
      isOffHours: isOffHours == null && nullToAbsent
          ? const Value.absent()
          : Value(isOffHours),
      itemStatusList: itemStatusList == null && nullToAbsent
          ? const Value.absent()
          : Value(itemStatusList),
      binStatusList: binStatusList == null && nullToAbsent
          ? const Value.absent()
          : Value(binStatusList),
      statusCachedAt: Value(statusCachedAt),
    );
  }

  factory SiteStatusEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SiteStatusEntity(
      siteId: serializer.fromJson<String>(json['siteId']),
      displayStatus: serializer.fromJson<String>(json['displayStatus']),
      cardType: serializer.fromJson<String?>(json['cardType']),
      isOffHours: serializer.fromJson<bool?>(json['isOffHours']),
      itemStatusList: serializer.fromJson<List<ItemStatus>?>(
        json['itemStatusList'],
      ),
      binStatusList: serializer.fromJson<List<BinStatus>?>(
        json['binStatusList'],
      ),
      statusCachedAt: serializer.fromJson<DateTime>(json['statusCachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'siteId': serializer.toJson<String>(siteId),
      'displayStatus': serializer.toJson<String>(displayStatus),
      'cardType': serializer.toJson<String?>(cardType),
      'isOffHours': serializer.toJson<bool?>(isOffHours),
      'itemStatusList': serializer.toJson<List<ItemStatus>?>(itemStatusList),
      'binStatusList': serializer.toJson<List<BinStatus>?>(binStatusList),
      'statusCachedAt': serializer.toJson<DateTime>(statusCachedAt),
    };
  }

  SiteStatusEntity copyWith({
    String? siteId,
    String? displayStatus,
    Value<String?> cardType = const Value.absent(),
    Value<bool?> isOffHours = const Value.absent(),
    Value<List<ItemStatus>?> itemStatusList = const Value.absent(),
    Value<List<BinStatus>?> binStatusList = const Value.absent(),
    DateTime? statusCachedAt,
  }) => SiteStatusEntity(
    siteId: siteId ?? this.siteId,
    displayStatus: displayStatus ?? this.displayStatus,
    cardType: cardType.present ? cardType.value : this.cardType,
    isOffHours: isOffHours.present ? isOffHours.value : this.isOffHours,
    itemStatusList: itemStatusList.present
        ? itemStatusList.value
        : this.itemStatusList,
    binStatusList: binStatusList.present
        ? binStatusList.value
        : this.binStatusList,
    statusCachedAt: statusCachedAt ?? this.statusCachedAt,
  );
  SiteStatusEntity copyWithCompanion(SiteStatusesCompanion data) {
    return SiteStatusEntity(
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      displayStatus: data.displayStatus.present
          ? data.displayStatus.value
          : this.displayStatus,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      isOffHours: data.isOffHours.present
          ? data.isOffHours.value
          : this.isOffHours,
      itemStatusList: data.itemStatusList.present
          ? data.itemStatusList.value
          : this.itemStatusList,
      binStatusList: data.binStatusList.present
          ? data.binStatusList.value
          : this.binStatusList,
      statusCachedAt: data.statusCachedAt.present
          ? data.statusCachedAt.value
          : this.statusCachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SiteStatusEntity(')
          ..write('siteId: $siteId, ')
          ..write('displayStatus: $displayStatus, ')
          ..write('cardType: $cardType, ')
          ..write('isOffHours: $isOffHours, ')
          ..write('itemStatusList: $itemStatusList, ')
          ..write('binStatusList: $binStatusList, ')
          ..write('statusCachedAt: $statusCachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    siteId,
    displayStatus,
    cardType,
    isOffHours,
    itemStatusList,
    binStatusList,
    statusCachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SiteStatusEntity &&
          other.siteId == this.siteId &&
          other.displayStatus == this.displayStatus &&
          other.cardType == this.cardType &&
          other.isOffHours == this.isOffHours &&
          other.itemStatusList == this.itemStatusList &&
          other.binStatusList == this.binStatusList &&
          other.statusCachedAt == this.statusCachedAt);
}

class SiteStatusesCompanion extends UpdateCompanion<SiteStatusEntity> {
  final Value<String> siteId;
  final Value<String> displayStatus;
  final Value<String?> cardType;
  final Value<bool?> isOffHours;
  final Value<List<ItemStatus>?> itemStatusList;
  final Value<List<BinStatus>?> binStatusList;
  final Value<DateTime> statusCachedAt;
  final Value<int> rowid;
  const SiteStatusesCompanion({
    this.siteId = const Value.absent(),
    this.displayStatus = const Value.absent(),
    this.cardType = const Value.absent(),
    this.isOffHours = const Value.absent(),
    this.itemStatusList = const Value.absent(),
    this.binStatusList = const Value.absent(),
    this.statusCachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SiteStatusesCompanion.insert({
    required String siteId,
    required String displayStatus,
    this.cardType = const Value.absent(),
    this.isOffHours = const Value.absent(),
    this.itemStatusList = const Value.absent(),
    this.binStatusList = const Value.absent(),
    required DateTime statusCachedAt,
    this.rowid = const Value.absent(),
  }) : siteId = Value(siteId),
       displayStatus = Value(displayStatus),
       statusCachedAt = Value(statusCachedAt);
  static Insertable<SiteStatusEntity> custom({
    Expression<String>? siteId,
    Expression<String>? displayStatus,
    Expression<String>? cardType,
    Expression<bool>? isOffHours,
    Expression<String>? itemStatusList,
    Expression<String>? binStatusList,
    Expression<DateTime>? statusCachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (siteId != null) 'site_id': siteId,
      if (displayStatus != null) 'display_status': displayStatus,
      if (cardType != null) 'card_type': cardType,
      if (isOffHours != null) 'is_off_hours': isOffHours,
      if (itemStatusList != null) 'item_status_list': itemStatusList,
      if (binStatusList != null) 'bin_status_list': binStatusList,
      if (statusCachedAt != null) 'status_cached_at': statusCachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SiteStatusesCompanion copyWith({
    Value<String>? siteId,
    Value<String>? displayStatus,
    Value<String?>? cardType,
    Value<bool?>? isOffHours,
    Value<List<ItemStatus>?>? itemStatusList,
    Value<List<BinStatus>?>? binStatusList,
    Value<DateTime>? statusCachedAt,
    Value<int>? rowid,
  }) {
    return SiteStatusesCompanion(
      siteId: siteId ?? this.siteId,
      displayStatus: displayStatus ?? this.displayStatus,
      cardType: cardType ?? this.cardType,
      isOffHours: isOffHours ?? this.isOffHours,
      itemStatusList: itemStatusList ?? this.itemStatusList,
      binStatusList: binStatusList ?? this.binStatusList,
      statusCachedAt: statusCachedAt ?? this.statusCachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (displayStatus.present) {
      map['display_status'] = Variable<String>(displayStatus.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (isOffHours.present) {
      map['is_off_hours'] = Variable<bool>(isOffHours.value);
    }
    if (itemStatusList.present) {
      map['item_status_list'] = Variable<String>(
        $SiteStatusesTable.$converteritemStatusListn.toSql(
          itemStatusList.value,
        ),
      );
    }
    if (binStatusList.present) {
      map['bin_status_list'] = Variable<String>(
        $SiteStatusesTable.$converterbinStatusListn.toSql(binStatusList.value),
      );
    }
    if (statusCachedAt.present) {
      map['status_cached_at'] = Variable<DateTime>(statusCachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SiteStatusesCompanion(')
          ..write('siteId: $siteId, ')
          ..write('displayStatus: $displayStatus, ')
          ..write('cardType: $cardType, ')
          ..write('isOffHours: $isOffHours, ')
          ..write('itemStatusList: $itemStatusList, ')
          ..write('binStatusList: $binStatusList, ')
          ..write('statusCachedAt: $statusCachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrandsTable extends Brands with TableInfo<$BrandsTable, BrandEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrandsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BrandCategory?, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<BrandCategory?>($BrandsTable.$convertercategoryn);
  static const VerificationMeta _logoUrlMeta = const VerificationMeta(
    'logoUrl',
  );
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
    'logo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPremiumMeta = const VerificationMeta(
    'isPremium',
  );
  @override
  late final GeneratedColumn<bool> isPremium = GeneratedColumn<bool>(
    'is_premium',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_premium" IN (0, 1))',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMdUrlMeta = const VerificationMeta(
    'descriptionMdUrl',
  );
  @override
  late final GeneratedColumn<String> descriptionMdUrl = GeneratedColumn<String>(
    'description_md_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  couponRuleIds = GeneratedColumn<String>(
    'coupon_rule_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($BrandsTable.$convertercouponRuleIds);
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isActive,
    name,
    category,
    logoUrl,
    isPremium,
    startDate,
    endDate,
    descriptionMdUrl,
    sortOrder,
    couponRuleIds,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brands';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrandEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('logo_url')) {
      context.handle(
        _logoUrlMeta,
        logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta),
      );
    }
    if (data.containsKey('is_premium')) {
      context.handle(
        _isPremiumMeta,
        isPremium.isAcceptableOrUnknown(data['is_premium']!, _isPremiumMeta),
      );
    } else if (isInserting) {
      context.missing(_isPremiumMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('description_md_url')) {
      context.handle(
        _descriptionMdUrlMeta,
        descriptionMdUrl.isAcceptableOrUnknown(
          data['description_md_url']!,
          _descriptionMdUrlMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrandEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrandEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: $BrandsTable.$convertercategoryn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        ),
      ),
      logoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_url'],
      ),
      isPremium: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_premium'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      descriptionMdUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_md_url'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      couponRuleIds: $BrandsTable.$convertercouponRuleIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}coupon_rule_ids'],
        )!,
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $BrandsTable createAlias(String alias) {
    return $BrandsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BrandCategory, String, String> $convertercategory =
      const EnumNameConverter<BrandCategory>(BrandCategory.values);
  static JsonTypeConverter2<BrandCategory?, String?, String?>
  $convertercategoryn = JsonTypeConverter2.asNullable($convertercategory);
  static TypeConverter<List<String>, String> $convertercouponRuleIds =
      const CouponRuleIdsConverter();
}

class BrandEntity extends DataClass implements Insertable<BrandEntity> {
  final String id;
  final bool isActive;
  final String name;
  final BrandCategory? category;
  final String? logoUrl;
  final bool isPremium;
  final DateTime startDate;
  final DateTime? endDate;
  final String? descriptionMdUrl;
  final int sortOrder;
  final List<String> couponRuleIds;
  final DateTime cachedAt;
  const BrandEntity({
    required this.id,
    required this.isActive,
    required this.name,
    this.category,
    this.logoUrl,
    required this.isPremium,
    required this.startDate,
    this.endDate,
    this.descriptionMdUrl,
    required this.sortOrder,
    required this.couponRuleIds,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['is_active'] = Variable<bool>(isActive);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(
        $BrandsTable.$convertercategoryn.toSql(category),
      );
    }
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    map['is_premium'] = Variable<bool>(isPremium);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || descriptionMdUrl != null) {
      map['description_md_url'] = Variable<String>(descriptionMdUrl);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    {
      map['coupon_rule_ids'] = Variable<String>(
        $BrandsTable.$convertercouponRuleIds.toSql(couponRuleIds),
      );
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  BrandsCompanion toCompanion(bool nullToAbsent) {
    return BrandsCompanion(
      id: Value(id),
      isActive: Value(isActive),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      isPremium: Value(isPremium),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      descriptionMdUrl: descriptionMdUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionMdUrl),
      sortOrder: Value(sortOrder),
      couponRuleIds: Value(couponRuleIds),
      cachedAt: Value(cachedAt),
    );
  }

  factory BrandEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrandEntity(
      id: serializer.fromJson<String>(json['id']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      name: serializer.fromJson<String>(json['name']),
      category: $BrandsTable.$convertercategoryn.fromJson(
        serializer.fromJson<String?>(json['category']),
      ),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      isPremium: serializer.fromJson<bool>(json['isPremium']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      descriptionMdUrl: serializer.fromJson<String?>(json['descriptionMdUrl']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      couponRuleIds: serializer.fromJson<List<String>>(json['couponRuleIds']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'isActive': serializer.toJson<bool>(isActive),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(
        $BrandsTable.$convertercategoryn.toJson(category),
      ),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'isPremium': serializer.toJson<bool>(isPremium),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'descriptionMdUrl': serializer.toJson<String?>(descriptionMdUrl),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'couponRuleIds': serializer.toJson<List<String>>(couponRuleIds),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  BrandEntity copyWith({
    String? id,
    bool? isActive,
    String? name,
    Value<BrandCategory?> category = const Value.absent(),
    Value<String?> logoUrl = const Value.absent(),
    bool? isPremium,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<String?> descriptionMdUrl = const Value.absent(),
    int? sortOrder,
    List<String>? couponRuleIds,
    DateTime? cachedAt,
  }) => BrandEntity(
    id: id ?? this.id,
    isActive: isActive ?? this.isActive,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
    isPremium: isPremium ?? this.isPremium,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    descriptionMdUrl: descriptionMdUrl.present
        ? descriptionMdUrl.value
        : this.descriptionMdUrl,
    sortOrder: sortOrder ?? this.sortOrder,
    couponRuleIds: couponRuleIds ?? this.couponRuleIds,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  BrandEntity copyWithCompanion(BrandsCompanion data) {
    return BrandEntity(
      id: data.id.present ? data.id.value : this.id,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      isPremium: data.isPremium.present ? data.isPremium.value : this.isPremium,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      descriptionMdUrl: data.descriptionMdUrl.present
          ? data.descriptionMdUrl.value
          : this.descriptionMdUrl,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      couponRuleIds: data.couponRuleIds.present
          ? data.couponRuleIds.value
          : this.couponRuleIds,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrandEntity(')
          ..write('id: $id, ')
          ..write('isActive: $isActive, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('isPremium: $isPremium, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('descriptionMdUrl: $descriptionMdUrl, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('couponRuleIds: $couponRuleIds, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    isActive,
    name,
    category,
    logoUrl,
    isPremium,
    startDate,
    endDate,
    descriptionMdUrl,
    sortOrder,
    couponRuleIds,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrandEntity &&
          other.id == this.id &&
          other.isActive == this.isActive &&
          other.name == this.name &&
          other.category == this.category &&
          other.logoUrl == this.logoUrl &&
          other.isPremium == this.isPremium &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.descriptionMdUrl == this.descriptionMdUrl &&
          other.sortOrder == this.sortOrder &&
          other.couponRuleIds == this.couponRuleIds &&
          other.cachedAt == this.cachedAt);
}

class BrandsCompanion extends UpdateCompanion<BrandEntity> {
  final Value<String> id;
  final Value<bool> isActive;
  final Value<String> name;
  final Value<BrandCategory?> category;
  final Value<String?> logoUrl;
  final Value<bool> isPremium;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String?> descriptionMdUrl;
  final Value<int> sortOrder;
  final Value<List<String>> couponRuleIds;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const BrandsCompanion({
    this.id = const Value.absent(),
    this.isActive = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.descriptionMdUrl = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.couponRuleIds = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrandsCompanion.insert({
    required String id,
    required bool isActive,
    required String name,
    this.category = const Value.absent(),
    this.logoUrl = const Value.absent(),
    required bool isPremium,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.descriptionMdUrl = const Value.absent(),
    required int sortOrder,
    required List<String> couponRuleIds,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       isActive = Value(isActive),
       name = Value(name),
       isPremium = Value(isPremium),
       startDate = Value(startDate),
       sortOrder = Value(sortOrder),
       couponRuleIds = Value(couponRuleIds),
       cachedAt = Value(cachedAt);
  static Insertable<BrandEntity> custom({
    Expression<String>? id,
    Expression<bool>? isActive,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? logoUrl,
    Expression<bool>? isPremium,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? descriptionMdUrl,
    Expression<int>? sortOrder,
    Expression<String>? couponRuleIds,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isActive != null) 'is_active': isActive,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (isPremium != null) 'is_premium': isPremium,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (descriptionMdUrl != null) 'description_md_url': descriptionMdUrl,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (couponRuleIds != null) 'coupon_rule_ids': couponRuleIds,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrandsCompanion copyWith({
    Value<String>? id,
    Value<bool>? isActive,
    Value<String>? name,
    Value<BrandCategory?>? category,
    Value<String?>? logoUrl,
    Value<bool>? isPremium,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<String?>? descriptionMdUrl,
    Value<int>? sortOrder,
    Value<List<String>>? couponRuleIds,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return BrandsCompanion(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      name: name ?? this.name,
      category: category ?? this.category,
      logoUrl: logoUrl ?? this.logoUrl,
      isPremium: isPremium ?? this.isPremium,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      descriptionMdUrl: descriptionMdUrl ?? this.descriptionMdUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      couponRuleIds: couponRuleIds ?? this.couponRuleIds,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $BrandsTable.$convertercategoryn.toSql(category.value),
      );
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (isPremium.present) {
      map['is_premium'] = Variable<bool>(isPremium.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (descriptionMdUrl.present) {
      map['description_md_url'] = Variable<String>(descriptionMdUrl.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (couponRuleIds.present) {
      map['coupon_rule_ids'] = Variable<String>(
        $BrandsTable.$convertercouponRuleIds.toSql(couponRuleIds.value),
      );
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrandsCompanion(')
          ..write('id: $id, ')
          ..write('isActive: $isActive, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('isPremium: $isPremium, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('descriptionMdUrl: $descriptionMdUrl, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('couponRuleIds: $couponRuleIds, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CouponRulesTable extends CouponRules
    with TableInfo<$CouponRulesTable, CouponRuleEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CouponRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _categoryCodeMeta = const VerificationMeta(
    'categoryCode',
  );
  @override
  late final GeneratedColumn<String> categoryCode = GeneratedColumn<String>(
    'category_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandIdMeta = const VerificationMeta(
    'brandId',
  );
  @override
  late final GeneratedColumn<String> brandId = GeneratedColumn<String>(
    'brand_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandNameMeta = const VerificationMeta(
    'brandName',
  );
  @override
  late final GeneratedColumn<String> brandName = GeneratedColumn<String>(
    'brand_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardImageUrlMeta = const VerificationMeta(
    'cardImageUrl',
  );
  @override
  late final GeneratedColumn<String> cardImageUrl = GeneratedColumn<String>(
    'card_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _donationCodeMeta = const VerificationMeta(
    'donationCode',
  );
  @override
  late final GeneratedColumn<String> donationCode = GeneratedColumn<String>(
    'donation_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPremiumMeta = const VerificationMeta(
    'isPremium',
  );
  @override
  late final GeneratedColumn<bool> isPremium = GeneratedColumn<bool>(
    'is_premium',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_premium" IN (0, 1))',
    ),
  );
  static const VerificationMeta _promoLabelMeta = const VerificationMeta(
    'promoLabel',
  );
  @override
  late final GeneratedColumn<String> promoLabel = GeneratedColumn<String>(
    'promo_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shortNoticeMeta = const VerificationMeta(
    'shortNotice',
  );
  @override
  late final GeneratedColumn<String> shortNotice = GeneratedColumn<String>(
    'short_notice',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayUnitMeta = const VerificationMeta(
    'displayUnit',
  );
  @override
  late final GeneratedColumn<String> displayUnit = GeneratedColumn<String>(
    'display_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exchangeDisplayTextMeta =
      const VerificationMeta('exchangeDisplayText');
  @override
  late final GeneratedColumn<String> exchangeDisplayText =
      GeneratedColumn<String>(
        'exchange_display_text',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _exchangeInputTypeMeta = const VerificationMeta(
    'exchangeInputType',
  );
  @override
  late final GeneratedColumn<String> exchangeInputType =
      GeneratedColumn<String>(
        'exchange_input_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _exchangeFlowTypeMeta = const VerificationMeta(
    'exchangeFlowType',
  );
  @override
  late final GeneratedColumn<String> exchangeFlowType = GeneratedColumn<String>(
    'exchange_flow_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetRedeemTypeMeta = const VerificationMeta(
    'assetRedeemType',
  );
  @override
  late final GeneratedColumn<String> assetRedeemType = GeneratedColumn<String>(
    'asset_redeem_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxPerExchangeCountMeta =
      const VerificationMeta('maxPerExchangeCount');
  @override
  late final GeneratedColumn<int> maxPerExchangeCount = GeneratedColumn<int>(
    'max_per_exchange_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exchangeStepValueMeta = const VerificationMeta(
    'exchangeStepValue',
  );
  @override
  late final GeneratedColumn<int> exchangeStepValue = GeneratedColumn<int>(
    'exchange_step_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  geofenceAreaIds = GeneratedColumn<String>(
    'geofence_area_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<String>>($CouponRulesTable.$convertergeofenceAreaIds);
  static const VerificationMeta _exchangeableStartAtMeta =
      const VerificationMeta('exchangeableStartAt');
  @override
  late final GeneratedColumn<DateTime> exchangeableStartAt =
      GeneratedColumn<DateTime>(
        'exchangeable_start_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _exchangeableEndAtMeta = const VerificationMeta(
    'exchangeableEndAt',
  );
  @override
  late final GeneratedColumn<DateTime> exchangeableEndAt =
      GeneratedColumn<DateTime>(
        'exchangeable_end_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>(
        'last_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<CarouselItem>, String>
  carouselList = GeneratedColumn<String>(
    'carousel_list',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<CarouselItem>>($CouponRulesTable.$convertercarouselList);
  static const VerificationMeta _exchangeAlertMeta = const VerificationMeta(
    'exchangeAlert',
  );
  @override
  late final GeneratedColumn<String> exchangeAlert = GeneratedColumn<String>(
    'exchange_alert',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalRedemptionUrlMeta =
      const VerificationMeta('externalRedemptionUrl');
  @override
  late final GeneratedColumn<String> externalRedemptionUrl =
      GeneratedColumn<String>(
        'external_redemption_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _rulesSummaryMdUrlMeta = const VerificationMeta(
    'rulesSummaryMdUrl',
  );
  @override
  late final GeneratedColumn<String> rulesSummaryMdUrl =
      GeneratedColumn<String>(
        'rules_summary_md_url',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _redemptionTermsMdUrlMeta =
      const VerificationMeta('redemptionTermsMdUrl');
  @override
  late final GeneratedColumn<String> redemptionTermsMdUrl =
      GeneratedColumn<String>(
        'redemption_terms_md_url',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _userInstructionMdUrlMeta =
      const VerificationMeta('userInstructionMdUrl');
  @override
  late final GeneratedColumn<String> userInstructionMdUrl =
      GeneratedColumn<String>(
        'user_instruction_md_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _staffInstructionMdUrlMeta =
      const VerificationMeta('staffInstructionMdUrl');
  @override
  late final GeneratedColumn<String> staffInstructionMdUrl =
      GeneratedColumn<String>(
        'staff_instruction_md_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isActive,
    categoryCode,
    title,
    brandId,
    brandName,
    cardImageUrl,
    donationCode,
    isPremium,
    promoLabel,
    shortNotice,
    unitPrice,
    displayUnit,
    currencyCode,
    exchangeDisplayText,
    exchangeInputType,
    exchangeFlowType,
    assetRedeemType,
    maxPerExchangeCount,
    exchangeStepValue,
    geofenceAreaIds,
    exchangeableStartAt,
    exchangeableEndAt,
    lastUpdatedAt,
    carouselList,
    exchangeAlert,
    externalRedemptionUrl,
    rulesSummaryMdUrl,
    redemptionTermsMdUrl,
    userInstructionMdUrl,
    staffInstructionMdUrl,
    sortOrder,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coupon_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<CouponRuleEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('category_code')) {
      context.handle(
        _categoryCodeMeta,
        categoryCode.isAcceptableOrUnknown(
          data['category_code']!,
          _categoryCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryCodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('brand_id')) {
      context.handle(
        _brandIdMeta,
        brandId.isAcceptableOrUnknown(data['brand_id']!, _brandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_brandIdMeta);
    }
    if (data.containsKey('brand_name')) {
      context.handle(
        _brandNameMeta,
        brandName.isAcceptableOrUnknown(data['brand_name']!, _brandNameMeta),
      );
    } else if (isInserting) {
      context.missing(_brandNameMeta);
    }
    if (data.containsKey('card_image_url')) {
      context.handle(
        _cardImageUrlMeta,
        cardImageUrl.isAcceptableOrUnknown(
          data['card_image_url']!,
          _cardImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('donation_code')) {
      context.handle(
        _donationCodeMeta,
        donationCode.isAcceptableOrUnknown(
          data['donation_code']!,
          _donationCodeMeta,
        ),
      );
    }
    if (data.containsKey('is_premium')) {
      context.handle(
        _isPremiumMeta,
        isPremium.isAcceptableOrUnknown(data['is_premium']!, _isPremiumMeta),
      );
    } else if (isInserting) {
      context.missing(_isPremiumMeta);
    }
    if (data.containsKey('promo_label')) {
      context.handle(
        _promoLabelMeta,
        promoLabel.isAcceptableOrUnknown(data['promo_label']!, _promoLabelMeta),
      );
    }
    if (data.containsKey('short_notice')) {
      context.handle(
        _shortNoticeMeta,
        shortNotice.isAcceptableOrUnknown(
          data['short_notice']!,
          _shortNoticeMeta,
        ),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('display_unit')) {
      context.handle(
        _displayUnitMeta,
        displayUnit.isAcceptableOrUnknown(
          data['display_unit']!,
          _displayUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayUnitMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('exchange_display_text')) {
      context.handle(
        _exchangeDisplayTextMeta,
        exchangeDisplayText.isAcceptableOrUnknown(
          data['exchange_display_text']!,
          _exchangeDisplayTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exchangeDisplayTextMeta);
    }
    if (data.containsKey('exchange_input_type')) {
      context.handle(
        _exchangeInputTypeMeta,
        exchangeInputType.isAcceptableOrUnknown(
          data['exchange_input_type']!,
          _exchangeInputTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exchangeInputTypeMeta);
    }
    if (data.containsKey('exchange_flow_type')) {
      context.handle(
        _exchangeFlowTypeMeta,
        exchangeFlowType.isAcceptableOrUnknown(
          data['exchange_flow_type']!,
          _exchangeFlowTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exchangeFlowTypeMeta);
    }
    if (data.containsKey('asset_redeem_type')) {
      context.handle(
        _assetRedeemTypeMeta,
        assetRedeemType.isAcceptableOrUnknown(
          data['asset_redeem_type']!,
          _assetRedeemTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assetRedeemTypeMeta);
    }
    if (data.containsKey('max_per_exchange_count')) {
      context.handle(
        _maxPerExchangeCountMeta,
        maxPerExchangeCount.isAcceptableOrUnknown(
          data['max_per_exchange_count']!,
          _maxPerExchangeCountMeta,
        ),
      );
    }
    if (data.containsKey('exchange_step_value')) {
      context.handle(
        _exchangeStepValueMeta,
        exchangeStepValue.isAcceptableOrUnknown(
          data['exchange_step_value']!,
          _exchangeStepValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exchangeStepValueMeta);
    }
    if (data.containsKey('exchangeable_start_at')) {
      context.handle(
        _exchangeableStartAtMeta,
        exchangeableStartAt.isAcceptableOrUnknown(
          data['exchangeable_start_at']!,
          _exchangeableStartAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exchangeableStartAtMeta);
    }
    if (data.containsKey('exchangeable_end_at')) {
      context.handle(
        _exchangeableEndAtMeta,
        exchangeableEndAt.isAcceptableOrUnknown(
          data['exchangeable_end_at']!,
          _exchangeableEndAtMeta,
        ),
      );
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    if (data.containsKey('exchange_alert')) {
      context.handle(
        _exchangeAlertMeta,
        exchangeAlert.isAcceptableOrUnknown(
          data['exchange_alert']!,
          _exchangeAlertMeta,
        ),
      );
    }
    if (data.containsKey('external_redemption_url')) {
      context.handle(
        _externalRedemptionUrlMeta,
        externalRedemptionUrl.isAcceptableOrUnknown(
          data['external_redemption_url']!,
          _externalRedemptionUrlMeta,
        ),
      );
    }
    if (data.containsKey('rules_summary_md_url')) {
      context.handle(
        _rulesSummaryMdUrlMeta,
        rulesSummaryMdUrl.isAcceptableOrUnknown(
          data['rules_summary_md_url']!,
          _rulesSummaryMdUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rulesSummaryMdUrlMeta);
    }
    if (data.containsKey('redemption_terms_md_url')) {
      context.handle(
        _redemptionTermsMdUrlMeta,
        redemptionTermsMdUrl.isAcceptableOrUnknown(
          data['redemption_terms_md_url']!,
          _redemptionTermsMdUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_redemptionTermsMdUrlMeta);
    }
    if (data.containsKey('user_instruction_md_url')) {
      context.handle(
        _userInstructionMdUrlMeta,
        userInstructionMdUrl.isAcceptableOrUnknown(
          data['user_instruction_md_url']!,
          _userInstructionMdUrlMeta,
        ),
      );
    }
    if (data.containsKey('staff_instruction_md_url')) {
      context.handle(
        _staffInstructionMdUrlMeta,
        staffInstructionMdUrl.isAcceptableOrUnknown(
          data['staff_instruction_md_url']!,
          _staffInstructionMdUrlMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CouponRuleEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CouponRuleEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      categoryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      brandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_id'],
      )!,
      brandName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_name'],
      )!,
      cardImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_image_url'],
      ),
      donationCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}donation_code'],
      ),
      isPremium: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_premium'],
      )!,
      promoLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}promo_label'],
      ),
      shortNotice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}short_notice'],
      ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price'],
      )!,
      displayUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_unit'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      exchangeDisplayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exchange_display_text'],
      )!,
      exchangeInputType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exchange_input_type'],
      )!,
      exchangeFlowType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exchange_flow_type'],
      )!,
      assetRedeemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}asset_redeem_type'],
      )!,
      maxPerExchangeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_per_exchange_count'],
      ),
      exchangeStepValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exchange_step_value'],
      )!,
      geofenceAreaIds: $CouponRulesTable.$convertergeofenceAreaIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}geofence_area_ids'],
        )!,
      ),
      exchangeableStartAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exchangeable_start_at'],
      )!,
      exchangeableEndAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exchangeable_end_at'],
      ),
      lastUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated_at'],
      )!,
      carouselList: $CouponRulesTable.$convertercarouselList.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}carousel_list'],
        )!,
      ),
      exchangeAlert: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exchange_alert'],
      ),
      externalRedemptionUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_redemption_url'],
      ),
      rulesSummaryMdUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rules_summary_md_url'],
      )!,
      redemptionTermsMdUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}redemption_terms_md_url'],
      )!,
      userInstructionMdUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_instruction_md_url'],
      ),
      staffInstructionMdUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}staff_instruction_md_url'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CouponRulesTable createAlias(String alias) {
    return $CouponRulesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertergeofenceAreaIds =
      const CouponRuleIdsConverter();
  static TypeConverter<List<CarouselItem>, String> $convertercarouselList =
      const CarouselListConverter();
}

class CouponRuleEntity extends DataClass
    implements Insertable<CouponRuleEntity> {
  final String id;
  final bool isActive;
  final String categoryCode;
  final String title;
  final String brandId;
  final String brandName;
  final String? cardImageUrl;
  final String? donationCode;
  final bool isPremium;
  final String? promoLabel;
  final String? shortNotice;
  final int unitPrice;
  final String displayUnit;
  final String currencyCode;
  final String exchangeDisplayText;
  final String exchangeInputType;
  final String exchangeFlowType;
  final String assetRedeemType;
  final int? maxPerExchangeCount;
  final int exchangeStepValue;
  final List<String> geofenceAreaIds;
  final DateTime exchangeableStartAt;
  final DateTime? exchangeableEndAt;
  final DateTime lastUpdatedAt;
  final List<CarouselItem> carouselList;
  final String? exchangeAlert;
  final String? externalRedemptionUrl;
  final String rulesSummaryMdUrl;
  final String redemptionTermsMdUrl;
  final String? userInstructionMdUrl;
  final String? staffInstructionMdUrl;
  final int sortOrder;
  final DateTime cachedAt;
  const CouponRuleEntity({
    required this.id,
    required this.isActive,
    required this.categoryCode,
    required this.title,
    required this.brandId,
    required this.brandName,
    this.cardImageUrl,
    this.donationCode,
    required this.isPremium,
    this.promoLabel,
    this.shortNotice,
    required this.unitPrice,
    required this.displayUnit,
    required this.currencyCode,
    required this.exchangeDisplayText,
    required this.exchangeInputType,
    required this.exchangeFlowType,
    required this.assetRedeemType,
    this.maxPerExchangeCount,
    required this.exchangeStepValue,
    required this.geofenceAreaIds,
    required this.exchangeableStartAt,
    this.exchangeableEndAt,
    required this.lastUpdatedAt,
    required this.carouselList,
    this.exchangeAlert,
    this.externalRedemptionUrl,
    required this.rulesSummaryMdUrl,
    required this.redemptionTermsMdUrl,
    this.userInstructionMdUrl,
    this.staffInstructionMdUrl,
    required this.sortOrder,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['is_active'] = Variable<bool>(isActive);
    map['category_code'] = Variable<String>(categoryCode);
    map['title'] = Variable<String>(title);
    map['brand_id'] = Variable<String>(brandId);
    map['brand_name'] = Variable<String>(brandName);
    if (!nullToAbsent || cardImageUrl != null) {
      map['card_image_url'] = Variable<String>(cardImageUrl);
    }
    if (!nullToAbsent || donationCode != null) {
      map['donation_code'] = Variable<String>(donationCode);
    }
    map['is_premium'] = Variable<bool>(isPremium);
    if (!nullToAbsent || promoLabel != null) {
      map['promo_label'] = Variable<String>(promoLabel);
    }
    if (!nullToAbsent || shortNotice != null) {
      map['short_notice'] = Variable<String>(shortNotice);
    }
    map['unit_price'] = Variable<int>(unitPrice);
    map['display_unit'] = Variable<String>(displayUnit);
    map['currency_code'] = Variable<String>(currencyCode);
    map['exchange_display_text'] = Variable<String>(exchangeDisplayText);
    map['exchange_input_type'] = Variable<String>(exchangeInputType);
    map['exchange_flow_type'] = Variable<String>(exchangeFlowType);
    map['asset_redeem_type'] = Variable<String>(assetRedeemType);
    if (!nullToAbsent || maxPerExchangeCount != null) {
      map['max_per_exchange_count'] = Variable<int>(maxPerExchangeCount);
    }
    map['exchange_step_value'] = Variable<int>(exchangeStepValue);
    {
      map['geofence_area_ids'] = Variable<String>(
        $CouponRulesTable.$convertergeofenceAreaIds.toSql(geofenceAreaIds),
      );
    }
    map['exchangeable_start_at'] = Variable<DateTime>(exchangeableStartAt);
    if (!nullToAbsent || exchangeableEndAt != null) {
      map['exchangeable_end_at'] = Variable<DateTime>(exchangeableEndAt);
    }
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    {
      map['carousel_list'] = Variable<String>(
        $CouponRulesTable.$convertercarouselList.toSql(carouselList),
      );
    }
    if (!nullToAbsent || exchangeAlert != null) {
      map['exchange_alert'] = Variable<String>(exchangeAlert);
    }
    if (!nullToAbsent || externalRedemptionUrl != null) {
      map['external_redemption_url'] = Variable<String>(externalRedemptionUrl);
    }
    map['rules_summary_md_url'] = Variable<String>(rulesSummaryMdUrl);
    map['redemption_terms_md_url'] = Variable<String>(redemptionTermsMdUrl);
    if (!nullToAbsent || userInstructionMdUrl != null) {
      map['user_instruction_md_url'] = Variable<String>(userInstructionMdUrl);
    }
    if (!nullToAbsent || staffInstructionMdUrl != null) {
      map['staff_instruction_md_url'] = Variable<String>(staffInstructionMdUrl);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CouponRulesCompanion toCompanion(bool nullToAbsent) {
    return CouponRulesCompanion(
      id: Value(id),
      isActive: Value(isActive),
      categoryCode: Value(categoryCode),
      title: Value(title),
      brandId: Value(brandId),
      brandName: Value(brandName),
      cardImageUrl: cardImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(cardImageUrl),
      donationCode: donationCode == null && nullToAbsent
          ? const Value.absent()
          : Value(donationCode),
      isPremium: Value(isPremium),
      promoLabel: promoLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(promoLabel),
      shortNotice: shortNotice == null && nullToAbsent
          ? const Value.absent()
          : Value(shortNotice),
      unitPrice: Value(unitPrice),
      displayUnit: Value(displayUnit),
      currencyCode: Value(currencyCode),
      exchangeDisplayText: Value(exchangeDisplayText),
      exchangeInputType: Value(exchangeInputType),
      exchangeFlowType: Value(exchangeFlowType),
      assetRedeemType: Value(assetRedeemType),
      maxPerExchangeCount: maxPerExchangeCount == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPerExchangeCount),
      exchangeStepValue: Value(exchangeStepValue),
      geofenceAreaIds: Value(geofenceAreaIds),
      exchangeableStartAt: Value(exchangeableStartAt),
      exchangeableEndAt: exchangeableEndAt == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeableEndAt),
      lastUpdatedAt: Value(lastUpdatedAt),
      carouselList: Value(carouselList),
      exchangeAlert: exchangeAlert == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeAlert),
      externalRedemptionUrl: externalRedemptionUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(externalRedemptionUrl),
      rulesSummaryMdUrl: Value(rulesSummaryMdUrl),
      redemptionTermsMdUrl: Value(redemptionTermsMdUrl),
      userInstructionMdUrl: userInstructionMdUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(userInstructionMdUrl),
      staffInstructionMdUrl: staffInstructionMdUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(staffInstructionMdUrl),
      sortOrder: Value(sortOrder),
      cachedAt: Value(cachedAt),
    );
  }

  factory CouponRuleEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CouponRuleEntity(
      id: serializer.fromJson<String>(json['id']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      categoryCode: serializer.fromJson<String>(json['categoryCode']),
      title: serializer.fromJson<String>(json['title']),
      brandId: serializer.fromJson<String>(json['brandId']),
      brandName: serializer.fromJson<String>(json['brandName']),
      cardImageUrl: serializer.fromJson<String?>(json['cardImageUrl']),
      donationCode: serializer.fromJson<String?>(json['donationCode']),
      isPremium: serializer.fromJson<bool>(json['isPremium']),
      promoLabel: serializer.fromJson<String?>(json['promoLabel']),
      shortNotice: serializer.fromJson<String?>(json['shortNotice']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      displayUnit: serializer.fromJson<String>(json['displayUnit']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      exchangeDisplayText: serializer.fromJson<String>(
        json['exchangeDisplayText'],
      ),
      exchangeInputType: serializer.fromJson<String>(json['exchangeInputType']),
      exchangeFlowType: serializer.fromJson<String>(json['exchangeFlowType']),
      assetRedeemType: serializer.fromJson<String>(json['assetRedeemType']),
      maxPerExchangeCount: serializer.fromJson<int?>(
        json['maxPerExchangeCount'],
      ),
      exchangeStepValue: serializer.fromJson<int>(json['exchangeStepValue']),
      geofenceAreaIds: serializer.fromJson<List<String>>(
        json['geofenceAreaIds'],
      ),
      exchangeableStartAt: serializer.fromJson<DateTime>(
        json['exchangeableStartAt'],
      ),
      exchangeableEndAt: serializer.fromJson<DateTime?>(
        json['exchangeableEndAt'],
      ),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
      carouselList: serializer.fromJson<List<CarouselItem>>(
        json['carouselList'],
      ),
      exchangeAlert: serializer.fromJson<String?>(json['exchangeAlert']),
      externalRedemptionUrl: serializer.fromJson<String?>(
        json['externalRedemptionUrl'],
      ),
      rulesSummaryMdUrl: serializer.fromJson<String>(json['rulesSummaryMdUrl']),
      redemptionTermsMdUrl: serializer.fromJson<String>(
        json['redemptionTermsMdUrl'],
      ),
      userInstructionMdUrl: serializer.fromJson<String?>(
        json['userInstructionMdUrl'],
      ),
      staffInstructionMdUrl: serializer.fromJson<String?>(
        json['staffInstructionMdUrl'],
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'isActive': serializer.toJson<bool>(isActive),
      'categoryCode': serializer.toJson<String>(categoryCode),
      'title': serializer.toJson<String>(title),
      'brandId': serializer.toJson<String>(brandId),
      'brandName': serializer.toJson<String>(brandName),
      'cardImageUrl': serializer.toJson<String?>(cardImageUrl),
      'donationCode': serializer.toJson<String?>(donationCode),
      'isPremium': serializer.toJson<bool>(isPremium),
      'promoLabel': serializer.toJson<String?>(promoLabel),
      'shortNotice': serializer.toJson<String?>(shortNotice),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'displayUnit': serializer.toJson<String>(displayUnit),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'exchangeDisplayText': serializer.toJson<String>(exchangeDisplayText),
      'exchangeInputType': serializer.toJson<String>(exchangeInputType),
      'exchangeFlowType': serializer.toJson<String>(exchangeFlowType),
      'assetRedeemType': serializer.toJson<String>(assetRedeemType),
      'maxPerExchangeCount': serializer.toJson<int?>(maxPerExchangeCount),
      'exchangeStepValue': serializer.toJson<int>(exchangeStepValue),
      'geofenceAreaIds': serializer.toJson<List<String>>(geofenceAreaIds),
      'exchangeableStartAt': serializer.toJson<DateTime>(exchangeableStartAt),
      'exchangeableEndAt': serializer.toJson<DateTime?>(exchangeableEndAt),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
      'carouselList': serializer.toJson<List<CarouselItem>>(carouselList),
      'exchangeAlert': serializer.toJson<String?>(exchangeAlert),
      'externalRedemptionUrl': serializer.toJson<String?>(
        externalRedemptionUrl,
      ),
      'rulesSummaryMdUrl': serializer.toJson<String>(rulesSummaryMdUrl),
      'redemptionTermsMdUrl': serializer.toJson<String>(redemptionTermsMdUrl),
      'userInstructionMdUrl': serializer.toJson<String?>(userInstructionMdUrl),
      'staffInstructionMdUrl': serializer.toJson<String?>(
        staffInstructionMdUrl,
      ),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CouponRuleEntity copyWith({
    String? id,
    bool? isActive,
    String? categoryCode,
    String? title,
    String? brandId,
    String? brandName,
    Value<String?> cardImageUrl = const Value.absent(),
    Value<String?> donationCode = const Value.absent(),
    bool? isPremium,
    Value<String?> promoLabel = const Value.absent(),
    Value<String?> shortNotice = const Value.absent(),
    int? unitPrice,
    String? displayUnit,
    String? currencyCode,
    String? exchangeDisplayText,
    String? exchangeInputType,
    String? exchangeFlowType,
    String? assetRedeemType,
    Value<int?> maxPerExchangeCount = const Value.absent(),
    int? exchangeStepValue,
    List<String>? geofenceAreaIds,
    DateTime? exchangeableStartAt,
    Value<DateTime?> exchangeableEndAt = const Value.absent(),
    DateTime? lastUpdatedAt,
    List<CarouselItem>? carouselList,
    Value<String?> exchangeAlert = const Value.absent(),
    Value<String?> externalRedemptionUrl = const Value.absent(),
    String? rulesSummaryMdUrl,
    String? redemptionTermsMdUrl,
    Value<String?> userInstructionMdUrl = const Value.absent(),
    Value<String?> staffInstructionMdUrl = const Value.absent(),
    int? sortOrder,
    DateTime? cachedAt,
  }) => CouponRuleEntity(
    id: id ?? this.id,
    isActive: isActive ?? this.isActive,
    categoryCode: categoryCode ?? this.categoryCode,
    title: title ?? this.title,
    brandId: brandId ?? this.brandId,
    brandName: brandName ?? this.brandName,
    cardImageUrl: cardImageUrl.present ? cardImageUrl.value : this.cardImageUrl,
    donationCode: donationCode.present ? donationCode.value : this.donationCode,
    isPremium: isPremium ?? this.isPremium,
    promoLabel: promoLabel.present ? promoLabel.value : this.promoLabel,
    shortNotice: shortNotice.present ? shortNotice.value : this.shortNotice,
    unitPrice: unitPrice ?? this.unitPrice,
    displayUnit: displayUnit ?? this.displayUnit,
    currencyCode: currencyCode ?? this.currencyCode,
    exchangeDisplayText: exchangeDisplayText ?? this.exchangeDisplayText,
    exchangeInputType: exchangeInputType ?? this.exchangeInputType,
    exchangeFlowType: exchangeFlowType ?? this.exchangeFlowType,
    assetRedeemType: assetRedeemType ?? this.assetRedeemType,
    maxPerExchangeCount: maxPerExchangeCount.present
        ? maxPerExchangeCount.value
        : this.maxPerExchangeCount,
    exchangeStepValue: exchangeStepValue ?? this.exchangeStepValue,
    geofenceAreaIds: geofenceAreaIds ?? this.geofenceAreaIds,
    exchangeableStartAt: exchangeableStartAt ?? this.exchangeableStartAt,
    exchangeableEndAt: exchangeableEndAt.present
        ? exchangeableEndAt.value
        : this.exchangeableEndAt,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    carouselList: carouselList ?? this.carouselList,
    exchangeAlert: exchangeAlert.present
        ? exchangeAlert.value
        : this.exchangeAlert,
    externalRedemptionUrl: externalRedemptionUrl.present
        ? externalRedemptionUrl.value
        : this.externalRedemptionUrl,
    rulesSummaryMdUrl: rulesSummaryMdUrl ?? this.rulesSummaryMdUrl,
    redemptionTermsMdUrl: redemptionTermsMdUrl ?? this.redemptionTermsMdUrl,
    userInstructionMdUrl: userInstructionMdUrl.present
        ? userInstructionMdUrl.value
        : this.userInstructionMdUrl,
    staffInstructionMdUrl: staffInstructionMdUrl.present
        ? staffInstructionMdUrl.value
        : this.staffInstructionMdUrl,
    sortOrder: sortOrder ?? this.sortOrder,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CouponRuleEntity copyWithCompanion(CouponRulesCompanion data) {
    return CouponRuleEntity(
      id: data.id.present ? data.id.value : this.id,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      categoryCode: data.categoryCode.present
          ? data.categoryCode.value
          : this.categoryCode,
      title: data.title.present ? data.title.value : this.title,
      brandId: data.brandId.present ? data.brandId.value : this.brandId,
      brandName: data.brandName.present ? data.brandName.value : this.brandName,
      cardImageUrl: data.cardImageUrl.present
          ? data.cardImageUrl.value
          : this.cardImageUrl,
      donationCode: data.donationCode.present
          ? data.donationCode.value
          : this.donationCode,
      isPremium: data.isPremium.present ? data.isPremium.value : this.isPremium,
      promoLabel: data.promoLabel.present
          ? data.promoLabel.value
          : this.promoLabel,
      shortNotice: data.shortNotice.present
          ? data.shortNotice.value
          : this.shortNotice,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      displayUnit: data.displayUnit.present
          ? data.displayUnit.value
          : this.displayUnit,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      exchangeDisplayText: data.exchangeDisplayText.present
          ? data.exchangeDisplayText.value
          : this.exchangeDisplayText,
      exchangeInputType: data.exchangeInputType.present
          ? data.exchangeInputType.value
          : this.exchangeInputType,
      exchangeFlowType: data.exchangeFlowType.present
          ? data.exchangeFlowType.value
          : this.exchangeFlowType,
      assetRedeemType: data.assetRedeemType.present
          ? data.assetRedeemType.value
          : this.assetRedeemType,
      maxPerExchangeCount: data.maxPerExchangeCount.present
          ? data.maxPerExchangeCount.value
          : this.maxPerExchangeCount,
      exchangeStepValue: data.exchangeStepValue.present
          ? data.exchangeStepValue.value
          : this.exchangeStepValue,
      geofenceAreaIds: data.geofenceAreaIds.present
          ? data.geofenceAreaIds.value
          : this.geofenceAreaIds,
      exchangeableStartAt: data.exchangeableStartAt.present
          ? data.exchangeableStartAt.value
          : this.exchangeableStartAt,
      exchangeableEndAt: data.exchangeableEndAt.present
          ? data.exchangeableEndAt.value
          : this.exchangeableEndAt,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
      carouselList: data.carouselList.present
          ? data.carouselList.value
          : this.carouselList,
      exchangeAlert: data.exchangeAlert.present
          ? data.exchangeAlert.value
          : this.exchangeAlert,
      externalRedemptionUrl: data.externalRedemptionUrl.present
          ? data.externalRedemptionUrl.value
          : this.externalRedemptionUrl,
      rulesSummaryMdUrl: data.rulesSummaryMdUrl.present
          ? data.rulesSummaryMdUrl.value
          : this.rulesSummaryMdUrl,
      redemptionTermsMdUrl: data.redemptionTermsMdUrl.present
          ? data.redemptionTermsMdUrl.value
          : this.redemptionTermsMdUrl,
      userInstructionMdUrl: data.userInstructionMdUrl.present
          ? data.userInstructionMdUrl.value
          : this.userInstructionMdUrl,
      staffInstructionMdUrl: data.staffInstructionMdUrl.present
          ? data.staffInstructionMdUrl.value
          : this.staffInstructionMdUrl,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CouponRuleEntity(')
          ..write('id: $id, ')
          ..write('isActive: $isActive, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('title: $title, ')
          ..write('brandId: $brandId, ')
          ..write('brandName: $brandName, ')
          ..write('cardImageUrl: $cardImageUrl, ')
          ..write('donationCode: $donationCode, ')
          ..write('isPremium: $isPremium, ')
          ..write('promoLabel: $promoLabel, ')
          ..write('shortNotice: $shortNotice, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('displayUnit: $displayUnit, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('exchangeDisplayText: $exchangeDisplayText, ')
          ..write('exchangeInputType: $exchangeInputType, ')
          ..write('exchangeFlowType: $exchangeFlowType, ')
          ..write('assetRedeemType: $assetRedeemType, ')
          ..write('maxPerExchangeCount: $maxPerExchangeCount, ')
          ..write('exchangeStepValue: $exchangeStepValue, ')
          ..write('geofenceAreaIds: $geofenceAreaIds, ')
          ..write('exchangeableStartAt: $exchangeableStartAt, ')
          ..write('exchangeableEndAt: $exchangeableEndAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('carouselList: $carouselList, ')
          ..write('exchangeAlert: $exchangeAlert, ')
          ..write('externalRedemptionUrl: $externalRedemptionUrl, ')
          ..write('rulesSummaryMdUrl: $rulesSummaryMdUrl, ')
          ..write('redemptionTermsMdUrl: $redemptionTermsMdUrl, ')
          ..write('userInstructionMdUrl: $userInstructionMdUrl, ')
          ..write('staffInstructionMdUrl: $staffInstructionMdUrl, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    isActive,
    categoryCode,
    title,
    brandId,
    brandName,
    cardImageUrl,
    donationCode,
    isPremium,
    promoLabel,
    shortNotice,
    unitPrice,
    displayUnit,
    currencyCode,
    exchangeDisplayText,
    exchangeInputType,
    exchangeFlowType,
    assetRedeemType,
    maxPerExchangeCount,
    exchangeStepValue,
    geofenceAreaIds,
    exchangeableStartAt,
    exchangeableEndAt,
    lastUpdatedAt,
    carouselList,
    exchangeAlert,
    externalRedemptionUrl,
    rulesSummaryMdUrl,
    redemptionTermsMdUrl,
    userInstructionMdUrl,
    staffInstructionMdUrl,
    sortOrder,
    cachedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CouponRuleEntity &&
          other.id == this.id &&
          other.isActive == this.isActive &&
          other.categoryCode == this.categoryCode &&
          other.title == this.title &&
          other.brandId == this.brandId &&
          other.brandName == this.brandName &&
          other.cardImageUrl == this.cardImageUrl &&
          other.donationCode == this.donationCode &&
          other.isPremium == this.isPremium &&
          other.promoLabel == this.promoLabel &&
          other.shortNotice == this.shortNotice &&
          other.unitPrice == this.unitPrice &&
          other.displayUnit == this.displayUnit &&
          other.currencyCode == this.currencyCode &&
          other.exchangeDisplayText == this.exchangeDisplayText &&
          other.exchangeInputType == this.exchangeInputType &&
          other.exchangeFlowType == this.exchangeFlowType &&
          other.assetRedeemType == this.assetRedeemType &&
          other.maxPerExchangeCount == this.maxPerExchangeCount &&
          other.exchangeStepValue == this.exchangeStepValue &&
          other.geofenceAreaIds == this.geofenceAreaIds &&
          other.exchangeableStartAt == this.exchangeableStartAt &&
          other.exchangeableEndAt == this.exchangeableEndAt &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.carouselList == this.carouselList &&
          other.exchangeAlert == this.exchangeAlert &&
          other.externalRedemptionUrl == this.externalRedemptionUrl &&
          other.rulesSummaryMdUrl == this.rulesSummaryMdUrl &&
          other.redemptionTermsMdUrl == this.redemptionTermsMdUrl &&
          other.userInstructionMdUrl == this.userInstructionMdUrl &&
          other.staffInstructionMdUrl == this.staffInstructionMdUrl &&
          other.sortOrder == this.sortOrder &&
          other.cachedAt == this.cachedAt);
}

class CouponRulesCompanion extends UpdateCompanion<CouponRuleEntity> {
  final Value<String> id;
  final Value<bool> isActive;
  final Value<String> categoryCode;
  final Value<String> title;
  final Value<String> brandId;
  final Value<String> brandName;
  final Value<String?> cardImageUrl;
  final Value<String?> donationCode;
  final Value<bool> isPremium;
  final Value<String?> promoLabel;
  final Value<String?> shortNotice;
  final Value<int> unitPrice;
  final Value<String> displayUnit;
  final Value<String> currencyCode;
  final Value<String> exchangeDisplayText;
  final Value<String> exchangeInputType;
  final Value<String> exchangeFlowType;
  final Value<String> assetRedeemType;
  final Value<int?> maxPerExchangeCount;
  final Value<int> exchangeStepValue;
  final Value<List<String>> geofenceAreaIds;
  final Value<DateTime> exchangeableStartAt;
  final Value<DateTime?> exchangeableEndAt;
  final Value<DateTime> lastUpdatedAt;
  final Value<List<CarouselItem>> carouselList;
  final Value<String?> exchangeAlert;
  final Value<String?> externalRedemptionUrl;
  final Value<String> rulesSummaryMdUrl;
  final Value<String> redemptionTermsMdUrl;
  final Value<String?> userInstructionMdUrl;
  final Value<String?> staffInstructionMdUrl;
  final Value<int> sortOrder;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CouponRulesCompanion({
    this.id = const Value.absent(),
    this.isActive = const Value.absent(),
    this.categoryCode = const Value.absent(),
    this.title = const Value.absent(),
    this.brandId = const Value.absent(),
    this.brandName = const Value.absent(),
    this.cardImageUrl = const Value.absent(),
    this.donationCode = const Value.absent(),
    this.isPremium = const Value.absent(),
    this.promoLabel = const Value.absent(),
    this.shortNotice = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.displayUnit = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.exchangeDisplayText = const Value.absent(),
    this.exchangeInputType = const Value.absent(),
    this.exchangeFlowType = const Value.absent(),
    this.assetRedeemType = const Value.absent(),
    this.maxPerExchangeCount = const Value.absent(),
    this.exchangeStepValue = const Value.absent(),
    this.geofenceAreaIds = const Value.absent(),
    this.exchangeableStartAt = const Value.absent(),
    this.exchangeableEndAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.carouselList = const Value.absent(),
    this.exchangeAlert = const Value.absent(),
    this.externalRedemptionUrl = const Value.absent(),
    this.rulesSummaryMdUrl = const Value.absent(),
    this.redemptionTermsMdUrl = const Value.absent(),
    this.userInstructionMdUrl = const Value.absent(),
    this.staffInstructionMdUrl = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CouponRulesCompanion.insert({
    required String id,
    required bool isActive,
    required String categoryCode,
    required String title,
    required String brandId,
    required String brandName,
    this.cardImageUrl = const Value.absent(),
    this.donationCode = const Value.absent(),
    required bool isPremium,
    this.promoLabel = const Value.absent(),
    this.shortNotice = const Value.absent(),
    required int unitPrice,
    required String displayUnit,
    required String currencyCode,
    required String exchangeDisplayText,
    required String exchangeInputType,
    required String exchangeFlowType,
    required String assetRedeemType,
    this.maxPerExchangeCount = const Value.absent(),
    required int exchangeStepValue,
    required List<String> geofenceAreaIds,
    required DateTime exchangeableStartAt,
    this.exchangeableEndAt = const Value.absent(),
    required DateTime lastUpdatedAt,
    required List<CarouselItem> carouselList,
    this.exchangeAlert = const Value.absent(),
    this.externalRedemptionUrl = const Value.absent(),
    required String rulesSummaryMdUrl,
    required String redemptionTermsMdUrl,
    this.userInstructionMdUrl = const Value.absent(),
    this.staffInstructionMdUrl = const Value.absent(),
    required int sortOrder,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       isActive = Value(isActive),
       categoryCode = Value(categoryCode),
       title = Value(title),
       brandId = Value(brandId),
       brandName = Value(brandName),
       isPremium = Value(isPremium),
       unitPrice = Value(unitPrice),
       displayUnit = Value(displayUnit),
       currencyCode = Value(currencyCode),
       exchangeDisplayText = Value(exchangeDisplayText),
       exchangeInputType = Value(exchangeInputType),
       exchangeFlowType = Value(exchangeFlowType),
       assetRedeemType = Value(assetRedeemType),
       exchangeStepValue = Value(exchangeStepValue),
       geofenceAreaIds = Value(geofenceAreaIds),
       exchangeableStartAt = Value(exchangeableStartAt),
       lastUpdatedAt = Value(lastUpdatedAt),
       carouselList = Value(carouselList),
       rulesSummaryMdUrl = Value(rulesSummaryMdUrl),
       redemptionTermsMdUrl = Value(redemptionTermsMdUrl),
       sortOrder = Value(sortOrder),
       cachedAt = Value(cachedAt);
  static Insertable<CouponRuleEntity> custom({
    Expression<String>? id,
    Expression<bool>? isActive,
    Expression<String>? categoryCode,
    Expression<String>? title,
    Expression<String>? brandId,
    Expression<String>? brandName,
    Expression<String>? cardImageUrl,
    Expression<String>? donationCode,
    Expression<bool>? isPremium,
    Expression<String>? promoLabel,
    Expression<String>? shortNotice,
    Expression<int>? unitPrice,
    Expression<String>? displayUnit,
    Expression<String>? currencyCode,
    Expression<String>? exchangeDisplayText,
    Expression<String>? exchangeInputType,
    Expression<String>? exchangeFlowType,
    Expression<String>? assetRedeemType,
    Expression<int>? maxPerExchangeCount,
    Expression<int>? exchangeStepValue,
    Expression<String>? geofenceAreaIds,
    Expression<DateTime>? exchangeableStartAt,
    Expression<DateTime>? exchangeableEndAt,
    Expression<DateTime>? lastUpdatedAt,
    Expression<String>? carouselList,
    Expression<String>? exchangeAlert,
    Expression<String>? externalRedemptionUrl,
    Expression<String>? rulesSummaryMdUrl,
    Expression<String>? redemptionTermsMdUrl,
    Expression<String>? userInstructionMdUrl,
    Expression<String>? staffInstructionMdUrl,
    Expression<int>? sortOrder,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isActive != null) 'is_active': isActive,
      if (categoryCode != null) 'category_code': categoryCode,
      if (title != null) 'title': title,
      if (brandId != null) 'brand_id': brandId,
      if (brandName != null) 'brand_name': brandName,
      if (cardImageUrl != null) 'card_image_url': cardImageUrl,
      if (donationCode != null) 'donation_code': donationCode,
      if (isPremium != null) 'is_premium': isPremium,
      if (promoLabel != null) 'promo_label': promoLabel,
      if (shortNotice != null) 'short_notice': shortNotice,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (displayUnit != null) 'display_unit': displayUnit,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (exchangeDisplayText != null)
        'exchange_display_text': exchangeDisplayText,
      if (exchangeInputType != null) 'exchange_input_type': exchangeInputType,
      if (exchangeFlowType != null) 'exchange_flow_type': exchangeFlowType,
      if (assetRedeemType != null) 'asset_redeem_type': assetRedeemType,
      if (maxPerExchangeCount != null)
        'max_per_exchange_count': maxPerExchangeCount,
      if (exchangeStepValue != null) 'exchange_step_value': exchangeStepValue,
      if (geofenceAreaIds != null) 'geofence_area_ids': geofenceAreaIds,
      if (exchangeableStartAt != null)
        'exchangeable_start_at': exchangeableStartAt,
      if (exchangeableEndAt != null) 'exchangeable_end_at': exchangeableEndAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (carouselList != null) 'carousel_list': carouselList,
      if (exchangeAlert != null) 'exchange_alert': exchangeAlert,
      if (externalRedemptionUrl != null)
        'external_redemption_url': externalRedemptionUrl,
      if (rulesSummaryMdUrl != null) 'rules_summary_md_url': rulesSummaryMdUrl,
      if (redemptionTermsMdUrl != null)
        'redemption_terms_md_url': redemptionTermsMdUrl,
      if (userInstructionMdUrl != null)
        'user_instruction_md_url': userInstructionMdUrl,
      if (staffInstructionMdUrl != null)
        'staff_instruction_md_url': staffInstructionMdUrl,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CouponRulesCompanion copyWith({
    Value<String>? id,
    Value<bool>? isActive,
    Value<String>? categoryCode,
    Value<String>? title,
    Value<String>? brandId,
    Value<String>? brandName,
    Value<String?>? cardImageUrl,
    Value<String?>? donationCode,
    Value<bool>? isPremium,
    Value<String?>? promoLabel,
    Value<String?>? shortNotice,
    Value<int>? unitPrice,
    Value<String>? displayUnit,
    Value<String>? currencyCode,
    Value<String>? exchangeDisplayText,
    Value<String>? exchangeInputType,
    Value<String>? exchangeFlowType,
    Value<String>? assetRedeemType,
    Value<int?>? maxPerExchangeCount,
    Value<int>? exchangeStepValue,
    Value<List<String>>? geofenceAreaIds,
    Value<DateTime>? exchangeableStartAt,
    Value<DateTime?>? exchangeableEndAt,
    Value<DateTime>? lastUpdatedAt,
    Value<List<CarouselItem>>? carouselList,
    Value<String?>? exchangeAlert,
    Value<String?>? externalRedemptionUrl,
    Value<String>? rulesSummaryMdUrl,
    Value<String>? redemptionTermsMdUrl,
    Value<String?>? userInstructionMdUrl,
    Value<String?>? staffInstructionMdUrl,
    Value<int>? sortOrder,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CouponRulesCompanion(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      categoryCode: categoryCode ?? this.categoryCode,
      title: title ?? this.title,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      cardImageUrl: cardImageUrl ?? this.cardImageUrl,
      donationCode: donationCode ?? this.donationCode,
      isPremium: isPremium ?? this.isPremium,
      promoLabel: promoLabel ?? this.promoLabel,
      shortNotice: shortNotice ?? this.shortNotice,
      unitPrice: unitPrice ?? this.unitPrice,
      displayUnit: displayUnit ?? this.displayUnit,
      currencyCode: currencyCode ?? this.currencyCode,
      exchangeDisplayText: exchangeDisplayText ?? this.exchangeDisplayText,
      exchangeInputType: exchangeInputType ?? this.exchangeInputType,
      exchangeFlowType: exchangeFlowType ?? this.exchangeFlowType,
      assetRedeemType: assetRedeemType ?? this.assetRedeemType,
      maxPerExchangeCount: maxPerExchangeCount ?? this.maxPerExchangeCount,
      exchangeStepValue: exchangeStepValue ?? this.exchangeStepValue,
      geofenceAreaIds: geofenceAreaIds ?? this.geofenceAreaIds,
      exchangeableStartAt: exchangeableStartAt ?? this.exchangeableStartAt,
      exchangeableEndAt: exchangeableEndAt ?? this.exchangeableEndAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      carouselList: carouselList ?? this.carouselList,
      exchangeAlert: exchangeAlert ?? this.exchangeAlert,
      externalRedemptionUrl:
          externalRedemptionUrl ?? this.externalRedemptionUrl,
      rulesSummaryMdUrl: rulesSummaryMdUrl ?? this.rulesSummaryMdUrl,
      redemptionTermsMdUrl: redemptionTermsMdUrl ?? this.redemptionTermsMdUrl,
      userInstructionMdUrl: userInstructionMdUrl ?? this.userInstructionMdUrl,
      staffInstructionMdUrl:
          staffInstructionMdUrl ?? this.staffInstructionMdUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (categoryCode.present) {
      map['category_code'] = Variable<String>(categoryCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (brandId.present) {
      map['brand_id'] = Variable<String>(brandId.value);
    }
    if (brandName.present) {
      map['brand_name'] = Variable<String>(brandName.value);
    }
    if (cardImageUrl.present) {
      map['card_image_url'] = Variable<String>(cardImageUrl.value);
    }
    if (donationCode.present) {
      map['donation_code'] = Variable<String>(donationCode.value);
    }
    if (isPremium.present) {
      map['is_premium'] = Variable<bool>(isPremium.value);
    }
    if (promoLabel.present) {
      map['promo_label'] = Variable<String>(promoLabel.value);
    }
    if (shortNotice.present) {
      map['short_notice'] = Variable<String>(shortNotice.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (displayUnit.present) {
      map['display_unit'] = Variable<String>(displayUnit.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (exchangeDisplayText.present) {
      map['exchange_display_text'] = Variable<String>(
        exchangeDisplayText.value,
      );
    }
    if (exchangeInputType.present) {
      map['exchange_input_type'] = Variable<String>(exchangeInputType.value);
    }
    if (exchangeFlowType.present) {
      map['exchange_flow_type'] = Variable<String>(exchangeFlowType.value);
    }
    if (assetRedeemType.present) {
      map['asset_redeem_type'] = Variable<String>(assetRedeemType.value);
    }
    if (maxPerExchangeCount.present) {
      map['max_per_exchange_count'] = Variable<int>(maxPerExchangeCount.value);
    }
    if (exchangeStepValue.present) {
      map['exchange_step_value'] = Variable<int>(exchangeStepValue.value);
    }
    if (geofenceAreaIds.present) {
      map['geofence_area_ids'] = Variable<String>(
        $CouponRulesTable.$convertergeofenceAreaIds.toSql(
          geofenceAreaIds.value,
        ),
      );
    }
    if (exchangeableStartAt.present) {
      map['exchangeable_start_at'] = Variable<DateTime>(
        exchangeableStartAt.value,
      );
    }
    if (exchangeableEndAt.present) {
      map['exchangeable_end_at'] = Variable<DateTime>(exchangeableEndAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (carouselList.present) {
      map['carousel_list'] = Variable<String>(
        $CouponRulesTable.$convertercarouselList.toSql(carouselList.value),
      );
    }
    if (exchangeAlert.present) {
      map['exchange_alert'] = Variable<String>(exchangeAlert.value);
    }
    if (externalRedemptionUrl.present) {
      map['external_redemption_url'] = Variable<String>(
        externalRedemptionUrl.value,
      );
    }
    if (rulesSummaryMdUrl.present) {
      map['rules_summary_md_url'] = Variable<String>(rulesSummaryMdUrl.value);
    }
    if (redemptionTermsMdUrl.present) {
      map['redemption_terms_md_url'] = Variable<String>(
        redemptionTermsMdUrl.value,
      );
    }
    if (userInstructionMdUrl.present) {
      map['user_instruction_md_url'] = Variable<String>(
        userInstructionMdUrl.value,
      );
    }
    if (staffInstructionMdUrl.present) {
      map['staff_instruction_md_url'] = Variable<String>(
        staffInstructionMdUrl.value,
      );
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CouponRulesCompanion(')
          ..write('id: $id, ')
          ..write('isActive: $isActive, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('title: $title, ')
          ..write('brandId: $brandId, ')
          ..write('brandName: $brandName, ')
          ..write('cardImageUrl: $cardImageUrl, ')
          ..write('donationCode: $donationCode, ')
          ..write('isPremium: $isPremium, ')
          ..write('promoLabel: $promoLabel, ')
          ..write('shortNotice: $shortNotice, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('displayUnit: $displayUnit, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('exchangeDisplayText: $exchangeDisplayText, ')
          ..write('exchangeInputType: $exchangeInputType, ')
          ..write('exchangeFlowType: $exchangeFlowType, ')
          ..write('assetRedeemType: $assetRedeemType, ')
          ..write('maxPerExchangeCount: $maxPerExchangeCount, ')
          ..write('exchangeStepValue: $exchangeStepValue, ')
          ..write('geofenceAreaIds: $geofenceAreaIds, ')
          ..write('exchangeableStartAt: $exchangeableStartAt, ')
          ..write('exchangeableEndAt: $exchangeableEndAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('carouselList: $carouselList, ')
          ..write('exchangeAlert: $exchangeAlert, ')
          ..write('externalRedemptionUrl: $externalRedemptionUrl, ')
          ..write('rulesSummaryMdUrl: $rulesSummaryMdUrl, ')
          ..write('redemptionTermsMdUrl: $redemptionTermsMdUrl, ')
          ..write('userInstructionMdUrl: $userInstructionMdUrl, ')
          ..write('staffInstructionMdUrl: $staffInstructionMdUrl, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CouponRuleStatusesTable extends CouponRuleStatuses
    with TableInfo<$CouponRuleStatusesTable, CouponRuleStatusEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CouponRuleStatusesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _couponRuleIdMeta = const VerificationMeta(
    'couponRuleId',
  );
  @override
  late final GeneratedColumn<String> couponRuleId = GeneratedColumn<String>(
    'coupon_rule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayStatusMeta = const VerificationMeta(
    'displayStatus',
  );
  @override
  late final GeneratedColumn<String> displayStatus = GeneratedColumn<String>(
    'display_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusCachedAtMeta = const VerificationMeta(
    'statusCachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> statusCachedAt =
      GeneratedColumn<DateTime>(
        'status_cached_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    couponRuleId,
    displayStatus,
    statusCachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'coupon_rule_statuses';
  @override
  VerificationContext validateIntegrity(
    Insertable<CouponRuleStatusEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('coupon_rule_id')) {
      context.handle(
        _couponRuleIdMeta,
        couponRuleId.isAcceptableOrUnknown(
          data['coupon_rule_id']!,
          _couponRuleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_couponRuleIdMeta);
    }
    if (data.containsKey('display_status')) {
      context.handle(
        _displayStatusMeta,
        displayStatus.isAcceptableOrUnknown(
          data['display_status']!,
          _displayStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayStatusMeta);
    }
    if (data.containsKey('status_cached_at')) {
      context.handle(
        _statusCachedAtMeta,
        statusCachedAt.isAcceptableOrUnknown(
          data['status_cached_at']!,
          _statusCachedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_statusCachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {couponRuleId};
  @override
  CouponRuleStatusEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CouponRuleStatusEntity(
      couponRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coupon_rule_id'],
      )!,
      displayStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_status'],
      )!,
      statusCachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}status_cached_at'],
      )!,
    );
  }

  @override
  $CouponRuleStatusesTable createAlias(String alias) {
    return $CouponRuleStatusesTable(attachedDatabase, alias);
  }
}

class CouponRuleStatusEntity extends DataClass
    implements Insertable<CouponRuleStatusEntity> {
  final String couponRuleId;
  final String displayStatus;
  final DateTime statusCachedAt;
  const CouponRuleStatusEntity({
    required this.couponRuleId,
    required this.displayStatus,
    required this.statusCachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['coupon_rule_id'] = Variable<String>(couponRuleId);
    map['display_status'] = Variable<String>(displayStatus);
    map['status_cached_at'] = Variable<DateTime>(statusCachedAt);
    return map;
  }

  CouponRuleStatusesCompanion toCompanion(bool nullToAbsent) {
    return CouponRuleStatusesCompanion(
      couponRuleId: Value(couponRuleId),
      displayStatus: Value(displayStatus),
      statusCachedAt: Value(statusCachedAt),
    );
  }

  factory CouponRuleStatusEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CouponRuleStatusEntity(
      couponRuleId: serializer.fromJson<String>(json['couponRuleId']),
      displayStatus: serializer.fromJson<String>(json['displayStatus']),
      statusCachedAt: serializer.fromJson<DateTime>(json['statusCachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'couponRuleId': serializer.toJson<String>(couponRuleId),
      'displayStatus': serializer.toJson<String>(displayStatus),
      'statusCachedAt': serializer.toJson<DateTime>(statusCachedAt),
    };
  }

  CouponRuleStatusEntity copyWith({
    String? couponRuleId,
    String? displayStatus,
    DateTime? statusCachedAt,
  }) => CouponRuleStatusEntity(
    couponRuleId: couponRuleId ?? this.couponRuleId,
    displayStatus: displayStatus ?? this.displayStatus,
    statusCachedAt: statusCachedAt ?? this.statusCachedAt,
  );
  CouponRuleStatusEntity copyWithCompanion(CouponRuleStatusesCompanion data) {
    return CouponRuleStatusEntity(
      couponRuleId: data.couponRuleId.present
          ? data.couponRuleId.value
          : this.couponRuleId,
      displayStatus: data.displayStatus.present
          ? data.displayStatus.value
          : this.displayStatus,
      statusCachedAt: data.statusCachedAt.present
          ? data.statusCachedAt.value
          : this.statusCachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CouponRuleStatusEntity(')
          ..write('couponRuleId: $couponRuleId, ')
          ..write('displayStatus: $displayStatus, ')
          ..write('statusCachedAt: $statusCachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(couponRuleId, displayStatus, statusCachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CouponRuleStatusEntity &&
          other.couponRuleId == this.couponRuleId &&
          other.displayStatus == this.displayStatus &&
          other.statusCachedAt == this.statusCachedAt);
}

class CouponRuleStatusesCompanion
    extends UpdateCompanion<CouponRuleStatusEntity> {
  final Value<String> couponRuleId;
  final Value<String> displayStatus;
  final Value<DateTime> statusCachedAt;
  final Value<int> rowid;
  const CouponRuleStatusesCompanion({
    this.couponRuleId = const Value.absent(),
    this.displayStatus = const Value.absent(),
    this.statusCachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CouponRuleStatusesCompanion.insert({
    required String couponRuleId,
    required String displayStatus,
    required DateTime statusCachedAt,
    this.rowid = const Value.absent(),
  }) : couponRuleId = Value(couponRuleId),
       displayStatus = Value(displayStatus),
       statusCachedAt = Value(statusCachedAt);
  static Insertable<CouponRuleStatusEntity> custom({
    Expression<String>? couponRuleId,
    Expression<String>? displayStatus,
    Expression<DateTime>? statusCachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (couponRuleId != null) 'coupon_rule_id': couponRuleId,
      if (displayStatus != null) 'display_status': displayStatus,
      if (statusCachedAt != null) 'status_cached_at': statusCachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CouponRuleStatusesCompanion copyWith({
    Value<String>? couponRuleId,
    Value<String>? displayStatus,
    Value<DateTime>? statusCachedAt,
    Value<int>? rowid,
  }) {
    return CouponRuleStatusesCompanion(
      couponRuleId: couponRuleId ?? this.couponRuleId,
      displayStatus: displayStatus ?? this.displayStatus,
      statusCachedAt: statusCachedAt ?? this.statusCachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (couponRuleId.present) {
      map['coupon_rule_id'] = Variable<String>(couponRuleId.value);
    }
    if (displayStatus.present) {
      map['display_status'] = Variable<String>(displayStatus.value);
    }
    if (statusCachedAt.present) {
      map['status_cached_at'] = Variable<DateTime>(statusCachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CouponRuleStatusesCompanion(')
          ..write('couponRuleId: $couponRuleId, ')
          ..write('displayStatus: $displayStatus, ')
          ..write('statusCachedAt: $statusCachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarouselsTable extends Carousels
    with TableInfo<$CarouselsTable, Carousel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarouselsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placementKeyMeta = const VerificationMeta(
    'placementKey',
  );
  @override
  late final GeneratedColumn<String> placementKey = GeneratedColumn<String>(
    'placement_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promotionCodeMeta = const VerificationMeta(
    'promotionCode',
  );
  @override
  late final GeneratedColumn<String> promotionCode = GeneratedColumn<String>(
    'promotion_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaUrlMeta = const VerificationMeta(
    'mediaUrl',
  );
  @override
  late final GeneratedColumn<String> mediaUrl = GeneratedColumn<String>(
    'media_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fallbackUrlMeta = const VerificationMeta(
    'fallbackUrl',
  );
  @override
  late final GeneratedColumn<String> fallbackUrl = GeneratedColumn<String>(
    'fallback_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionLinkMeta = const VerificationMeta(
    'actionLink',
  );
  @override
  late final GeneratedColumn<String> actionLink = GeneratedColumn<String>(
    'action_link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiredAtMeta = const VerificationMeta(
    'expiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiredAt = GeneratedColumn<DateTime>(
    'expired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    placementKey,
    title,
    promotionCode,
    mediaType,
    mediaUrl,
    fallbackUrl,
    actionType,
    actionLink,
    sortOrder,
    publishedAt,
    expiredAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'carousels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Carousel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('placement_key')) {
      context.handle(
        _placementKeyMeta,
        placementKey.isAcceptableOrUnknown(
          data['placement_key']!,
          _placementKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_placementKeyMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('promotion_code')) {
      context.handle(
        _promotionCodeMeta,
        promotionCode.isAcceptableOrUnknown(
          data['promotion_code']!,
          _promotionCodeMeta,
        ),
      );
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('media_url')) {
      context.handle(
        _mediaUrlMeta,
        mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaUrlMeta);
    }
    if (data.containsKey('fallback_url')) {
      context.handle(
        _fallbackUrlMeta,
        fallbackUrl.isAcceptableOrUnknown(
          data['fallback_url']!,
          _fallbackUrlMeta,
        ),
      );
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('action_link')) {
      context.handle(
        _actionLinkMeta,
        actionLink.isAcceptableOrUnknown(data['action_link']!, _actionLinkMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    if (data.containsKey('expired_at')) {
      context.handle(
        _expiredAtMeta,
        expiredAt.isAcceptableOrUnknown(data['expired_at']!, _expiredAtMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Carousel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Carousel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      placementKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placement_key'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      promotionCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}promotion_code'],
      ),
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      mediaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_url'],
      )!,
      fallbackUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fallback_url'],
      ),
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      actionLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_link'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      )!,
      expiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expired_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CarouselsTable createAlias(String alias) {
    return $CarouselsTable(attachedDatabase, alias);
  }
}

class Carousel extends DataClass implements Insertable<Carousel> {
  /// Unique identifier for the carousel item
  final String id;

  /// Placement key indicating where the carousel should appear (e.g., HOME_MAIN_CAROUSEL, HOME_POPUP_MODAL)
  final String placementKey;

  /// Title of the carousel item for identification
  final String title;

  /// Promotion code for analytics tracking
  final String? promotionCode;

  /// Media type (STATIC_IMAGE, LOOPING_ANIMATION, LOTTIE, VIDEO)
  final String mediaType;

  /// URL to the media file
  final String mediaUrl;

  /// Fallback URL for when primary media fails to load
  final String? fallbackUrl;

  /// Action type when user taps (APP_PAGE, EXTERNAL_URL, DEEPLINK, NONE)
  final String actionType;

  /// Target link for the action
  final String? actionLink;

  /// Sort order for display
  final int sortOrder;

  /// When the carousel should start displaying
  final DateTime publishedAt;

  /// When the carousel should stop displaying (null = no expiration)
  final DateTime? expiredAt;

  /// Timestamp when this data was last cached from S3
  final DateTime cachedAt;
  const Carousel({
    required this.id,
    required this.placementKey,
    required this.title,
    this.promotionCode,
    required this.mediaType,
    required this.mediaUrl,
    this.fallbackUrl,
    required this.actionType,
    this.actionLink,
    required this.sortOrder,
    required this.publishedAt,
    this.expiredAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['placement_key'] = Variable<String>(placementKey);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || promotionCode != null) {
      map['promotion_code'] = Variable<String>(promotionCode);
    }
    map['media_type'] = Variable<String>(mediaType);
    map['media_url'] = Variable<String>(mediaUrl);
    if (!nullToAbsent || fallbackUrl != null) {
      map['fallback_url'] = Variable<String>(fallbackUrl);
    }
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || actionLink != null) {
      map['action_link'] = Variable<String>(actionLink);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['published_at'] = Variable<DateTime>(publishedAt);
    if (!nullToAbsent || expiredAt != null) {
      map['expired_at'] = Variable<DateTime>(expiredAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CarouselsCompanion toCompanion(bool nullToAbsent) {
    return CarouselsCompanion(
      id: Value(id),
      placementKey: Value(placementKey),
      title: Value(title),
      promotionCode: promotionCode == null && nullToAbsent
          ? const Value.absent()
          : Value(promotionCode),
      mediaType: Value(mediaType),
      mediaUrl: Value(mediaUrl),
      fallbackUrl: fallbackUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fallbackUrl),
      actionType: Value(actionType),
      actionLink: actionLink == null && nullToAbsent
          ? const Value.absent()
          : Value(actionLink),
      sortOrder: Value(sortOrder),
      publishedAt: Value(publishedAt),
      expiredAt: expiredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiredAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory Carousel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Carousel(
      id: serializer.fromJson<String>(json['id']),
      placementKey: serializer.fromJson<String>(json['placementKey']),
      title: serializer.fromJson<String>(json['title']),
      promotionCode: serializer.fromJson<String?>(json['promotionCode']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      mediaUrl: serializer.fromJson<String>(json['mediaUrl']),
      fallbackUrl: serializer.fromJson<String?>(json['fallbackUrl']),
      actionType: serializer.fromJson<String>(json['actionType']),
      actionLink: serializer.fromJson<String?>(json['actionLink']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
      expiredAt: serializer.fromJson<DateTime?>(json['expiredAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'placementKey': serializer.toJson<String>(placementKey),
      'title': serializer.toJson<String>(title),
      'promotionCode': serializer.toJson<String?>(promotionCode),
      'mediaType': serializer.toJson<String>(mediaType),
      'mediaUrl': serializer.toJson<String>(mediaUrl),
      'fallbackUrl': serializer.toJson<String?>(fallbackUrl),
      'actionType': serializer.toJson<String>(actionType),
      'actionLink': serializer.toJson<String?>(actionLink),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
      'expiredAt': serializer.toJson<DateTime?>(expiredAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  Carousel copyWith({
    String? id,
    String? placementKey,
    String? title,
    Value<String?> promotionCode = const Value.absent(),
    String? mediaType,
    String? mediaUrl,
    Value<String?> fallbackUrl = const Value.absent(),
    String? actionType,
    Value<String?> actionLink = const Value.absent(),
    int? sortOrder,
    DateTime? publishedAt,
    Value<DateTime?> expiredAt = const Value.absent(),
    DateTime? cachedAt,
  }) => Carousel(
    id: id ?? this.id,
    placementKey: placementKey ?? this.placementKey,
    title: title ?? this.title,
    promotionCode: promotionCode.present
        ? promotionCode.value
        : this.promotionCode,
    mediaType: mediaType ?? this.mediaType,
    mediaUrl: mediaUrl ?? this.mediaUrl,
    fallbackUrl: fallbackUrl.present ? fallbackUrl.value : this.fallbackUrl,
    actionType: actionType ?? this.actionType,
    actionLink: actionLink.present ? actionLink.value : this.actionLink,
    sortOrder: sortOrder ?? this.sortOrder,
    publishedAt: publishedAt ?? this.publishedAt,
    expiredAt: expiredAt.present ? expiredAt.value : this.expiredAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  Carousel copyWithCompanion(CarouselsCompanion data) {
    return Carousel(
      id: data.id.present ? data.id.value : this.id,
      placementKey: data.placementKey.present
          ? data.placementKey.value
          : this.placementKey,
      title: data.title.present ? data.title.value : this.title,
      promotionCode: data.promotionCode.present
          ? data.promotionCode.value
          : this.promotionCode,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      fallbackUrl: data.fallbackUrl.present
          ? data.fallbackUrl.value
          : this.fallbackUrl,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      actionLink: data.actionLink.present
          ? data.actionLink.value
          : this.actionLink,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      expiredAt: data.expiredAt.present ? data.expiredAt.value : this.expiredAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Carousel(')
          ..write('id: $id, ')
          ..write('placementKey: $placementKey, ')
          ..write('title: $title, ')
          ..write('promotionCode: $promotionCode, ')
          ..write('mediaType: $mediaType, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('fallbackUrl: $fallbackUrl, ')
          ..write('actionType: $actionType, ')
          ..write('actionLink: $actionLink, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('expiredAt: $expiredAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    placementKey,
    title,
    promotionCode,
    mediaType,
    mediaUrl,
    fallbackUrl,
    actionType,
    actionLink,
    sortOrder,
    publishedAt,
    expiredAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Carousel &&
          other.id == this.id &&
          other.placementKey == this.placementKey &&
          other.title == this.title &&
          other.promotionCode == this.promotionCode &&
          other.mediaType == this.mediaType &&
          other.mediaUrl == this.mediaUrl &&
          other.fallbackUrl == this.fallbackUrl &&
          other.actionType == this.actionType &&
          other.actionLink == this.actionLink &&
          other.sortOrder == this.sortOrder &&
          other.publishedAt == this.publishedAt &&
          other.expiredAt == this.expiredAt &&
          other.cachedAt == this.cachedAt);
}

class CarouselsCompanion extends UpdateCompanion<Carousel> {
  final Value<String> id;
  final Value<String> placementKey;
  final Value<String> title;
  final Value<String?> promotionCode;
  final Value<String> mediaType;
  final Value<String> mediaUrl;
  final Value<String?> fallbackUrl;
  final Value<String> actionType;
  final Value<String?> actionLink;
  final Value<int> sortOrder;
  final Value<DateTime> publishedAt;
  final Value<DateTime?> expiredAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CarouselsCompanion({
    this.id = const Value.absent(),
    this.placementKey = const Value.absent(),
    this.title = const Value.absent(),
    this.promotionCode = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.fallbackUrl = const Value.absent(),
    this.actionType = const Value.absent(),
    this.actionLink = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.expiredAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarouselsCompanion.insert({
    required String id,
    required String placementKey,
    required String title,
    this.promotionCode = const Value.absent(),
    required String mediaType,
    required String mediaUrl,
    this.fallbackUrl = const Value.absent(),
    required String actionType,
    this.actionLink = const Value.absent(),
    required int sortOrder,
    required DateTime publishedAt,
    this.expiredAt = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       placementKey = Value(placementKey),
       title = Value(title),
       mediaType = Value(mediaType),
       mediaUrl = Value(mediaUrl),
       actionType = Value(actionType),
       sortOrder = Value(sortOrder),
       publishedAt = Value(publishedAt),
       cachedAt = Value(cachedAt);
  static Insertable<Carousel> custom({
    Expression<String>? id,
    Expression<String>? placementKey,
    Expression<String>? title,
    Expression<String>? promotionCode,
    Expression<String>? mediaType,
    Expression<String>? mediaUrl,
    Expression<String>? fallbackUrl,
    Expression<String>? actionType,
    Expression<String>? actionLink,
    Expression<int>? sortOrder,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? expiredAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placementKey != null) 'placement_key': placementKey,
      if (title != null) 'title': title,
      if (promotionCode != null) 'promotion_code': promotionCode,
      if (mediaType != null) 'media_type': mediaType,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (fallbackUrl != null) 'fallback_url': fallbackUrl,
      if (actionType != null) 'action_type': actionType,
      if (actionLink != null) 'action_link': actionLink,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (publishedAt != null) 'published_at': publishedAt,
      if (expiredAt != null) 'expired_at': expiredAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarouselsCompanion copyWith({
    Value<String>? id,
    Value<String>? placementKey,
    Value<String>? title,
    Value<String?>? promotionCode,
    Value<String>? mediaType,
    Value<String>? mediaUrl,
    Value<String?>? fallbackUrl,
    Value<String>? actionType,
    Value<String?>? actionLink,
    Value<int>? sortOrder,
    Value<DateTime>? publishedAt,
    Value<DateTime?>? expiredAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CarouselsCompanion(
      id: id ?? this.id,
      placementKey: placementKey ?? this.placementKey,
      title: title ?? this.title,
      promotionCode: promotionCode ?? this.promotionCode,
      mediaType: mediaType ?? this.mediaType,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      fallbackUrl: fallbackUrl ?? this.fallbackUrl,
      actionType: actionType ?? this.actionType,
      actionLink: actionLink ?? this.actionLink,
      sortOrder: sortOrder ?? this.sortOrder,
      publishedAt: publishedAt ?? this.publishedAt,
      expiredAt: expiredAt ?? this.expiredAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (placementKey.present) {
      map['placement_key'] = Variable<String>(placementKey.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (promotionCode.present) {
      map['promotion_code'] = Variable<String>(promotionCode.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (fallbackUrl.present) {
      map['fallback_url'] = Variable<String>(fallbackUrl.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (actionLink.present) {
      map['action_link'] = Variable<String>(actionLink.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (expiredAt.present) {
      map['expired_at'] = Variable<DateTime>(expiredAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarouselsCompanion(')
          ..write('id: $id, ')
          ..write('placementKey: $placementKey, ')
          ..write('title: $title, ')
          ..write('promotionCode: $promotionCode, ')
          ..write('mediaType: $mediaType, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('fallbackUrl: $fallbackUrl, ')
          ..write('actionType: $actionType, ')
          ..write('actionLink: $actionLink, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('expiredAt: $expiredAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MemberCouponsTable extends MemberCoupons
    with TableInfo<$MemberCouponsTable, MemberCouponEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberCouponsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _couponRuleIdMeta = const VerificationMeta(
    'couponRuleId',
  );
  @override
  late final GeneratedColumn<String> couponRuleId = GeneratedColumn<String>(
    'coupon_rule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStatusMeta = const VerificationMeta(
    'currentStatus',
  );
  @override
  late final GeneratedColumn<String> currentStatus = GeneratedColumn<String>(
    'current_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issuedAtMeta = const VerificationMeta(
    'issuedAt',
  );
  @override
  late final GeneratedColumn<DateTime> issuedAt = GeneratedColumn<DateTime>(
    'issued_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _useStartAtMeta = const VerificationMeta(
    'useStartAt',
  );
  @override
  late final GeneratedColumn<DateTime> useStartAt = GeneratedColumn<DateTime>(
    'use_start_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiredAtMeta = const VerificationMeta(
    'expiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiredAt = GeneratedColumn<DateTime>(
    'expired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usedAtMeta = const VerificationMeta('usedAt');
  @override
  late final GeneratedColumn<DateTime> usedAt = GeneratedColumn<DateTime>(
    'used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canceledAtMeta = const VerificationMeta(
    'canceledAt',
  );
  @override
  late final GeneratedColumn<DateTime> canceledAt = GeneratedColumn<DateTime>(
    'canceled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _revokedAtMeta = const VerificationMeta(
    'revokedAt',
  );
  @override
  late final GeneratedColumn<DateTime> revokedAt = GeneratedColumn<DateTime>(
    'revoked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedAtMeta = const VerificationMeta(
    'lastUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>(
        'last_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<
    List<RedemptionCredentialModel>,
    String
  >
  redemptionCredentials =
      GeneratedColumn<String>(
        'redemption_credentials',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<RedemptionCredentialModel>>(
        $MemberCouponsTable.$converterredemptionCredentials,
      );
  static const VerificationMeta _exchangeUnitsMeta = const VerificationMeta(
    'exchangeUnits',
  );
  @override
  late final GeneratedColumn<int> exchangeUnits = GeneratedColumn<int>(
    'exchange_units',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    couponRuleId,
    currentStatus,
    issuedAt,
    useStartAt,
    expiredAt,
    usedAt,
    canceledAt,
    revokedAt,
    lastUpdatedAt,
    redemptionCredentials,
    exchangeUnits,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_coupons';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberCouponEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('coupon_rule_id')) {
      context.handle(
        _couponRuleIdMeta,
        couponRuleId.isAcceptableOrUnknown(
          data['coupon_rule_id']!,
          _couponRuleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_couponRuleIdMeta);
    }
    if (data.containsKey('current_status')) {
      context.handle(
        _currentStatusMeta,
        currentStatus.isAcceptableOrUnknown(
          data['current_status']!,
          _currentStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentStatusMeta);
    }
    if (data.containsKey('issued_at')) {
      context.handle(
        _issuedAtMeta,
        issuedAt.isAcceptableOrUnknown(data['issued_at']!, _issuedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_issuedAtMeta);
    }
    if (data.containsKey('use_start_at')) {
      context.handle(
        _useStartAtMeta,
        useStartAt.isAcceptableOrUnknown(
          data['use_start_at']!,
          _useStartAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_useStartAtMeta);
    }
    if (data.containsKey('expired_at')) {
      context.handle(
        _expiredAtMeta,
        expiredAt.isAcceptableOrUnknown(data['expired_at']!, _expiredAtMeta),
      );
    }
    if (data.containsKey('used_at')) {
      context.handle(
        _usedAtMeta,
        usedAt.isAcceptableOrUnknown(data['used_at']!, _usedAtMeta),
      );
    }
    if (data.containsKey('canceled_at')) {
      context.handle(
        _canceledAtMeta,
        canceledAt.isAcceptableOrUnknown(data['canceled_at']!, _canceledAtMeta),
      );
    }
    if (data.containsKey('revoked_at')) {
      context.handle(
        _revokedAtMeta,
        revokedAt.isAcceptableOrUnknown(data['revoked_at']!, _revokedAtMeta),
      );
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
        _lastUpdatedAtMeta,
        lastUpdatedAt.isAcceptableOrUnknown(
          data['last_updated_at']!,
          _lastUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
    }
    if (data.containsKey('exchange_units')) {
      context.handle(
        _exchangeUnitsMeta,
        exchangeUnits.isAcceptableOrUnknown(
          data['exchange_units']!,
          _exchangeUnitsMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberCouponEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberCouponEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      couponRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coupon_rule_id'],
      )!,
      currentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_status'],
      )!,
      issuedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issued_at'],
      )!,
      useStartAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}use_start_at'],
      )!,
      expiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expired_at'],
      ),
      usedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}used_at'],
      ),
      canceledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}canceled_at'],
      ),
      revokedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}revoked_at'],
      ),
      lastUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated_at'],
      )!,
      redemptionCredentials: $MemberCouponsTable.$converterredemptionCredentials
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}redemption_credentials'],
            )!,
          ),
      exchangeUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exchange_units'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $MemberCouponsTable createAlias(String alias) {
    return $MemberCouponsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<RedemptionCredentialModel>, String>
  $converterredemptionCredentials = const RedemptionCredentialsConverter();
}

class MemberCouponEntity extends DataClass
    implements Insertable<MemberCouponEntity> {
  final String id;
  final String couponRuleId;
  final String currentStatus;
  final DateTime issuedAt;
  final DateTime useStartAt;
  final DateTime? expiredAt;
  final DateTime? usedAt;
  final DateTime? canceledAt;
  final DateTime? revokedAt;
  final DateTime lastUpdatedAt;
  final List<RedemptionCredentialModel> redemptionCredentials;
  final int? exchangeUnits;
  final DateTime cachedAt;
  const MemberCouponEntity({
    required this.id,
    required this.couponRuleId,
    required this.currentStatus,
    required this.issuedAt,
    required this.useStartAt,
    this.expiredAt,
    this.usedAt,
    this.canceledAt,
    this.revokedAt,
    required this.lastUpdatedAt,
    required this.redemptionCredentials,
    this.exchangeUnits,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['coupon_rule_id'] = Variable<String>(couponRuleId);
    map['current_status'] = Variable<String>(currentStatus);
    map['issued_at'] = Variable<DateTime>(issuedAt);
    map['use_start_at'] = Variable<DateTime>(useStartAt);
    if (!nullToAbsent || expiredAt != null) {
      map['expired_at'] = Variable<DateTime>(expiredAt);
    }
    if (!nullToAbsent || usedAt != null) {
      map['used_at'] = Variable<DateTime>(usedAt);
    }
    if (!nullToAbsent || canceledAt != null) {
      map['canceled_at'] = Variable<DateTime>(canceledAt);
    }
    if (!nullToAbsent || revokedAt != null) {
      map['revoked_at'] = Variable<DateTime>(revokedAt);
    }
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    {
      map['redemption_credentials'] = Variable<String>(
        $MemberCouponsTable.$converterredemptionCredentials.toSql(
          redemptionCredentials,
        ),
      );
    }
    if (!nullToAbsent || exchangeUnits != null) {
      map['exchange_units'] = Variable<int>(exchangeUnits);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  MemberCouponsCompanion toCompanion(bool nullToAbsent) {
    return MemberCouponsCompanion(
      id: Value(id),
      couponRuleId: Value(couponRuleId),
      currentStatus: Value(currentStatus),
      issuedAt: Value(issuedAt),
      useStartAt: Value(useStartAt),
      expiredAt: expiredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiredAt),
      usedAt: usedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(usedAt),
      canceledAt: canceledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(canceledAt),
      revokedAt: revokedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(revokedAt),
      lastUpdatedAt: Value(lastUpdatedAt),
      redemptionCredentials: Value(redemptionCredentials),
      exchangeUnits: exchangeUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeUnits),
      cachedAt: Value(cachedAt),
    );
  }

  factory MemberCouponEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberCouponEntity(
      id: serializer.fromJson<String>(json['id']),
      couponRuleId: serializer.fromJson<String>(json['couponRuleId']),
      currentStatus: serializer.fromJson<String>(json['currentStatus']),
      issuedAt: serializer.fromJson<DateTime>(json['issuedAt']),
      useStartAt: serializer.fromJson<DateTime>(json['useStartAt']),
      expiredAt: serializer.fromJson<DateTime?>(json['expiredAt']),
      usedAt: serializer.fromJson<DateTime?>(json['usedAt']),
      canceledAt: serializer.fromJson<DateTime?>(json['canceledAt']),
      revokedAt: serializer.fromJson<DateTime?>(json['revokedAt']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
      redemptionCredentials: serializer
          .fromJson<List<RedemptionCredentialModel>>(
            json['redemptionCredentials'],
          ),
      exchangeUnits: serializer.fromJson<int?>(json['exchangeUnits']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'couponRuleId': serializer.toJson<String>(couponRuleId),
      'currentStatus': serializer.toJson<String>(currentStatus),
      'issuedAt': serializer.toJson<DateTime>(issuedAt),
      'useStartAt': serializer.toJson<DateTime>(useStartAt),
      'expiredAt': serializer.toJson<DateTime?>(expiredAt),
      'usedAt': serializer.toJson<DateTime?>(usedAt),
      'canceledAt': serializer.toJson<DateTime?>(canceledAt),
      'revokedAt': serializer.toJson<DateTime?>(revokedAt),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
      'redemptionCredentials': serializer
          .toJson<List<RedemptionCredentialModel>>(redemptionCredentials),
      'exchangeUnits': serializer.toJson<int?>(exchangeUnits),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  MemberCouponEntity copyWith({
    String? id,
    String? couponRuleId,
    String? currentStatus,
    DateTime? issuedAt,
    DateTime? useStartAt,
    Value<DateTime?> expiredAt = const Value.absent(),
    Value<DateTime?> usedAt = const Value.absent(),
    Value<DateTime?> canceledAt = const Value.absent(),
    Value<DateTime?> revokedAt = const Value.absent(),
    DateTime? lastUpdatedAt,
    List<RedemptionCredentialModel>? redemptionCredentials,
    Value<int?> exchangeUnits = const Value.absent(),
    DateTime? cachedAt,
  }) => MemberCouponEntity(
    id: id ?? this.id,
    couponRuleId: couponRuleId ?? this.couponRuleId,
    currentStatus: currentStatus ?? this.currentStatus,
    issuedAt: issuedAt ?? this.issuedAt,
    useStartAt: useStartAt ?? this.useStartAt,
    expiredAt: expiredAt.present ? expiredAt.value : this.expiredAt,
    usedAt: usedAt.present ? usedAt.value : this.usedAt,
    canceledAt: canceledAt.present ? canceledAt.value : this.canceledAt,
    revokedAt: revokedAt.present ? revokedAt.value : this.revokedAt,
    lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    redemptionCredentials: redemptionCredentials ?? this.redemptionCredentials,
    exchangeUnits: exchangeUnits.present
        ? exchangeUnits.value
        : this.exchangeUnits,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  MemberCouponEntity copyWithCompanion(MemberCouponsCompanion data) {
    return MemberCouponEntity(
      id: data.id.present ? data.id.value : this.id,
      couponRuleId: data.couponRuleId.present
          ? data.couponRuleId.value
          : this.couponRuleId,
      currentStatus: data.currentStatus.present
          ? data.currentStatus.value
          : this.currentStatus,
      issuedAt: data.issuedAt.present ? data.issuedAt.value : this.issuedAt,
      useStartAt: data.useStartAt.present
          ? data.useStartAt.value
          : this.useStartAt,
      expiredAt: data.expiredAt.present ? data.expiredAt.value : this.expiredAt,
      usedAt: data.usedAt.present ? data.usedAt.value : this.usedAt,
      canceledAt: data.canceledAt.present
          ? data.canceledAt.value
          : this.canceledAt,
      revokedAt: data.revokedAt.present ? data.revokedAt.value : this.revokedAt,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
      redemptionCredentials: data.redemptionCredentials.present
          ? data.redemptionCredentials.value
          : this.redemptionCredentials,
      exchangeUnits: data.exchangeUnits.present
          ? data.exchangeUnits.value
          : this.exchangeUnits,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberCouponEntity(')
          ..write('id: $id, ')
          ..write('couponRuleId: $couponRuleId, ')
          ..write('currentStatus: $currentStatus, ')
          ..write('issuedAt: $issuedAt, ')
          ..write('useStartAt: $useStartAt, ')
          ..write('expiredAt: $expiredAt, ')
          ..write('usedAt: $usedAt, ')
          ..write('canceledAt: $canceledAt, ')
          ..write('revokedAt: $revokedAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('redemptionCredentials: $redemptionCredentials, ')
          ..write('exchangeUnits: $exchangeUnits, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    couponRuleId,
    currentStatus,
    issuedAt,
    useStartAt,
    expiredAt,
    usedAt,
    canceledAt,
    revokedAt,
    lastUpdatedAt,
    redemptionCredentials,
    exchangeUnits,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberCouponEntity &&
          other.id == this.id &&
          other.couponRuleId == this.couponRuleId &&
          other.currentStatus == this.currentStatus &&
          other.issuedAt == this.issuedAt &&
          other.useStartAt == this.useStartAt &&
          other.expiredAt == this.expiredAt &&
          other.usedAt == this.usedAt &&
          other.canceledAt == this.canceledAt &&
          other.revokedAt == this.revokedAt &&
          other.lastUpdatedAt == this.lastUpdatedAt &&
          other.redemptionCredentials == this.redemptionCredentials &&
          other.exchangeUnits == this.exchangeUnits &&
          other.cachedAt == this.cachedAt);
}

class MemberCouponsCompanion extends UpdateCompanion<MemberCouponEntity> {
  final Value<String> id;
  final Value<String> couponRuleId;
  final Value<String> currentStatus;
  final Value<DateTime> issuedAt;
  final Value<DateTime> useStartAt;
  final Value<DateTime?> expiredAt;
  final Value<DateTime?> usedAt;
  final Value<DateTime?> canceledAt;
  final Value<DateTime?> revokedAt;
  final Value<DateTime> lastUpdatedAt;
  final Value<List<RedemptionCredentialModel>> redemptionCredentials;
  final Value<int?> exchangeUnits;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const MemberCouponsCompanion({
    this.id = const Value.absent(),
    this.couponRuleId = const Value.absent(),
    this.currentStatus = const Value.absent(),
    this.issuedAt = const Value.absent(),
    this.useStartAt = const Value.absent(),
    this.expiredAt = const Value.absent(),
    this.usedAt = const Value.absent(),
    this.canceledAt = const Value.absent(),
    this.revokedAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.redemptionCredentials = const Value.absent(),
    this.exchangeUnits = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberCouponsCompanion.insert({
    required String id,
    required String couponRuleId,
    required String currentStatus,
    required DateTime issuedAt,
    required DateTime useStartAt,
    this.expiredAt = const Value.absent(),
    this.usedAt = const Value.absent(),
    this.canceledAt = const Value.absent(),
    this.revokedAt = const Value.absent(),
    required DateTime lastUpdatedAt,
    required List<RedemptionCredentialModel> redemptionCredentials,
    this.exchangeUnits = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       couponRuleId = Value(couponRuleId),
       currentStatus = Value(currentStatus),
       issuedAt = Value(issuedAt),
       useStartAt = Value(useStartAt),
       lastUpdatedAt = Value(lastUpdatedAt),
       redemptionCredentials = Value(redemptionCredentials);
  static Insertable<MemberCouponEntity> custom({
    Expression<String>? id,
    Expression<String>? couponRuleId,
    Expression<String>? currentStatus,
    Expression<DateTime>? issuedAt,
    Expression<DateTime>? useStartAt,
    Expression<DateTime>? expiredAt,
    Expression<DateTime>? usedAt,
    Expression<DateTime>? canceledAt,
    Expression<DateTime>? revokedAt,
    Expression<DateTime>? lastUpdatedAt,
    Expression<String>? redemptionCredentials,
    Expression<int>? exchangeUnits,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (couponRuleId != null) 'coupon_rule_id': couponRuleId,
      if (currentStatus != null) 'current_status': currentStatus,
      if (issuedAt != null) 'issued_at': issuedAt,
      if (useStartAt != null) 'use_start_at': useStartAt,
      if (expiredAt != null) 'expired_at': expiredAt,
      if (usedAt != null) 'used_at': usedAt,
      if (canceledAt != null) 'canceled_at': canceledAt,
      if (revokedAt != null) 'revoked_at': revokedAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (redemptionCredentials != null)
        'redemption_credentials': redemptionCredentials,
      if (exchangeUnits != null) 'exchange_units': exchangeUnits,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberCouponsCompanion copyWith({
    Value<String>? id,
    Value<String>? couponRuleId,
    Value<String>? currentStatus,
    Value<DateTime>? issuedAt,
    Value<DateTime>? useStartAt,
    Value<DateTime?>? expiredAt,
    Value<DateTime?>? usedAt,
    Value<DateTime?>? canceledAt,
    Value<DateTime?>? revokedAt,
    Value<DateTime>? lastUpdatedAt,
    Value<List<RedemptionCredentialModel>>? redemptionCredentials,
    Value<int?>? exchangeUnits,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return MemberCouponsCompanion(
      id: id ?? this.id,
      couponRuleId: couponRuleId ?? this.couponRuleId,
      currentStatus: currentStatus ?? this.currentStatus,
      issuedAt: issuedAt ?? this.issuedAt,
      useStartAt: useStartAt ?? this.useStartAt,
      expiredAt: expiredAt ?? this.expiredAt,
      usedAt: usedAt ?? this.usedAt,
      canceledAt: canceledAt ?? this.canceledAt,
      revokedAt: revokedAt ?? this.revokedAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      redemptionCredentials:
          redemptionCredentials ?? this.redemptionCredentials,
      exchangeUnits: exchangeUnits ?? this.exchangeUnits,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (couponRuleId.present) {
      map['coupon_rule_id'] = Variable<String>(couponRuleId.value);
    }
    if (currentStatus.present) {
      map['current_status'] = Variable<String>(currentStatus.value);
    }
    if (issuedAt.present) {
      map['issued_at'] = Variable<DateTime>(issuedAt.value);
    }
    if (useStartAt.present) {
      map['use_start_at'] = Variable<DateTime>(useStartAt.value);
    }
    if (expiredAt.present) {
      map['expired_at'] = Variable<DateTime>(expiredAt.value);
    }
    if (usedAt.present) {
      map['used_at'] = Variable<DateTime>(usedAt.value);
    }
    if (canceledAt.present) {
      map['canceled_at'] = Variable<DateTime>(canceledAt.value);
    }
    if (revokedAt.present) {
      map['revoked_at'] = Variable<DateTime>(revokedAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    if (redemptionCredentials.present) {
      map['redemption_credentials'] = Variable<String>(
        $MemberCouponsTable.$converterredemptionCredentials.toSql(
          redemptionCredentials.value,
        ),
      );
    }
    if (exchangeUnits.present) {
      map['exchange_units'] = Variable<int>(exchangeUnits.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberCouponsCompanion(')
          ..write('id: $id, ')
          ..write('couponRuleId: $couponRuleId, ')
          ..write('currentStatus: $currentStatus, ')
          ..write('issuedAt: $issuedAt, ')
          ..write('useStartAt: $useStartAt, ')
          ..write('expiredAt: $expiredAt, ')
          ..write('usedAt: $usedAt, ')
          ..write('canceledAt: $canceledAt, ')
          ..write('revokedAt: $revokedAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('redemptionCredentials: $redemptionCredentials, ')
          ..write('exchangeUnits: $exchangeUnits, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, Notification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationTypeMeta = const VerificationMeta(
    'notificationType',
  );
  @override
  late final GeneratedColumn<String> notificationType = GeneratedColumn<String>(
    'notification_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagTextMeta = const VerificationMeta(
    'tagText',
  );
  @override
  late final GeneratedColumn<String> tagText = GeneratedColumn<String>(
    'tag_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiredAtMeta = const VerificationMeta(
    'expiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiredAt = GeneratedColumn<DateTime>(
    'expired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionLinkMeta = const VerificationMeta(
    'actionLink',
  );
  @override
  late final GeneratedColumn<String> actionLink = GeneratedColumn<String>(
    'action_link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notificationType,
    title,
    tagText,
    summary,
    publishedAt,
    expiredAt,
    actionType,
    actionLink,
    isRead,
    readAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<Notification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('notification_type')) {
      context.handle(
        _notificationTypeMeta,
        notificationType.isAcceptableOrUnknown(
          data['notification_type']!,
          _notificationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationTypeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('tag_text')) {
      context.handle(
        _tagTextMeta,
        tagText.isAcceptableOrUnknown(data['tag_text']!, _tagTextMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    if (data.containsKey('expired_at')) {
      context.handle(
        _expiredAtMeta,
        expiredAt.isAcceptableOrUnknown(data['expired_at']!, _expiredAtMeta),
      );
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('action_link')) {
      context.handle(
        _actionLinkMeta,
        actionLink.isAcceptableOrUnknown(data['action_link']!, _actionLinkMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Notification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      notificationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      tagText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_text'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      )!,
      expiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expired_at'],
      ),
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      actionLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_link'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }
}

class Notification extends DataClass implements Insertable<Notification> {
  /// Unique identifier for the notification item
  final String id;

  /// Notification type: ANNOUNCEMENT or CAMPAIGN
  final String notificationType;

  /// Title of the notification
  final String title;

  /// Optional tag text (e.g., "重要")
  final String? tagText;

  /// Summary/description of the notification
  final String summary;

  /// When the notification should start displaying (ISO 8601 UTC)
  final DateTime publishedAt;

  /// When the notification should stop displaying (null = no expiration)
  final DateTime? expiredAt;

  /// Action type when user taps (LOAD_MARKDOWN, APP_PAGE, EXTERNAL_URL, DEEPLINK, NONE)
  final String actionType;

  /// Target link for the action (null if actionType = NONE)
  final String? actionLink;

  /// Whether the user has read this notification (local only)
  final bool isRead;

  /// When the user read this notification (local only)
  final DateTime? readAt;

  /// Timestamp when this data was last cached from S3
  final DateTime cachedAt;
  const Notification({
    required this.id,
    required this.notificationType,
    required this.title,
    this.tagText,
    required this.summary,
    required this.publishedAt,
    this.expiredAt,
    required this.actionType,
    this.actionLink,
    required this.isRead,
    this.readAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['notification_type'] = Variable<String>(notificationType);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || tagText != null) {
      map['tag_text'] = Variable<String>(tagText);
    }
    map['summary'] = Variable<String>(summary);
    map['published_at'] = Variable<DateTime>(publishedAt);
    if (!nullToAbsent || expiredAt != null) {
      map['expired_at'] = Variable<DateTime>(expiredAt);
    }
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || actionLink != null) {
      map['action_link'] = Variable<String>(actionLink);
    }
    map['is_read'] = Variable<bool>(isRead);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      notificationType: Value(notificationType),
      title: Value(title),
      tagText: tagText == null && nullToAbsent
          ? const Value.absent()
          : Value(tagText),
      summary: Value(summary),
      publishedAt: Value(publishedAt),
      expiredAt: expiredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiredAt),
      actionType: Value(actionType),
      actionLink: actionLink == null && nullToAbsent
          ? const Value.absent()
          : Value(actionLink),
      isRead: Value(isRead),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory Notification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notification(
      id: serializer.fromJson<String>(json['id']),
      notificationType: serializer.fromJson<String>(json['notificationType']),
      title: serializer.fromJson<String>(json['title']),
      tagText: serializer.fromJson<String?>(json['tagText']),
      summary: serializer.fromJson<String>(json['summary']),
      publishedAt: serializer.fromJson<DateTime>(json['publishedAt']),
      expiredAt: serializer.fromJson<DateTime?>(json['expiredAt']),
      actionType: serializer.fromJson<String>(json['actionType']),
      actionLink: serializer.fromJson<String?>(json['actionLink']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'notificationType': serializer.toJson<String>(notificationType),
      'title': serializer.toJson<String>(title),
      'tagText': serializer.toJson<String?>(tagText),
      'summary': serializer.toJson<String>(summary),
      'publishedAt': serializer.toJson<DateTime>(publishedAt),
      'expiredAt': serializer.toJson<DateTime?>(expiredAt),
      'actionType': serializer.toJson<String>(actionType),
      'actionLink': serializer.toJson<String?>(actionLink),
      'isRead': serializer.toJson<bool>(isRead),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  Notification copyWith({
    String? id,
    String? notificationType,
    String? title,
    Value<String?> tagText = const Value.absent(),
    String? summary,
    DateTime? publishedAt,
    Value<DateTime?> expiredAt = const Value.absent(),
    String? actionType,
    Value<String?> actionLink = const Value.absent(),
    bool? isRead,
    Value<DateTime?> readAt = const Value.absent(),
    DateTime? cachedAt,
  }) => Notification(
    id: id ?? this.id,
    notificationType: notificationType ?? this.notificationType,
    title: title ?? this.title,
    tagText: tagText.present ? tagText.value : this.tagText,
    summary: summary ?? this.summary,
    publishedAt: publishedAt ?? this.publishedAt,
    expiredAt: expiredAt.present ? expiredAt.value : this.expiredAt,
    actionType: actionType ?? this.actionType,
    actionLink: actionLink.present ? actionLink.value : this.actionLink,
    isRead: isRead ?? this.isRead,
    readAt: readAt.present ? readAt.value : this.readAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  Notification copyWithCompanion(NotificationsCompanion data) {
    return Notification(
      id: data.id.present ? data.id.value : this.id,
      notificationType: data.notificationType.present
          ? data.notificationType.value
          : this.notificationType,
      title: data.title.present ? data.title.value : this.title,
      tagText: data.tagText.present ? data.tagText.value : this.tagText,
      summary: data.summary.present ? data.summary.value : this.summary,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      expiredAt: data.expiredAt.present ? data.expiredAt.value : this.expiredAt,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      actionLink: data.actionLink.present
          ? data.actionLink.value
          : this.actionLink,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Notification(')
          ..write('id: $id, ')
          ..write('notificationType: $notificationType, ')
          ..write('title: $title, ')
          ..write('tagText: $tagText, ')
          ..write('summary: $summary, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('expiredAt: $expiredAt, ')
          ..write('actionType: $actionType, ')
          ..write('actionLink: $actionLink, ')
          ..write('isRead: $isRead, ')
          ..write('readAt: $readAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    notificationType,
    title,
    tagText,
    summary,
    publishedAt,
    expiredAt,
    actionType,
    actionLink,
    isRead,
    readAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notification &&
          other.id == this.id &&
          other.notificationType == this.notificationType &&
          other.title == this.title &&
          other.tagText == this.tagText &&
          other.summary == this.summary &&
          other.publishedAt == this.publishedAt &&
          other.expiredAt == this.expiredAt &&
          other.actionType == this.actionType &&
          other.actionLink == this.actionLink &&
          other.isRead == this.isRead &&
          other.readAt == this.readAt &&
          other.cachedAt == this.cachedAt);
}

class NotificationsCompanion extends UpdateCompanion<Notification> {
  final Value<String> id;
  final Value<String> notificationType;
  final Value<String> title;
  final Value<String?> tagText;
  final Value<String> summary;
  final Value<DateTime> publishedAt;
  final Value<DateTime?> expiredAt;
  final Value<String> actionType;
  final Value<String?> actionLink;
  final Value<bool> isRead;
  final Value<DateTime?> readAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.notificationType = const Value.absent(),
    this.title = const Value.absent(),
    this.tagText = const Value.absent(),
    this.summary = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.expiredAt = const Value.absent(),
    this.actionType = const Value.absent(),
    this.actionLink = const Value.absent(),
    this.isRead = const Value.absent(),
    this.readAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsCompanion.insert({
    required String id,
    required String notificationType,
    required String title,
    this.tagText = const Value.absent(),
    required String summary,
    required DateTime publishedAt,
    this.expiredAt = const Value.absent(),
    required String actionType,
    this.actionLink = const Value.absent(),
    this.isRead = const Value.absent(),
    this.readAt = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       notificationType = Value(notificationType),
       title = Value(title),
       summary = Value(summary),
       publishedAt = Value(publishedAt),
       actionType = Value(actionType),
       cachedAt = Value(cachedAt);
  static Insertable<Notification> custom({
    Expression<String>? id,
    Expression<String>? notificationType,
    Expression<String>? title,
    Expression<String>? tagText,
    Expression<String>? summary,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? expiredAt,
    Expression<String>? actionType,
    Expression<String>? actionLink,
    Expression<bool>? isRead,
    Expression<DateTime>? readAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notificationType != null) 'notification_type': notificationType,
      if (title != null) 'title': title,
      if (tagText != null) 'tag_text': tagText,
      if (summary != null) 'summary': summary,
      if (publishedAt != null) 'published_at': publishedAt,
      if (expiredAt != null) 'expired_at': expiredAt,
      if (actionType != null) 'action_type': actionType,
      if (actionLink != null) 'action_link': actionLink,
      if (isRead != null) 'is_read': isRead,
      if (readAt != null) 'read_at': readAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsCompanion copyWith({
    Value<String>? id,
    Value<String>? notificationType,
    Value<String>? title,
    Value<String?>? tagText,
    Value<String>? summary,
    Value<DateTime>? publishedAt,
    Value<DateTime?>? expiredAt,
    Value<String>? actionType,
    Value<String?>? actionLink,
    Value<bool>? isRead,
    Value<DateTime?>? readAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return NotificationsCompanion(
      id: id ?? this.id,
      notificationType: notificationType ?? this.notificationType,
      title: title ?? this.title,
      tagText: tagText ?? this.tagText,
      summary: summary ?? this.summary,
      publishedAt: publishedAt ?? this.publishedAt,
      expiredAt: expiredAt ?? this.expiredAt,
      actionType: actionType ?? this.actionType,
      actionLink: actionLink ?? this.actionLink,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (notificationType.present) {
      map['notification_type'] = Variable<String>(notificationType.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (tagText.present) {
      map['tag_text'] = Variable<String>(tagText.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (expiredAt.present) {
      map['expired_at'] = Variable<DateTime>(expiredAt.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (actionLink.present) {
      map['action_link'] = Variable<String>(actionLink.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('notificationType: $notificationType, ')
          ..write('title: $title, ')
          ..write('tagText: $tagText, ')
          ..write('summary: $summary, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('expiredAt: $expiredAt, ')
          ..write('actionType: $actionType, ')
          ..write('actionLink: $actionLink, ')
          ..write('isRead: $isRead, ')
          ..write('readAt: $readAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PointLogsTable pointLogs = $PointLogsTable(this);
  late final $SitesTable sites = $SitesTable(this);
  late final $SiteStatusesTable siteStatuses = $SiteStatusesTable(this);
  late final $BrandsTable brands = $BrandsTable(this);
  late final $CouponRulesTable couponRules = $CouponRulesTable(this);
  late final $CouponRuleStatusesTable couponRuleStatuses =
      $CouponRuleStatusesTable(this);
  late final $CarouselsTable carousels = $CarouselsTable(this);
  late final $MemberCouponsTable memberCoupons = $MemberCouponsTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pointLogs,
    sites,
    siteStatuses,
    brands,
    couponRules,
    couponRuleStatuses,
    carousels,
    memberCoupons,
    notifications,
  ];
}

typedef $$PointLogsTableCreateCompanionBuilder =
    PointLogsCompanion Function({
      required String logId,
      required LogType logType,
      required IconTypeCode iconTypeCode,
      required DetailType detailType,
      required String currencyCode,
      required String title,
      required int pointsChange,
      required DateTime occurredAt,
      required DateTime lastUpdatedAt,
      Value<Map<String, dynamic>?> detailsRaw,
      Value<int> rowid,
    });
typedef $$PointLogsTableUpdateCompanionBuilder =
    PointLogsCompanion Function({
      Value<String> logId,
      Value<LogType> logType,
      Value<IconTypeCode> iconTypeCode,
      Value<DetailType> detailType,
      Value<String> currencyCode,
      Value<String> title,
      Value<int> pointsChange,
      Value<DateTime> occurredAt,
      Value<DateTime> lastUpdatedAt,
      Value<Map<String, dynamic>?> detailsRaw,
      Value<int> rowid,
    });

class $$PointLogsTableFilterComposer
    extends Composer<_$AppDatabase, $PointLogsTable> {
  $$PointLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get logId => $composableBuilder(
    column: $table.logId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LogType, LogType, String> get logType =>
      $composableBuilder(
        column: $table.logType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<IconTypeCode, IconTypeCode, String>
  get iconTypeCode => $composableBuilder(
    column: $table.iconTypeCode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DetailType, DetailType, String>
  get detailType => $composableBuilder(
    column: $table.detailType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsChange => $composableBuilder(
    column: $table.pointsChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, dynamic>?,
    Map<String, dynamic>,
    String
  >
  get detailsRaw => $composableBuilder(
    column: $table.detailsRaw,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$PointLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $PointLogsTable> {
  $$PointLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get logId => $composableBuilder(
    column: $table.logId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logType => $composableBuilder(
    column: $table.logType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconTypeCode => $composableBuilder(
    column: $table.iconTypeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailType => $composableBuilder(
    column: $table.detailType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsChange => $composableBuilder(
    column: $table.pointsChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailsRaw => $composableBuilder(
    column: $table.detailsRaw,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PointLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PointLogsTable> {
  $$PointLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get logId =>
      $composableBuilder(column: $table.logId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LogType, String> get logType =>
      $composableBuilder(column: $table.logType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IconTypeCode, String> get iconTypeCode =>
      $composableBuilder(
        column: $table.iconTypeCode,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DetailType, String> get detailType =>
      $composableBuilder(
        column: $table.detailType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get pointsChange => $composableBuilder(
    column: $table.pointsChange,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
  get detailsRaw => $composableBuilder(
    column: $table.detailsRaw,
    builder: (column) => column,
  );
}

class $$PointLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PointLogsTable,
          PointLogEntity,
          $$PointLogsTableFilterComposer,
          $$PointLogsTableOrderingComposer,
          $$PointLogsTableAnnotationComposer,
          $$PointLogsTableCreateCompanionBuilder,
          $$PointLogsTableUpdateCompanionBuilder,
          (
            PointLogEntity,
            BaseReferences<_$AppDatabase, $PointLogsTable, PointLogEntity>,
          ),
          PointLogEntity,
          PrefetchHooks Function()
        > {
  $$PointLogsTableTableManager(_$AppDatabase db, $PointLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PointLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PointLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PointLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> logId = const Value.absent(),
                Value<LogType> logType = const Value.absent(),
                Value<IconTypeCode> iconTypeCode = const Value.absent(),
                Value<DetailType> detailType = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> pointsChange = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<DateTime> lastUpdatedAt = const Value.absent(),
                Value<Map<String, dynamic>?> detailsRaw = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PointLogsCompanion(
                logId: logId,
                logType: logType,
                iconTypeCode: iconTypeCode,
                detailType: detailType,
                currencyCode: currencyCode,
                title: title,
                pointsChange: pointsChange,
                occurredAt: occurredAt,
                lastUpdatedAt: lastUpdatedAt,
                detailsRaw: detailsRaw,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String logId,
                required LogType logType,
                required IconTypeCode iconTypeCode,
                required DetailType detailType,
                required String currencyCode,
                required String title,
                required int pointsChange,
                required DateTime occurredAt,
                required DateTime lastUpdatedAt,
                Value<Map<String, dynamic>?> detailsRaw = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PointLogsCompanion.insert(
                logId: logId,
                logType: logType,
                iconTypeCode: iconTypeCode,
                detailType: detailType,
                currencyCode: currencyCode,
                title: title,
                pointsChange: pointsChange,
                occurredAt: occurredAt,
                lastUpdatedAt: lastUpdatedAt,
                detailsRaw: detailsRaw,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PointLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PointLogsTable,
      PointLogEntity,
      $$PointLogsTableFilterComposer,
      $$PointLogsTableOrderingComposer,
      $$PointLogsTableAnnotationComposer,
      $$PointLogsTableCreateCompanionBuilder,
      $$PointLogsTableUpdateCompanionBuilder,
      (
        PointLogEntity,
        BaseReferences<_$AppDatabase, $PointLogsTable, PointLogEntity>,
      ),
      PointLogEntity,
      PrefetchHooks Function()
    >;
typedef $$SitesTableCreateCompanionBuilder =
    SitesCompanion Function({
      required String id,
      required String code,
      required String name,
      required SiteType siteType,
      required String address,
      required double longitude,
      required double latitude,
      required String serviceHours,
      required String areaId,
      required String districtId,
      Value<String?> note,
      required List<RecyclableItemType> recyclableItems,
      Value<bool> isFavorite,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$SitesTableUpdateCompanionBuilder =
    SitesCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<SiteType> siteType,
      Value<String> address,
      Value<double> longitude,
      Value<double> latitude,
      Value<String> serviceHours,
      Value<String> areaId,
      Value<String> districtId,
      Value<String?> note,
      Value<List<RecyclableItemType>> recyclableItems,
      Value<bool> isFavorite,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$SitesTableFilterComposer extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SiteType, SiteType, String> get siteType =>
      $composableBuilder(
        column: $table.siteType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceHours => $composableBuilder(
    column: $table.serviceHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get areaId => $composableBuilder(
    column: $table.areaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get districtId => $composableBuilder(
    column: $table.districtId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<RecyclableItemType>,
    List<RecyclableItemType>,
    String
  >
  get recyclableItems => $composableBuilder(
    column: $table.recyclableItems,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SitesTableOrderingComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteType => $composableBuilder(
    column: $table.siteType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceHours => $composableBuilder(
    column: $table.serviceHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get areaId => $composableBuilder(
    column: $table.areaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get districtId => $composableBuilder(
    column: $table.districtId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recyclableItems => $composableBuilder(
    column: $table.recyclableItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SitesTable> {
  $$SitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SiteType, String> get siteType =>
      $composableBuilder(column: $table.siteType, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<String> get serviceHours => $composableBuilder(
    column: $table.serviceHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get areaId =>
      $composableBuilder(column: $table.areaId, builder: (column) => column);

  GeneratedColumn<String> get districtId => $composableBuilder(
    column: $table.districtId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<RecyclableItemType>, String>
  get recyclableItems => $composableBuilder(
    column: $table.recyclableItems,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$SitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SitesTable,
          SiteEntity,
          $$SitesTableFilterComposer,
          $$SitesTableOrderingComposer,
          $$SitesTableAnnotationComposer,
          $$SitesTableCreateCompanionBuilder,
          $$SitesTableUpdateCompanionBuilder,
          (SiteEntity, BaseReferences<_$AppDatabase, $SitesTable, SiteEntity>),
          SiteEntity,
          PrefetchHooks Function()
        > {
  $$SitesTableTableManager(_$AppDatabase db, $SitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<SiteType> siteType = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<String> serviceHours = const Value.absent(),
                Value<String> areaId = const Value.absent(),
                Value<String> districtId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<List<RecyclableItemType>> recyclableItems =
                    const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SitesCompanion(
                id: id,
                code: code,
                name: name,
                siteType: siteType,
                address: address,
                longitude: longitude,
                latitude: latitude,
                serviceHours: serviceHours,
                areaId: areaId,
                districtId: districtId,
                note: note,
                recyclableItems: recyclableItems,
                isFavorite: isFavorite,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required SiteType siteType,
                required String address,
                required double longitude,
                required double latitude,
                required String serviceHours,
                required String areaId,
                required String districtId,
                Value<String?> note = const Value.absent(),
                required List<RecyclableItemType> recyclableItems,
                Value<bool> isFavorite = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => SitesCompanion.insert(
                id: id,
                code: code,
                name: name,
                siteType: siteType,
                address: address,
                longitude: longitude,
                latitude: latitude,
                serviceHours: serviceHours,
                areaId: areaId,
                districtId: districtId,
                note: note,
                recyclableItems: recyclableItems,
                isFavorite: isFavorite,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SitesTable,
      SiteEntity,
      $$SitesTableFilterComposer,
      $$SitesTableOrderingComposer,
      $$SitesTableAnnotationComposer,
      $$SitesTableCreateCompanionBuilder,
      $$SitesTableUpdateCompanionBuilder,
      (SiteEntity, BaseReferences<_$AppDatabase, $SitesTable, SiteEntity>),
      SiteEntity,
      PrefetchHooks Function()
    >;
typedef $$SiteStatusesTableCreateCompanionBuilder =
    SiteStatusesCompanion Function({
      required String siteId,
      required String displayStatus,
      Value<String?> cardType,
      Value<bool?> isOffHours,
      Value<List<ItemStatus>?> itemStatusList,
      Value<List<BinStatus>?> binStatusList,
      required DateTime statusCachedAt,
      Value<int> rowid,
    });
typedef $$SiteStatusesTableUpdateCompanionBuilder =
    SiteStatusesCompanion Function({
      Value<String> siteId,
      Value<String> displayStatus,
      Value<String?> cardType,
      Value<bool?> isOffHours,
      Value<List<ItemStatus>?> itemStatusList,
      Value<List<BinStatus>?> binStatusList,
      Value<DateTime> statusCachedAt,
      Value<int> rowid,
    });

class $$SiteStatusesTableFilterComposer
    extends Composer<_$AppDatabase, $SiteStatusesTable> {
  $$SiteStatusesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayStatus => $composableBuilder(
    column: $table.displayStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOffHours => $composableBuilder(
    column: $table.isOffHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<ItemStatus>?, List<ItemStatus>, String>
  get itemStatusList => $composableBuilder(
    column: $table.itemStatusList,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<BinStatus>?, List<BinStatus>, String>
  get binStatusList => $composableBuilder(
    column: $table.binStatusList,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get statusCachedAt => $composableBuilder(
    column: $table.statusCachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SiteStatusesTableOrderingComposer
    extends Composer<_$AppDatabase, $SiteStatusesTable> {
  $$SiteStatusesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayStatus => $composableBuilder(
    column: $table.displayStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOffHours => $composableBuilder(
    column: $table.isOffHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemStatusList => $composableBuilder(
    column: $table.itemStatusList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get binStatusList => $composableBuilder(
    column: $table.binStatusList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get statusCachedAt => $composableBuilder(
    column: $table.statusCachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SiteStatusesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SiteStatusesTable> {
  $$SiteStatusesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get displayStatus => $composableBuilder(
    column: $table.displayStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<bool> get isOffHours => $composableBuilder(
    column: $table.isOffHours,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<ItemStatus>?, String>
  get itemStatusList => $composableBuilder(
    column: $table.itemStatusList,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<BinStatus>?, String>
  get binStatusList => $composableBuilder(
    column: $table.binStatusList,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get statusCachedAt => $composableBuilder(
    column: $table.statusCachedAt,
    builder: (column) => column,
  );
}

class $$SiteStatusesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SiteStatusesTable,
          SiteStatusEntity,
          $$SiteStatusesTableFilterComposer,
          $$SiteStatusesTableOrderingComposer,
          $$SiteStatusesTableAnnotationComposer,
          $$SiteStatusesTableCreateCompanionBuilder,
          $$SiteStatusesTableUpdateCompanionBuilder,
          (
            SiteStatusEntity,
            BaseReferences<_$AppDatabase, $SiteStatusesTable, SiteStatusEntity>,
          ),
          SiteStatusEntity,
          PrefetchHooks Function()
        > {
  $$SiteStatusesTableTableManager(_$AppDatabase db, $SiteStatusesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SiteStatusesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SiteStatusesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SiteStatusesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> siteId = const Value.absent(),
                Value<String> displayStatus = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<bool?> isOffHours = const Value.absent(),
                Value<List<ItemStatus>?> itemStatusList = const Value.absent(),
                Value<List<BinStatus>?> binStatusList = const Value.absent(),
                Value<DateTime> statusCachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SiteStatusesCompanion(
                siteId: siteId,
                displayStatus: displayStatus,
                cardType: cardType,
                isOffHours: isOffHours,
                itemStatusList: itemStatusList,
                binStatusList: binStatusList,
                statusCachedAt: statusCachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String siteId,
                required String displayStatus,
                Value<String?> cardType = const Value.absent(),
                Value<bool?> isOffHours = const Value.absent(),
                Value<List<ItemStatus>?> itemStatusList = const Value.absent(),
                Value<List<BinStatus>?> binStatusList = const Value.absent(),
                required DateTime statusCachedAt,
                Value<int> rowid = const Value.absent(),
              }) => SiteStatusesCompanion.insert(
                siteId: siteId,
                displayStatus: displayStatus,
                cardType: cardType,
                isOffHours: isOffHours,
                itemStatusList: itemStatusList,
                binStatusList: binStatusList,
                statusCachedAt: statusCachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SiteStatusesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SiteStatusesTable,
      SiteStatusEntity,
      $$SiteStatusesTableFilterComposer,
      $$SiteStatusesTableOrderingComposer,
      $$SiteStatusesTableAnnotationComposer,
      $$SiteStatusesTableCreateCompanionBuilder,
      $$SiteStatusesTableUpdateCompanionBuilder,
      (
        SiteStatusEntity,
        BaseReferences<_$AppDatabase, $SiteStatusesTable, SiteStatusEntity>,
      ),
      SiteStatusEntity,
      PrefetchHooks Function()
    >;
typedef $$BrandsTableCreateCompanionBuilder =
    BrandsCompanion Function({
      required String id,
      required bool isActive,
      required String name,
      Value<BrandCategory?> category,
      Value<String?> logoUrl,
      required bool isPremium,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<String?> descriptionMdUrl,
      required int sortOrder,
      required List<String> couponRuleIds,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$BrandsTableUpdateCompanionBuilder =
    BrandsCompanion Function({
      Value<String> id,
      Value<bool> isActive,
      Value<String> name,
      Value<BrandCategory?> category,
      Value<String?> logoUrl,
      Value<bool> isPremium,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<String?> descriptionMdUrl,
      Value<int> sortOrder,
      Value<List<String>> couponRuleIds,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$BrandsTableFilterComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableFilterComposer({
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

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BrandCategory?, BrandCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionMdUrl => $composableBuilder(
    column: $table.descriptionMdUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get couponRuleIds => $composableBuilder(
    column: $table.couponRuleIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrandsTableOrderingComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableOrderingComposer({
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

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoUrl => $composableBuilder(
    column: $table.logoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionMdUrl => $composableBuilder(
    column: $table.descriptionMdUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get couponRuleIds => $composableBuilder(
    column: $table.couponRuleIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrandsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrandsTable> {
  $$BrandsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BrandCategory?, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<bool> get isPremium =>
      $composableBuilder(column: $table.isPremium, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get descriptionMdUrl => $composableBuilder(
    column: $table.descriptionMdUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get couponRuleIds =>
      $composableBuilder(
        column: $table.couponRuleIds,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$BrandsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrandsTable,
          BrandEntity,
          $$BrandsTableFilterComposer,
          $$BrandsTableOrderingComposer,
          $$BrandsTableAnnotationComposer,
          $$BrandsTableCreateCompanionBuilder,
          $$BrandsTableUpdateCompanionBuilder,
          (
            BrandEntity,
            BaseReferences<_$AppDatabase, $BrandsTable, BrandEntity>,
          ),
          BrandEntity,
          PrefetchHooks Function()
        > {
  $$BrandsTableTableManager(_$AppDatabase db, $BrandsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrandsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrandsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrandsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<BrandCategory?> category = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                Value<bool> isPremium = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> descriptionMdUrl = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<List<String>> couponRuleIds = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrandsCompanion(
                id: id,
                isActive: isActive,
                name: name,
                category: category,
                logoUrl: logoUrl,
                isPremium: isPremium,
                startDate: startDate,
                endDate: endDate,
                descriptionMdUrl: descriptionMdUrl,
                sortOrder: sortOrder,
                couponRuleIds: couponRuleIds,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required bool isActive,
                required String name,
                Value<BrandCategory?> category = const Value.absent(),
                Value<String?> logoUrl = const Value.absent(),
                required bool isPremium,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<String?> descriptionMdUrl = const Value.absent(),
                required int sortOrder,
                required List<String> couponRuleIds,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => BrandsCompanion.insert(
                id: id,
                isActive: isActive,
                name: name,
                category: category,
                logoUrl: logoUrl,
                isPremium: isPremium,
                startDate: startDate,
                endDate: endDate,
                descriptionMdUrl: descriptionMdUrl,
                sortOrder: sortOrder,
                couponRuleIds: couponRuleIds,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrandsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrandsTable,
      BrandEntity,
      $$BrandsTableFilterComposer,
      $$BrandsTableOrderingComposer,
      $$BrandsTableAnnotationComposer,
      $$BrandsTableCreateCompanionBuilder,
      $$BrandsTableUpdateCompanionBuilder,
      (BrandEntity, BaseReferences<_$AppDatabase, $BrandsTable, BrandEntity>),
      BrandEntity,
      PrefetchHooks Function()
    >;
typedef $$CouponRulesTableCreateCompanionBuilder =
    CouponRulesCompanion Function({
      required String id,
      required bool isActive,
      required String categoryCode,
      required String title,
      required String brandId,
      required String brandName,
      Value<String?> cardImageUrl,
      Value<String?> donationCode,
      required bool isPremium,
      Value<String?> promoLabel,
      Value<String?> shortNotice,
      required int unitPrice,
      required String displayUnit,
      required String currencyCode,
      required String exchangeDisplayText,
      required String exchangeInputType,
      required String exchangeFlowType,
      required String assetRedeemType,
      Value<int?> maxPerExchangeCount,
      required int exchangeStepValue,
      required List<String> geofenceAreaIds,
      required DateTime exchangeableStartAt,
      Value<DateTime?> exchangeableEndAt,
      required DateTime lastUpdatedAt,
      required List<CarouselItem> carouselList,
      Value<String?> exchangeAlert,
      Value<String?> externalRedemptionUrl,
      required String rulesSummaryMdUrl,
      required String redemptionTermsMdUrl,
      Value<String?> userInstructionMdUrl,
      Value<String?> staffInstructionMdUrl,
      required int sortOrder,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CouponRulesTableUpdateCompanionBuilder =
    CouponRulesCompanion Function({
      Value<String> id,
      Value<bool> isActive,
      Value<String> categoryCode,
      Value<String> title,
      Value<String> brandId,
      Value<String> brandName,
      Value<String?> cardImageUrl,
      Value<String?> donationCode,
      Value<bool> isPremium,
      Value<String?> promoLabel,
      Value<String?> shortNotice,
      Value<int> unitPrice,
      Value<String> displayUnit,
      Value<String> currencyCode,
      Value<String> exchangeDisplayText,
      Value<String> exchangeInputType,
      Value<String> exchangeFlowType,
      Value<String> assetRedeemType,
      Value<int?> maxPerExchangeCount,
      Value<int> exchangeStepValue,
      Value<List<String>> geofenceAreaIds,
      Value<DateTime> exchangeableStartAt,
      Value<DateTime?> exchangeableEndAt,
      Value<DateTime> lastUpdatedAt,
      Value<List<CarouselItem>> carouselList,
      Value<String?> exchangeAlert,
      Value<String?> externalRedemptionUrl,
      Value<String> rulesSummaryMdUrl,
      Value<String> redemptionTermsMdUrl,
      Value<String?> userInstructionMdUrl,
      Value<String?> staffInstructionMdUrl,
      Value<int> sortOrder,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CouponRulesTableFilterComposer
    extends Composer<_$AppDatabase, $CouponRulesTable> {
  $$CouponRulesTableFilterComposer({
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

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardImageUrl => $composableBuilder(
    column: $table.cardImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get donationCode => $composableBuilder(
    column: $table.donationCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promoLabel => $composableBuilder(
    column: $table.promoLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shortNotice => $composableBuilder(
    column: $table.shortNotice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayUnit => $composableBuilder(
    column: $table.displayUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exchangeDisplayText => $composableBuilder(
    column: $table.exchangeDisplayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exchangeInputType => $composableBuilder(
    column: $table.exchangeInputType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exchangeFlowType => $composableBuilder(
    column: $table.exchangeFlowType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assetRedeemType => $composableBuilder(
    column: $table.assetRedeemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxPerExchangeCount => $composableBuilder(
    column: $table.maxPerExchangeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exchangeStepValue => $composableBuilder(
    column: $table.exchangeStepValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get geofenceAreaIds => $composableBuilder(
    column: $table.geofenceAreaIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get exchangeableStartAt => $composableBuilder(
    column: $table.exchangeableStartAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get exchangeableEndAt => $composableBuilder(
    column: $table.exchangeableEndAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<CarouselItem>, List<CarouselItem>, String>
  get carouselList => $composableBuilder(
    column: $table.carouselList,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get exchangeAlert => $composableBuilder(
    column: $table.exchangeAlert,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalRedemptionUrl => $composableBuilder(
    column: $table.externalRedemptionUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rulesSummaryMdUrl => $composableBuilder(
    column: $table.rulesSummaryMdUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get redemptionTermsMdUrl => $composableBuilder(
    column: $table.redemptionTermsMdUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userInstructionMdUrl => $composableBuilder(
    column: $table.userInstructionMdUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get staffInstructionMdUrl => $composableBuilder(
    column: $table.staffInstructionMdUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CouponRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CouponRulesTable> {
  $$CouponRulesTableOrderingComposer({
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

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandId => $composableBuilder(
    column: $table.brandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandName => $composableBuilder(
    column: $table.brandName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardImageUrl => $composableBuilder(
    column: $table.cardImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get donationCode => $composableBuilder(
    column: $table.donationCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPremium => $composableBuilder(
    column: $table.isPremium,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promoLabel => $composableBuilder(
    column: $table.promoLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shortNotice => $composableBuilder(
    column: $table.shortNotice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayUnit => $composableBuilder(
    column: $table.displayUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exchangeDisplayText => $composableBuilder(
    column: $table.exchangeDisplayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exchangeInputType => $composableBuilder(
    column: $table.exchangeInputType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exchangeFlowType => $composableBuilder(
    column: $table.exchangeFlowType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assetRedeemType => $composableBuilder(
    column: $table.assetRedeemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxPerExchangeCount => $composableBuilder(
    column: $table.maxPerExchangeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exchangeStepValue => $composableBuilder(
    column: $table.exchangeStepValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geofenceAreaIds => $composableBuilder(
    column: $table.geofenceAreaIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get exchangeableStartAt => $composableBuilder(
    column: $table.exchangeableStartAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get exchangeableEndAt => $composableBuilder(
    column: $table.exchangeableEndAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get carouselList => $composableBuilder(
    column: $table.carouselList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exchangeAlert => $composableBuilder(
    column: $table.exchangeAlert,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalRedemptionUrl => $composableBuilder(
    column: $table.externalRedemptionUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rulesSummaryMdUrl => $composableBuilder(
    column: $table.rulesSummaryMdUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get redemptionTermsMdUrl => $composableBuilder(
    column: $table.redemptionTermsMdUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userInstructionMdUrl => $composableBuilder(
    column: $table.userInstructionMdUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get staffInstructionMdUrl => $composableBuilder(
    column: $table.staffInstructionMdUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CouponRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CouponRulesTable> {
  $$CouponRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get brandId =>
      $composableBuilder(column: $table.brandId, builder: (column) => column);

  GeneratedColumn<String> get brandName =>
      $composableBuilder(column: $table.brandName, builder: (column) => column);

  GeneratedColumn<String> get cardImageUrl => $composableBuilder(
    column: $table.cardImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get donationCode => $composableBuilder(
    column: $table.donationCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPremium =>
      $composableBuilder(column: $table.isPremium, builder: (column) => column);

  GeneratedColumn<String> get promoLabel => $composableBuilder(
    column: $table.promoLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get shortNotice => $composableBuilder(
    column: $table.shortNotice,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get displayUnit => $composableBuilder(
    column: $table.displayUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exchangeDisplayText => $composableBuilder(
    column: $table.exchangeDisplayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exchangeInputType => $composableBuilder(
    column: $table.exchangeInputType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exchangeFlowType => $composableBuilder(
    column: $table.exchangeFlowType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assetRedeemType => $composableBuilder(
    column: $table.assetRedeemType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxPerExchangeCount => $composableBuilder(
    column: $table.maxPerExchangeCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exchangeStepValue => $composableBuilder(
    column: $table.exchangeStepValue,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get geofenceAreaIds =>
      $composableBuilder(
        column: $table.geofenceAreaIds,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get exchangeableStartAt => $composableBuilder(
    column: $table.exchangeableStartAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get exchangeableEndAt => $composableBuilder(
    column: $table.exchangeableEndAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<CarouselItem>, String>
  get carouselList => $composableBuilder(
    column: $table.carouselList,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exchangeAlert => $composableBuilder(
    column: $table.exchangeAlert,
    builder: (column) => column,
  );

  GeneratedColumn<String> get externalRedemptionUrl => $composableBuilder(
    column: $table.externalRedemptionUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rulesSummaryMdUrl => $composableBuilder(
    column: $table.rulesSummaryMdUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get redemptionTermsMdUrl => $composableBuilder(
    column: $table.redemptionTermsMdUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userInstructionMdUrl => $composableBuilder(
    column: $table.userInstructionMdUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get staffInstructionMdUrl => $composableBuilder(
    column: $table.staffInstructionMdUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CouponRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CouponRulesTable,
          CouponRuleEntity,
          $$CouponRulesTableFilterComposer,
          $$CouponRulesTableOrderingComposer,
          $$CouponRulesTableAnnotationComposer,
          $$CouponRulesTableCreateCompanionBuilder,
          $$CouponRulesTableUpdateCompanionBuilder,
          (
            CouponRuleEntity,
            BaseReferences<_$AppDatabase, $CouponRulesTable, CouponRuleEntity>,
          ),
          CouponRuleEntity,
          PrefetchHooks Function()
        > {
  $$CouponRulesTableTableManager(_$AppDatabase db, $CouponRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CouponRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CouponRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CouponRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<String> categoryCode = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> brandId = const Value.absent(),
                Value<String> brandName = const Value.absent(),
                Value<String?> cardImageUrl = const Value.absent(),
                Value<String?> donationCode = const Value.absent(),
                Value<bool> isPremium = const Value.absent(),
                Value<String?> promoLabel = const Value.absent(),
                Value<String?> shortNotice = const Value.absent(),
                Value<int> unitPrice = const Value.absent(),
                Value<String> displayUnit = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> exchangeDisplayText = const Value.absent(),
                Value<String> exchangeInputType = const Value.absent(),
                Value<String> exchangeFlowType = const Value.absent(),
                Value<String> assetRedeemType = const Value.absent(),
                Value<int?> maxPerExchangeCount = const Value.absent(),
                Value<int> exchangeStepValue = const Value.absent(),
                Value<List<String>> geofenceAreaIds = const Value.absent(),
                Value<DateTime> exchangeableStartAt = const Value.absent(),
                Value<DateTime?> exchangeableEndAt = const Value.absent(),
                Value<DateTime> lastUpdatedAt = const Value.absent(),
                Value<List<CarouselItem>> carouselList = const Value.absent(),
                Value<String?> exchangeAlert = const Value.absent(),
                Value<String?> externalRedemptionUrl = const Value.absent(),
                Value<String> rulesSummaryMdUrl = const Value.absent(),
                Value<String> redemptionTermsMdUrl = const Value.absent(),
                Value<String?> userInstructionMdUrl = const Value.absent(),
                Value<String?> staffInstructionMdUrl = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CouponRulesCompanion(
                id: id,
                isActive: isActive,
                categoryCode: categoryCode,
                title: title,
                brandId: brandId,
                brandName: brandName,
                cardImageUrl: cardImageUrl,
                donationCode: donationCode,
                isPremium: isPremium,
                promoLabel: promoLabel,
                shortNotice: shortNotice,
                unitPrice: unitPrice,
                displayUnit: displayUnit,
                currencyCode: currencyCode,
                exchangeDisplayText: exchangeDisplayText,
                exchangeInputType: exchangeInputType,
                exchangeFlowType: exchangeFlowType,
                assetRedeemType: assetRedeemType,
                maxPerExchangeCount: maxPerExchangeCount,
                exchangeStepValue: exchangeStepValue,
                geofenceAreaIds: geofenceAreaIds,
                exchangeableStartAt: exchangeableStartAt,
                exchangeableEndAt: exchangeableEndAt,
                lastUpdatedAt: lastUpdatedAt,
                carouselList: carouselList,
                exchangeAlert: exchangeAlert,
                externalRedemptionUrl: externalRedemptionUrl,
                rulesSummaryMdUrl: rulesSummaryMdUrl,
                redemptionTermsMdUrl: redemptionTermsMdUrl,
                userInstructionMdUrl: userInstructionMdUrl,
                staffInstructionMdUrl: staffInstructionMdUrl,
                sortOrder: sortOrder,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required bool isActive,
                required String categoryCode,
                required String title,
                required String brandId,
                required String brandName,
                Value<String?> cardImageUrl = const Value.absent(),
                Value<String?> donationCode = const Value.absent(),
                required bool isPremium,
                Value<String?> promoLabel = const Value.absent(),
                Value<String?> shortNotice = const Value.absent(),
                required int unitPrice,
                required String displayUnit,
                required String currencyCode,
                required String exchangeDisplayText,
                required String exchangeInputType,
                required String exchangeFlowType,
                required String assetRedeemType,
                Value<int?> maxPerExchangeCount = const Value.absent(),
                required int exchangeStepValue,
                required List<String> geofenceAreaIds,
                required DateTime exchangeableStartAt,
                Value<DateTime?> exchangeableEndAt = const Value.absent(),
                required DateTime lastUpdatedAt,
                required List<CarouselItem> carouselList,
                Value<String?> exchangeAlert = const Value.absent(),
                Value<String?> externalRedemptionUrl = const Value.absent(),
                required String rulesSummaryMdUrl,
                required String redemptionTermsMdUrl,
                Value<String?> userInstructionMdUrl = const Value.absent(),
                Value<String?> staffInstructionMdUrl = const Value.absent(),
                required int sortOrder,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CouponRulesCompanion.insert(
                id: id,
                isActive: isActive,
                categoryCode: categoryCode,
                title: title,
                brandId: brandId,
                brandName: brandName,
                cardImageUrl: cardImageUrl,
                donationCode: donationCode,
                isPremium: isPremium,
                promoLabel: promoLabel,
                shortNotice: shortNotice,
                unitPrice: unitPrice,
                displayUnit: displayUnit,
                currencyCode: currencyCode,
                exchangeDisplayText: exchangeDisplayText,
                exchangeInputType: exchangeInputType,
                exchangeFlowType: exchangeFlowType,
                assetRedeemType: assetRedeemType,
                maxPerExchangeCount: maxPerExchangeCount,
                exchangeStepValue: exchangeStepValue,
                geofenceAreaIds: geofenceAreaIds,
                exchangeableStartAt: exchangeableStartAt,
                exchangeableEndAt: exchangeableEndAt,
                lastUpdatedAt: lastUpdatedAt,
                carouselList: carouselList,
                exchangeAlert: exchangeAlert,
                externalRedemptionUrl: externalRedemptionUrl,
                rulesSummaryMdUrl: rulesSummaryMdUrl,
                redemptionTermsMdUrl: redemptionTermsMdUrl,
                userInstructionMdUrl: userInstructionMdUrl,
                staffInstructionMdUrl: staffInstructionMdUrl,
                sortOrder: sortOrder,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CouponRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CouponRulesTable,
      CouponRuleEntity,
      $$CouponRulesTableFilterComposer,
      $$CouponRulesTableOrderingComposer,
      $$CouponRulesTableAnnotationComposer,
      $$CouponRulesTableCreateCompanionBuilder,
      $$CouponRulesTableUpdateCompanionBuilder,
      (
        CouponRuleEntity,
        BaseReferences<_$AppDatabase, $CouponRulesTable, CouponRuleEntity>,
      ),
      CouponRuleEntity,
      PrefetchHooks Function()
    >;
typedef $$CouponRuleStatusesTableCreateCompanionBuilder =
    CouponRuleStatusesCompanion Function({
      required String couponRuleId,
      required String displayStatus,
      required DateTime statusCachedAt,
      Value<int> rowid,
    });
typedef $$CouponRuleStatusesTableUpdateCompanionBuilder =
    CouponRuleStatusesCompanion Function({
      Value<String> couponRuleId,
      Value<String> displayStatus,
      Value<DateTime> statusCachedAt,
      Value<int> rowid,
    });

class $$CouponRuleStatusesTableFilterComposer
    extends Composer<_$AppDatabase, $CouponRuleStatusesTable> {
  $$CouponRuleStatusesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get couponRuleId => $composableBuilder(
    column: $table.couponRuleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayStatus => $composableBuilder(
    column: $table.displayStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get statusCachedAt => $composableBuilder(
    column: $table.statusCachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CouponRuleStatusesTableOrderingComposer
    extends Composer<_$AppDatabase, $CouponRuleStatusesTable> {
  $$CouponRuleStatusesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get couponRuleId => $composableBuilder(
    column: $table.couponRuleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayStatus => $composableBuilder(
    column: $table.displayStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get statusCachedAt => $composableBuilder(
    column: $table.statusCachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CouponRuleStatusesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CouponRuleStatusesTable> {
  $$CouponRuleStatusesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get couponRuleId => $composableBuilder(
    column: $table.couponRuleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayStatus => $composableBuilder(
    column: $table.displayStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get statusCachedAt => $composableBuilder(
    column: $table.statusCachedAt,
    builder: (column) => column,
  );
}

class $$CouponRuleStatusesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CouponRuleStatusesTable,
          CouponRuleStatusEntity,
          $$CouponRuleStatusesTableFilterComposer,
          $$CouponRuleStatusesTableOrderingComposer,
          $$CouponRuleStatusesTableAnnotationComposer,
          $$CouponRuleStatusesTableCreateCompanionBuilder,
          $$CouponRuleStatusesTableUpdateCompanionBuilder,
          (
            CouponRuleStatusEntity,
            BaseReferences<
              _$AppDatabase,
              $CouponRuleStatusesTable,
              CouponRuleStatusEntity
            >,
          ),
          CouponRuleStatusEntity,
          PrefetchHooks Function()
        > {
  $$CouponRuleStatusesTableTableManager(
    _$AppDatabase db,
    $CouponRuleStatusesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CouponRuleStatusesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CouponRuleStatusesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CouponRuleStatusesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> couponRuleId = const Value.absent(),
                Value<String> displayStatus = const Value.absent(),
                Value<DateTime> statusCachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CouponRuleStatusesCompanion(
                couponRuleId: couponRuleId,
                displayStatus: displayStatus,
                statusCachedAt: statusCachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String couponRuleId,
                required String displayStatus,
                required DateTime statusCachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CouponRuleStatusesCompanion.insert(
                couponRuleId: couponRuleId,
                displayStatus: displayStatus,
                statusCachedAt: statusCachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CouponRuleStatusesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CouponRuleStatusesTable,
      CouponRuleStatusEntity,
      $$CouponRuleStatusesTableFilterComposer,
      $$CouponRuleStatusesTableOrderingComposer,
      $$CouponRuleStatusesTableAnnotationComposer,
      $$CouponRuleStatusesTableCreateCompanionBuilder,
      $$CouponRuleStatusesTableUpdateCompanionBuilder,
      (
        CouponRuleStatusEntity,
        BaseReferences<
          _$AppDatabase,
          $CouponRuleStatusesTable,
          CouponRuleStatusEntity
        >,
      ),
      CouponRuleStatusEntity,
      PrefetchHooks Function()
    >;
typedef $$CarouselsTableCreateCompanionBuilder =
    CarouselsCompanion Function({
      required String id,
      required String placementKey,
      required String title,
      Value<String?> promotionCode,
      required String mediaType,
      required String mediaUrl,
      Value<String?> fallbackUrl,
      required String actionType,
      Value<String?> actionLink,
      required int sortOrder,
      required DateTime publishedAt,
      Value<DateTime?> expiredAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CarouselsTableUpdateCompanionBuilder =
    CarouselsCompanion Function({
      Value<String> id,
      Value<String> placementKey,
      Value<String> title,
      Value<String?> promotionCode,
      Value<String> mediaType,
      Value<String> mediaUrl,
      Value<String?> fallbackUrl,
      Value<String> actionType,
      Value<String?> actionLink,
      Value<int> sortOrder,
      Value<DateTime> publishedAt,
      Value<DateTime?> expiredAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CarouselsTableFilterComposer
    extends Composer<_$AppDatabase, $CarouselsTable> {
  $$CarouselsTableFilterComposer({
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

  ColumnFilters<String> get placementKey => $composableBuilder(
    column: $table.placementKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promotionCode => $composableBuilder(
    column: $table.promotionCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fallbackUrl => $composableBuilder(
    column: $table.fallbackUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionLink => $composableBuilder(
    column: $table.actionLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CarouselsTableOrderingComposer
    extends Composer<_$AppDatabase, $CarouselsTable> {
  $$CarouselsTableOrderingComposer({
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

  ColumnOrderings<String> get placementKey => $composableBuilder(
    column: $table.placementKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promotionCode => $composableBuilder(
    column: $table.promotionCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fallbackUrl => $composableBuilder(
    column: $table.fallbackUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionLink => $composableBuilder(
    column: $table.actionLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CarouselsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarouselsTable> {
  $$CarouselsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get placementKey => $composableBuilder(
    column: $table.placementKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get promotionCode => $composableBuilder(
    column: $table.promotionCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<String> get fallbackUrl => $composableBuilder(
    column: $table.fallbackUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionLink => $composableBuilder(
    column: $table.actionLink,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiredAt =>
      $composableBuilder(column: $table.expiredAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CarouselsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarouselsTable,
          Carousel,
          $$CarouselsTableFilterComposer,
          $$CarouselsTableOrderingComposer,
          $$CarouselsTableAnnotationComposer,
          $$CarouselsTableCreateCompanionBuilder,
          $$CarouselsTableUpdateCompanionBuilder,
          (Carousel, BaseReferences<_$AppDatabase, $CarouselsTable, Carousel>),
          Carousel,
          PrefetchHooks Function()
        > {
  $$CarouselsTableTableManager(_$AppDatabase db, $CarouselsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarouselsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarouselsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarouselsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> placementKey = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> promotionCode = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String> mediaUrl = const Value.absent(),
                Value<String?> fallbackUrl = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String?> actionLink = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> publishedAt = const Value.absent(),
                Value<DateTime?> expiredAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarouselsCompanion(
                id: id,
                placementKey: placementKey,
                title: title,
                promotionCode: promotionCode,
                mediaType: mediaType,
                mediaUrl: mediaUrl,
                fallbackUrl: fallbackUrl,
                actionType: actionType,
                actionLink: actionLink,
                sortOrder: sortOrder,
                publishedAt: publishedAt,
                expiredAt: expiredAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String placementKey,
                required String title,
                Value<String?> promotionCode = const Value.absent(),
                required String mediaType,
                required String mediaUrl,
                Value<String?> fallbackUrl = const Value.absent(),
                required String actionType,
                Value<String?> actionLink = const Value.absent(),
                required int sortOrder,
                required DateTime publishedAt,
                Value<DateTime?> expiredAt = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CarouselsCompanion.insert(
                id: id,
                placementKey: placementKey,
                title: title,
                promotionCode: promotionCode,
                mediaType: mediaType,
                mediaUrl: mediaUrl,
                fallbackUrl: fallbackUrl,
                actionType: actionType,
                actionLink: actionLink,
                sortOrder: sortOrder,
                publishedAt: publishedAt,
                expiredAt: expiredAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CarouselsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarouselsTable,
      Carousel,
      $$CarouselsTableFilterComposer,
      $$CarouselsTableOrderingComposer,
      $$CarouselsTableAnnotationComposer,
      $$CarouselsTableCreateCompanionBuilder,
      $$CarouselsTableUpdateCompanionBuilder,
      (Carousel, BaseReferences<_$AppDatabase, $CarouselsTable, Carousel>),
      Carousel,
      PrefetchHooks Function()
    >;
typedef $$MemberCouponsTableCreateCompanionBuilder =
    MemberCouponsCompanion Function({
      required String id,
      required String couponRuleId,
      required String currentStatus,
      required DateTime issuedAt,
      required DateTime useStartAt,
      Value<DateTime?> expiredAt,
      Value<DateTime?> usedAt,
      Value<DateTime?> canceledAt,
      Value<DateTime?> revokedAt,
      required DateTime lastUpdatedAt,
      required List<RedemptionCredentialModel> redemptionCredentials,
      Value<int?> exchangeUnits,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });
typedef $$MemberCouponsTableUpdateCompanionBuilder =
    MemberCouponsCompanion Function({
      Value<String> id,
      Value<String> couponRuleId,
      Value<String> currentStatus,
      Value<DateTime> issuedAt,
      Value<DateTime> useStartAt,
      Value<DateTime?> expiredAt,
      Value<DateTime?> usedAt,
      Value<DateTime?> canceledAt,
      Value<DateTime?> revokedAt,
      Value<DateTime> lastUpdatedAt,
      Value<List<RedemptionCredentialModel>> redemptionCredentials,
      Value<int?> exchangeUnits,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$MemberCouponsTableFilterComposer
    extends Composer<_$AppDatabase, $MemberCouponsTable> {
  $$MemberCouponsTableFilterComposer({
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

  ColumnFilters<String> get couponRuleId => $composableBuilder(
    column: $table.couponRuleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentStatus => $composableBuilder(
    column: $table.currentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get issuedAt => $composableBuilder(
    column: $table.issuedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get useStartAt => $composableBuilder(
    column: $table.useStartAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get usedAt => $composableBuilder(
    column: $table.usedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get canceledAt => $composableBuilder(
    column: $table.canceledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<RedemptionCredentialModel>,
    List<RedemptionCredentialModel>,
    String
  >
  get redemptionCredentials => $composableBuilder(
    column: $table.redemptionCredentials,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get exchangeUnits => $composableBuilder(
    column: $table.exchangeUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemberCouponsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberCouponsTable> {
  $$MemberCouponsTableOrderingComposer({
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

  ColumnOrderings<String> get couponRuleId => $composableBuilder(
    column: $table.couponRuleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentStatus => $composableBuilder(
    column: $table.currentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get issuedAt => $composableBuilder(
    column: $table.issuedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get useStartAt => $composableBuilder(
    column: $table.useStartAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get usedAt => $composableBuilder(
    column: $table.usedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get canceledAt => $composableBuilder(
    column: $table.canceledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get revokedAt => $composableBuilder(
    column: $table.revokedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get redemptionCredentials => $composableBuilder(
    column: $table.redemptionCredentials,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exchangeUnits => $composableBuilder(
    column: $table.exchangeUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemberCouponsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberCouponsTable> {
  $$MemberCouponsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get couponRuleId => $composableBuilder(
    column: $table.couponRuleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentStatus => $composableBuilder(
    column: $table.currentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get issuedAt =>
      $composableBuilder(column: $table.issuedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get useStartAt => $composableBuilder(
    column: $table.useStartAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiredAt =>
      $composableBuilder(column: $table.expiredAt, builder: (column) => column);

  GeneratedColumn<DateTime> get usedAt =>
      $composableBuilder(column: $table.usedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get canceledAt => $composableBuilder(
    column: $table.canceledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get revokedAt =>
      $composableBuilder(column: $table.revokedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
    column: $table.lastUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<RedemptionCredentialModel>, String>
  get redemptionCredentials => $composableBuilder(
    column: $table.redemptionCredentials,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exchangeUnits => $composableBuilder(
    column: $table.exchangeUnits,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$MemberCouponsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberCouponsTable,
          MemberCouponEntity,
          $$MemberCouponsTableFilterComposer,
          $$MemberCouponsTableOrderingComposer,
          $$MemberCouponsTableAnnotationComposer,
          $$MemberCouponsTableCreateCompanionBuilder,
          $$MemberCouponsTableUpdateCompanionBuilder,
          (
            MemberCouponEntity,
            BaseReferences<
              _$AppDatabase,
              $MemberCouponsTable,
              MemberCouponEntity
            >,
          ),
          MemberCouponEntity,
          PrefetchHooks Function()
        > {
  $$MemberCouponsTableTableManager(_$AppDatabase db, $MemberCouponsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberCouponsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberCouponsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberCouponsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> couponRuleId = const Value.absent(),
                Value<String> currentStatus = const Value.absent(),
                Value<DateTime> issuedAt = const Value.absent(),
                Value<DateTime> useStartAt = const Value.absent(),
                Value<DateTime?> expiredAt = const Value.absent(),
                Value<DateTime?> usedAt = const Value.absent(),
                Value<DateTime?> canceledAt = const Value.absent(),
                Value<DateTime?> revokedAt = const Value.absent(),
                Value<DateTime> lastUpdatedAt = const Value.absent(),
                Value<List<RedemptionCredentialModel>> redemptionCredentials =
                    const Value.absent(),
                Value<int?> exchangeUnits = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberCouponsCompanion(
                id: id,
                couponRuleId: couponRuleId,
                currentStatus: currentStatus,
                issuedAt: issuedAt,
                useStartAt: useStartAt,
                expiredAt: expiredAt,
                usedAt: usedAt,
                canceledAt: canceledAt,
                revokedAt: revokedAt,
                lastUpdatedAt: lastUpdatedAt,
                redemptionCredentials: redemptionCredentials,
                exchangeUnits: exchangeUnits,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String couponRuleId,
                required String currentStatus,
                required DateTime issuedAt,
                required DateTime useStartAt,
                Value<DateTime?> expiredAt = const Value.absent(),
                Value<DateTime?> usedAt = const Value.absent(),
                Value<DateTime?> canceledAt = const Value.absent(),
                Value<DateTime?> revokedAt = const Value.absent(),
                required DateTime lastUpdatedAt,
                required List<RedemptionCredentialModel> redemptionCredentials,
                Value<int?> exchangeUnits = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberCouponsCompanion.insert(
                id: id,
                couponRuleId: couponRuleId,
                currentStatus: currentStatus,
                issuedAt: issuedAt,
                useStartAt: useStartAt,
                expiredAt: expiredAt,
                usedAt: usedAt,
                canceledAt: canceledAt,
                revokedAt: revokedAt,
                lastUpdatedAt: lastUpdatedAt,
                redemptionCredentials: redemptionCredentials,
                exchangeUnits: exchangeUnits,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemberCouponsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberCouponsTable,
      MemberCouponEntity,
      $$MemberCouponsTableFilterComposer,
      $$MemberCouponsTableOrderingComposer,
      $$MemberCouponsTableAnnotationComposer,
      $$MemberCouponsTableCreateCompanionBuilder,
      $$MemberCouponsTableUpdateCompanionBuilder,
      (
        MemberCouponEntity,
        BaseReferences<_$AppDatabase, $MemberCouponsTable, MemberCouponEntity>,
      ),
      MemberCouponEntity,
      PrefetchHooks Function()
    >;
typedef $$NotificationsTableCreateCompanionBuilder =
    NotificationsCompanion Function({
      required String id,
      required String notificationType,
      required String title,
      Value<String?> tagText,
      required String summary,
      required DateTime publishedAt,
      Value<DateTime?> expiredAt,
      required String actionType,
      Value<String?> actionLink,
      Value<bool> isRead,
      Value<DateTime?> readAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$NotificationsTableUpdateCompanionBuilder =
    NotificationsCompanion Function({
      Value<String> id,
      Value<String> notificationType,
      Value<String> title,
      Value<String?> tagText,
      Value<String> summary,
      Value<DateTime> publishedAt,
      Value<DateTime?> expiredAt,
      Value<String> actionType,
      Value<String?> actionLink,
      Value<bool> isRead,
      Value<DateTime?> readAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$NotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
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

  ColumnFilters<String> get notificationType => $composableBuilder(
    column: $table.notificationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagText => $composableBuilder(
    column: $table.tagText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionLink => $composableBuilder(
    column: $table.actionLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
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

  ColumnOrderings<String> get notificationType => $composableBuilder(
    column: $table.notificationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagText => $composableBuilder(
    column: $table.tagText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiredAt => $composableBuilder(
    column: $table.expiredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionLink => $composableBuilder(
    column: $table.actionLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notificationType => $composableBuilder(
    column: $table.notificationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get tagText =>
      $composableBuilder(column: $table.tagText, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiredAt =>
      $composableBuilder(column: $table.expiredAt, builder: (column) => column);

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionLink => $composableBuilder(
    column: $table.actionLink,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$NotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationsTable,
          Notification,
          $$NotificationsTableFilterComposer,
          $$NotificationsTableOrderingComposer,
          $$NotificationsTableAnnotationComposer,
          $$NotificationsTableCreateCompanionBuilder,
          $$NotificationsTableUpdateCompanionBuilder,
          (
            Notification,
            BaseReferences<_$AppDatabase, $NotificationsTable, Notification>,
          ),
          Notification,
          PrefetchHooks Function()
        > {
  $$NotificationsTableTableManager(_$AppDatabase db, $NotificationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> notificationType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> tagText = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<DateTime> publishedAt = const Value.absent(),
                Value<DateTime?> expiredAt = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<String?> actionLink = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationsCompanion(
                id: id,
                notificationType: notificationType,
                title: title,
                tagText: tagText,
                summary: summary,
                publishedAt: publishedAt,
                expiredAt: expiredAt,
                actionType: actionType,
                actionLink: actionLink,
                isRead: isRead,
                readAt: readAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String notificationType,
                required String title,
                Value<String?> tagText = const Value.absent(),
                required String summary,
                required DateTime publishedAt,
                Value<DateTime?> expiredAt = const Value.absent(),
                required String actionType,
                Value<String?> actionLink = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => NotificationsCompanion.insert(
                id: id,
                notificationType: notificationType,
                title: title,
                tagText: tagText,
                summary: summary,
                publishedAt: publishedAt,
                expiredAt: expiredAt,
                actionType: actionType,
                actionLink: actionLink,
                isRead: isRead,
                readAt: readAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationsTable,
      Notification,
      $$NotificationsTableFilterComposer,
      $$NotificationsTableOrderingComposer,
      $$NotificationsTableAnnotationComposer,
      $$NotificationsTableCreateCompanionBuilder,
      $$NotificationsTableUpdateCompanionBuilder,
      (
        Notification,
        BaseReferences<_$AppDatabase, $NotificationsTable, Notification>,
      ),
      Notification,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PointLogsTableTableManager get pointLogs =>
      $$PointLogsTableTableManager(_db, _db.pointLogs);
  $$SitesTableTableManager get sites =>
      $$SitesTableTableManager(_db, _db.sites);
  $$SiteStatusesTableTableManager get siteStatuses =>
      $$SiteStatusesTableTableManager(_db, _db.siteStatuses);
  $$BrandsTableTableManager get brands =>
      $$BrandsTableTableManager(_db, _db.brands);
  $$CouponRulesTableTableManager get couponRules =>
      $$CouponRulesTableTableManager(_db, _db.couponRules);
  $$CouponRuleStatusesTableTableManager get couponRuleStatuses =>
      $$CouponRuleStatusesTableTableManager(_db, _db.couponRuleStatuses);
  $$CarouselsTableTableManager get carousels =>
      $$CarouselsTableTableManager(_db, _db.carousels);
  $$MemberCouponsTableTableManager get memberCoupons =>
      $$MemberCouponsTableTableManager(_db, _db.memberCoupons);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
}
