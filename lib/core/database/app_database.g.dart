// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawTextMeta = const VerificationMeta(
    'rawText',
  );
  @override
  late final GeneratedColumn<String> rawText = GeneratedColumn<String>(
    'raw_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, rawText, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('raw_text')) {
      context.handle(
        _rawTextMeta,
        rawText.isAcceptableOrUnknown(data['raw_text']!, _rawTextMeta),
      );
    } else if (isInserting) {
      context.missing(_rawTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      rawText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final int id;
  final String name;
  final String rawText;
  final DateTime createdAt;
  const Routine({
    required this.id,
    required this.name,
    required this.rawText,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['raw_text'] = Variable<String>(rawText);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      rawText: Value(rawText),
      createdAt: Value(createdAt),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      rawText: serializer.fromJson<String>(json['rawText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'rawText': serializer.toJson<String>(rawText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Routine copyWith({
    int? id,
    String? name,
    String? rawText,
    DateTime? createdAt,
  }) => Routine(
    id: id ?? this.id,
    name: name ?? this.name,
    rawText: rawText ?? this.rawText,
    createdAt: createdAt ?? this.createdAt,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      rawText: data.rawText.present ? data.rawText.value : this.rawText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rawText: $rawText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, rawText, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.name == this.name &&
          other.rawText == this.rawText &&
          other.createdAt == this.createdAt);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> rawText;
  final Value<DateTime> createdAt;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rawText = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String rawText,
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       rawText = Value(rawText);
  static Insertable<Routine> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? rawText,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rawText != null) 'raw_text': rawText,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RoutinesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? rawText,
    Value<DateTime>? createdAt,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rawText: rawText ?? this.rawText,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rawText.present) {
      map['raw_text'] = Variable<String>(rawText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rawText: $rawText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('strength'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, notes, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final int id;
  final DateTime date;
  final String? notes;
  final String type;
  const WorkoutSession({
    required this.id,
    required this.date,
    this.notes,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['type'] = Variable<String>(type);
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      date: Value(date),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      type: Value(type),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'notes': serializer.toJson<String?>(notes),
      'type': serializer.toJson<String>(type),
    };
  }

  WorkoutSession copyWith({
    int? id,
    DateTime? date,
    Value<String?> notes = const Value.absent(),
    String? type,
  }) => WorkoutSession(
    id: id ?? this.id,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
    type: type ?? this.type,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, notes, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.type == this.type);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String?> notes;
  final Value<String> type;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.type = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    this.notes = const Value.absent(),
    this.type = const Value.absent(),
  }) : date = Value(date);
  static Insertable<WorkoutSession> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? notes,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (type != null) 'type': type,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String?>? notes,
    Value<String>? type,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id)',
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
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _muscleGroupMeta = const VerificationMeta(
    'muscleGroup',
  );
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
    'muscle_group',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    name,
    orderIndex,
    restSeconds,
    muscleGroup,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
        _muscleGroupMeta,
        muscleGroup.isAcceptableOrUnknown(
          data['muscle_group']!,
          _muscleGroupMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      ),
      muscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_group'],
      ),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final int sessionId;
  final String name;
  final int orderIndex;
  final int? restSeconds;
  final String? muscleGroup;
  const Exercise({
    required this.id,
    required this.sessionId,
    required this.name,
    required this.orderIndex,
    this.restSeconds,
    this.muscleGroup,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['name'] = Variable<String>(name);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || restSeconds != null) {
      map['rest_seconds'] = Variable<int>(restSeconds);
    }
    if (!nullToAbsent || muscleGroup != null) {
      map['muscle_group'] = Variable<String>(muscleGroup);
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      name: Value(name),
      orderIndex: Value(orderIndex),
      restSeconds: restSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restSeconds),
      muscleGroup: muscleGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleGroup),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      name: serializer.fromJson<String>(json['name']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      restSeconds: serializer.fromJson<int?>(json['restSeconds']),
      muscleGroup: serializer.fromJson<String?>(json['muscleGroup']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'name': serializer.toJson<String>(name),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'restSeconds': serializer.toJson<int?>(restSeconds),
      'muscleGroup': serializer.toJson<String?>(muscleGroup),
    };
  }

  Exercise copyWith({
    int? id,
    int? sessionId,
    String? name,
    int? orderIndex,
    Value<int?> restSeconds = const Value.absent(),
    Value<String?> muscleGroup = const Value.absent(),
  }) => Exercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    name: name ?? this.name,
    orderIndex: orderIndex ?? this.orderIndex,
    restSeconds: restSeconds.present ? restSeconds.value : this.restSeconds,
    muscleGroup: muscleGroup.present ? muscleGroup.value : this.muscleGroup,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      name: data.name.present ? data.name.value : this.name,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      muscleGroup: data.muscleGroup.present
          ? data.muscleGroup.value
          : this.muscleGroup,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('muscleGroup: $muscleGroup')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, name, orderIndex, restSeconds, muscleGroup);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.name == this.name &&
          other.orderIndex == this.orderIndex &&
          other.restSeconds == this.restSeconds &&
          other.muscleGroup == this.muscleGroup);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> name;
  final Value<int> orderIndex;
  final Value<int?> restSeconds;
  final Value<String?> muscleGroup;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.name = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.muscleGroup = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String name,
    required int orderIndex,
    this.restSeconds = const Value.absent(),
    this.muscleGroup = const Value.absent(),
  }) : sessionId = Value(sessionId),
       name = Value(name),
       orderIndex = Value(orderIndex);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? name,
    Expression<int>? orderIndex,
    Expression<int>? restSeconds,
    Expression<String>? muscleGroup,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (name != null) 'name': name,
      if (orderIndex != null) 'order_index': orderIndex,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? name,
    Value<int>? orderIndex,
    Value<int?>? restSeconds,
    Value<String?>? muscleGroup,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
      restSeconds: restSeconds ?? this.restSeconds,
      muscleGroup: muscleGroup ?? this.muscleGroup,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('muscleGroup: $muscleGroup')
          ..write(')'))
        .toString();
  }
}

class $SetsTable extends Sets with TableInfo<$SetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toFailureMeta = const VerificationMeta(
    'toFailure',
  );
  @override
  late final GeneratedColumn<bool> toFailure = GeneratedColumn<bool>(
    'to_failure',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("to_failure" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPartialMeta = const VerificationMeta(
    'isPartial',
  );
  @override
  late final GeneratedColumn<bool> isPartial = GeneratedColumn<bool>(
    'is_partial',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_partial" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseId,
    setNumber,
    reps,
    weight,
    toFailure,
    isPartial,
    isDone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('to_failure')) {
      context.handle(
        _toFailureMeta,
        toFailure.isAcceptableOrUnknown(data['to_failure']!, _toFailureMeta),
      );
    }
    if (data.containsKey('is_partial')) {
      context.handle(
        _isPartialMeta,
        isPartial.isAcceptableOrUnknown(data['is_partial']!, _isPartialMeta),
      );
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      toFailure: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}to_failure'],
      )!,
      isPartial: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_partial'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
    );
  }

  @override
  $SetsTable createAlias(String alias) {
    return $SetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final int id;
  final int exerciseId;
  final int setNumber;
  final int? reps;
  final double? weight;
  final bool toFailure;
  final bool isPartial;
  final bool isDone;
  const WorkoutSet({
    required this.id,
    required this.exerciseId,
    required this.setNumber,
    this.reps,
    this.weight,
    required this.toFailure,
    required this.isPartial,
    required this.isDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    map['to_failure'] = Variable<bool>(toFailure);
    map['is_partial'] = Variable<bool>(isPartial);
    map['is_done'] = Variable<bool>(isDone);
    return map;
  }

  SetsCompanion toCompanion(bool nullToAbsent) {
    return SetsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      setNumber: Value(setNumber),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      toFailure: Value(toFailure),
      isPartial: Value(isPartial),
      isDone: Value(isDone),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<int>(json['id']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      reps: serializer.fromJson<int?>(json['reps']),
      weight: serializer.fromJson<double?>(json['weight']),
      toFailure: serializer.fromJson<bool>(json['toFailure']),
      isPartial: serializer.fromJson<bool>(json['isPartial']),
      isDone: serializer.fromJson<bool>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'reps': serializer.toJson<int?>(reps),
      'weight': serializer.toJson<double?>(weight),
      'toFailure': serializer.toJson<bool>(toFailure),
      'isPartial': serializer.toJson<bool>(isPartial),
      'isDone': serializer.toJson<bool>(isDone),
    };
  }

  WorkoutSet copyWith({
    int? id,
    int? exerciseId,
    int? setNumber,
    Value<int?> reps = const Value.absent(),
    Value<double?> weight = const Value.absent(),
    bool? toFailure,
    bool? isPartial,
    bool? isDone,
  }) => WorkoutSet(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    setNumber: setNumber ?? this.setNumber,
    reps: reps.present ? reps.value : this.reps,
    weight: weight.present ? weight.value : this.weight,
    toFailure: toFailure ?? this.toFailure,
    isPartial: isPartial ?? this.isPartial,
    isDone: isDone ?? this.isDone,
  );
  WorkoutSet copyWithCompanion(SetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      reps: data.reps.present ? data.reps.value : this.reps,
      weight: data.weight.present ? data.weight.value : this.weight,
      toFailure: data.toFailure.present ? data.toFailure.value : this.toFailure,
      isPartial: data.isPartial.present ? data.isPartial.value : this.isPartial,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('toFailure: $toFailure, ')
          ..write('isPartial: $isPartial, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseId,
    setNumber,
    reps,
    weight,
    toFailure,
    isPartial,
    isDone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.setNumber == this.setNumber &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.toFailure == this.toFailure &&
          other.isPartial == this.isPartial &&
          other.isDone == this.isDone);
}

class SetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<int> id;
  final Value<int> exerciseId;
  final Value<int> setNumber;
  final Value<int?> reps;
  final Value<double?> weight;
  final Value<bool> toFailure;
  final Value<bool> isPartial;
  final Value<bool> isDone;
  const SetsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.toFailure = const Value.absent(),
    this.isPartial = const Value.absent(),
    this.isDone = const Value.absent(),
  });
  SetsCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseId,
    required int setNumber,
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.toFailure = const Value.absent(),
    this.isPartial = const Value.absent(),
    this.isDone = const Value.absent(),
  }) : exerciseId = Value(exerciseId),
       setNumber = Value(setNumber);
  static Insertable<WorkoutSet> custom({
    Expression<int>? id,
    Expression<int>? exerciseId,
    Expression<int>? setNumber,
    Expression<int>? reps,
    Expression<double>? weight,
    Expression<bool>? toFailure,
    Expression<bool>? isPartial,
    Expression<bool>? isDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (reps != null) 'reps': reps,
      if (weight != null) 'weight': weight,
      if (toFailure != null) 'to_failure': toFailure,
      if (isPartial != null) 'is_partial': isPartial,
      if (isDone != null) 'is_done': isDone,
    });
  }

  SetsCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseId,
    Value<int>? setNumber,
    Value<int?>? reps,
    Value<double?>? weight,
    Value<bool>? toFailure,
    Value<bool>? isPartial,
    Value<bool>? isDone,
  }) {
    return SetsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      toFailure: toFailure ?? this.toFailure,
      isPartial: isPartial ?? this.isPartial,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (toFailure.present) {
      map['to_failure'] = Variable<bool>(toFailure.value);
    }
    if (isPartial.present) {
      map['is_partial'] = Variable<bool>(isPartial.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('toFailure: $toFailure, ')
          ..write('isPartial: $isPartial, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }
}

class $HiitCircuitsTable extends HiitCircuits
    with TableInfo<$HiitCircuitsTable, HiitCircuit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HiitCircuitsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id)',
    ),
  );
  static const VerificationMeta _letterMeta = const VerificationMeta('letter');
  @override
  late final GeneratedColumn<String> letter = GeneratedColumn<String>(
    'letter',
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
  static const VerificationMeta _roundsMeta = const VerificationMeta('rounds');
  @override
  late final GeneratedColumn<int> rounds = GeneratedColumn<int>(
    'rounds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restBetweenRoundsSecMeta =
      const VerificationMeta('restBetweenRoundsSec');
  @override
  late final GeneratedColumn<int> restBetweenRoundsSec = GeneratedColumn<int>(
    'rest_between_rounds_sec',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restBetweenExercisesSecMeta =
      const VerificationMeta('restBetweenExercisesSec');
  @override
  late final GeneratedColumn<int> restBetweenExercisesSec =
      GeneratedColumn<int>(
        'rest_between_exercises_sec',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    letter,
    name,
    rounds,
    restBetweenRoundsSec,
    restBetweenExercisesSec,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hiit_circuits';
  @override
  VerificationContext validateIntegrity(
    Insertable<HiitCircuit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('letter')) {
      context.handle(
        _letterMeta,
        letter.isAcceptableOrUnknown(data['letter']!, _letterMeta),
      );
    } else if (isInserting) {
      context.missing(_letterMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('rounds')) {
      context.handle(
        _roundsMeta,
        rounds.isAcceptableOrUnknown(data['rounds']!, _roundsMeta),
      );
    } else if (isInserting) {
      context.missing(_roundsMeta);
    }
    if (data.containsKey('rest_between_rounds_sec')) {
      context.handle(
        _restBetweenRoundsSecMeta,
        restBetweenRoundsSec.isAcceptableOrUnknown(
          data['rest_between_rounds_sec']!,
          _restBetweenRoundsSecMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restBetweenRoundsSecMeta);
    }
    if (data.containsKey('rest_between_exercises_sec')) {
      context.handle(
        _restBetweenExercisesSecMeta,
        restBetweenExercisesSec.isAcceptableOrUnknown(
          data['rest_between_exercises_sec']!,
          _restBetweenExercisesSecMeta,
        ),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HiitCircuit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HiitCircuit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      letter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}letter'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      rounds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rounds'],
      )!,
      restBetweenRoundsSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_between_rounds_sec'],
      )!,
      restBetweenExercisesSec: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_between_exercises_sec'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $HiitCircuitsTable createAlias(String alias) {
    return $HiitCircuitsTable(attachedDatabase, alias);
  }
}

class HiitCircuit extends DataClass implements Insertable<HiitCircuit> {
  final int id;
  final int sessionId;
  final String letter;
  final String name;
  final int rounds;
  final int restBetweenRoundsSec;
  final int? restBetweenExercisesSec;
  final int orderIndex;
  const HiitCircuit({
    required this.id,
    required this.sessionId,
    required this.letter,
    required this.name,
    required this.rounds,
    required this.restBetweenRoundsSec,
    this.restBetweenExercisesSec,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['letter'] = Variable<String>(letter);
    map['name'] = Variable<String>(name);
    map['rounds'] = Variable<int>(rounds);
    map['rest_between_rounds_sec'] = Variable<int>(restBetweenRoundsSec);
    if (!nullToAbsent || restBetweenExercisesSec != null) {
      map['rest_between_exercises_sec'] = Variable<int>(
        restBetweenExercisesSec,
      );
    }
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  HiitCircuitsCompanion toCompanion(bool nullToAbsent) {
    return HiitCircuitsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      letter: Value(letter),
      name: Value(name),
      rounds: Value(rounds),
      restBetweenRoundsSec: Value(restBetweenRoundsSec),
      restBetweenExercisesSec: restBetweenExercisesSec == null && nullToAbsent
          ? const Value.absent()
          : Value(restBetweenExercisesSec),
      orderIndex: Value(orderIndex),
    );
  }

  factory HiitCircuit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HiitCircuit(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      letter: serializer.fromJson<String>(json['letter']),
      name: serializer.fromJson<String>(json['name']),
      rounds: serializer.fromJson<int>(json['rounds']),
      restBetweenRoundsSec: serializer.fromJson<int>(
        json['restBetweenRoundsSec'],
      ),
      restBetweenExercisesSec: serializer.fromJson<int?>(
        json['restBetweenExercisesSec'],
      ),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'letter': serializer.toJson<String>(letter),
      'name': serializer.toJson<String>(name),
      'rounds': serializer.toJson<int>(rounds),
      'restBetweenRoundsSec': serializer.toJson<int>(restBetweenRoundsSec),
      'restBetweenExercisesSec': serializer.toJson<int?>(
        restBetweenExercisesSec,
      ),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  HiitCircuit copyWith({
    int? id,
    int? sessionId,
    String? letter,
    String? name,
    int? rounds,
    int? restBetweenRoundsSec,
    Value<int?> restBetweenExercisesSec = const Value.absent(),
    int? orderIndex,
  }) => HiitCircuit(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    letter: letter ?? this.letter,
    name: name ?? this.name,
    rounds: rounds ?? this.rounds,
    restBetweenRoundsSec: restBetweenRoundsSec ?? this.restBetweenRoundsSec,
    restBetweenExercisesSec: restBetweenExercisesSec.present
        ? restBetweenExercisesSec.value
        : this.restBetweenExercisesSec,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  HiitCircuit copyWithCompanion(HiitCircuitsCompanion data) {
    return HiitCircuit(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      letter: data.letter.present ? data.letter.value : this.letter,
      name: data.name.present ? data.name.value : this.name,
      rounds: data.rounds.present ? data.rounds.value : this.rounds,
      restBetweenRoundsSec: data.restBetweenRoundsSec.present
          ? data.restBetweenRoundsSec.value
          : this.restBetweenRoundsSec,
      restBetweenExercisesSec: data.restBetweenExercisesSec.present
          ? data.restBetweenExercisesSec.value
          : this.restBetweenExercisesSec,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HiitCircuit(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('letter: $letter, ')
          ..write('name: $name, ')
          ..write('rounds: $rounds, ')
          ..write('restBetweenRoundsSec: $restBetweenRoundsSec, ')
          ..write('restBetweenExercisesSec: $restBetweenExercisesSec, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    letter,
    name,
    rounds,
    restBetweenRoundsSec,
    restBetweenExercisesSec,
    orderIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HiitCircuit &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.letter == this.letter &&
          other.name == this.name &&
          other.rounds == this.rounds &&
          other.restBetweenRoundsSec == this.restBetweenRoundsSec &&
          other.restBetweenExercisesSec == this.restBetweenExercisesSec &&
          other.orderIndex == this.orderIndex);
}

class HiitCircuitsCompanion extends UpdateCompanion<HiitCircuit> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> letter;
  final Value<String> name;
  final Value<int> rounds;
  final Value<int> restBetweenRoundsSec;
  final Value<int?> restBetweenExercisesSec;
  final Value<int> orderIndex;
  const HiitCircuitsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.letter = const Value.absent(),
    this.name = const Value.absent(),
    this.rounds = const Value.absent(),
    this.restBetweenRoundsSec = const Value.absent(),
    this.restBetweenExercisesSec = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  HiitCircuitsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String letter,
    required String name,
    required int rounds,
    required int restBetweenRoundsSec,
    this.restBetweenExercisesSec = const Value.absent(),
    required int orderIndex,
  }) : sessionId = Value(sessionId),
       letter = Value(letter),
       name = Value(name),
       rounds = Value(rounds),
       restBetweenRoundsSec = Value(restBetweenRoundsSec),
       orderIndex = Value(orderIndex);
  static Insertable<HiitCircuit> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? letter,
    Expression<String>? name,
    Expression<int>? rounds,
    Expression<int>? restBetweenRoundsSec,
    Expression<int>? restBetweenExercisesSec,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (letter != null) 'letter': letter,
      if (name != null) 'name': name,
      if (rounds != null) 'rounds': rounds,
      if (restBetweenRoundsSec != null)
        'rest_between_rounds_sec': restBetweenRoundsSec,
      if (restBetweenExercisesSec != null)
        'rest_between_exercises_sec': restBetweenExercisesSec,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  HiitCircuitsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? letter,
    Value<String>? name,
    Value<int>? rounds,
    Value<int>? restBetweenRoundsSec,
    Value<int?>? restBetweenExercisesSec,
    Value<int>? orderIndex,
  }) {
    return HiitCircuitsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      letter: letter ?? this.letter,
      name: name ?? this.name,
      rounds: rounds ?? this.rounds,
      restBetweenRoundsSec: restBetweenRoundsSec ?? this.restBetweenRoundsSec,
      restBetweenExercisesSec:
          restBetweenExercisesSec ?? this.restBetweenExercisesSec,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (letter.present) {
      map['letter'] = Variable<String>(letter.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rounds.present) {
      map['rounds'] = Variable<int>(rounds.value);
    }
    if (restBetweenRoundsSec.present) {
      map['rest_between_rounds_sec'] = Variable<int>(
        restBetweenRoundsSec.value,
      );
    }
    if (restBetweenExercisesSec.present) {
      map['rest_between_exercises_sec'] = Variable<int>(
        restBetweenExercisesSec.value,
      );
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HiitCircuitsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('letter: $letter, ')
          ..write('name: $name, ')
          ..write('rounds: $rounds, ')
          ..write('restBetweenRoundsSec: $restBetweenRoundsSec, ')
          ..write('restBetweenExercisesSec: $restBetweenExercisesSec, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $HiitExercisesTable extends HiitExercises
    with TableInfo<$HiitExercisesTable, HiitExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HiitExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _circuitIdMeta = const VerificationMeta(
    'circuitId',
  );
  @override
  late final GeneratedColumn<int> circuitId = GeneratedColumn<int>(
    'circuit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hiit_circuits (id)',
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    circuitId,
    name,
    type,
    value,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hiit_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<HiitExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('circuit_id')) {
      context.handle(
        _circuitIdMeta,
        circuitId.isAcceptableOrUnknown(data['circuit_id']!, _circuitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_circuitIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HiitExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HiitExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      circuitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}circuit_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $HiitExercisesTable createAlias(String alias) {
    return $HiitExercisesTable(attachedDatabase, alias);
  }
}

class HiitExercise extends DataClass implements Insertable<HiitExercise> {
  final int id;
  final int circuitId;
  final String name;
  final String type;
  final int value;
  final int orderIndex;
  const HiitExercise({
    required this.id,
    required this.circuitId,
    required this.name,
    required this.type,
    required this.value,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['circuit_id'] = Variable<int>(circuitId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<int>(value);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  HiitExercisesCompanion toCompanion(bool nullToAbsent) {
    return HiitExercisesCompanion(
      id: Value(id),
      circuitId: Value(circuitId),
      name: Value(name),
      type: Value(type),
      value: Value(value),
      orderIndex: Value(orderIndex),
    );
  }

  factory HiitExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HiitExercise(
      id: serializer.fromJson<int>(json['id']),
      circuitId: serializer.fromJson<int>(json['circuitId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<int>(json['value']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'circuitId': serializer.toJson<int>(circuitId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<int>(value),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  HiitExercise copyWith({
    int? id,
    int? circuitId,
    String? name,
    String? type,
    int? value,
    int? orderIndex,
  }) => HiitExercise(
    id: id ?? this.id,
    circuitId: circuitId ?? this.circuitId,
    name: name ?? this.name,
    type: type ?? this.type,
    value: value ?? this.value,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  HiitExercise copyWithCompanion(HiitExercisesCompanion data) {
    return HiitExercise(
      id: data.id.present ? data.id.value : this.id,
      circuitId: data.circuitId.present ? data.circuitId.value : this.circuitId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HiitExercise(')
          ..write('id: $id, ')
          ..write('circuitId: $circuitId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, circuitId, name, type, value, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HiitExercise &&
          other.id == this.id &&
          other.circuitId == this.circuitId &&
          other.name == this.name &&
          other.type == this.type &&
          other.value == this.value &&
          other.orderIndex == this.orderIndex);
}

class HiitExercisesCompanion extends UpdateCompanion<HiitExercise> {
  final Value<int> id;
  final Value<int> circuitId;
  final Value<String> name;
  final Value<String> type;
  final Value<int> value;
  final Value<int> orderIndex;
  const HiitExercisesCompanion({
    this.id = const Value.absent(),
    this.circuitId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  HiitExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int circuitId,
    required String name,
    required String type,
    required int value,
    required int orderIndex,
  }) : circuitId = Value(circuitId),
       name = Value(name),
       type = Value(type),
       value = Value(value),
       orderIndex = Value(orderIndex);
  static Insertable<HiitExercise> custom({
    Expression<int>? id,
    Expression<int>? circuitId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? value,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (circuitId != null) 'circuit_id': circuitId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  HiitExercisesCompanion copyWith({
    Value<int>? id,
    Value<int>? circuitId,
    Value<String>? name,
    Value<String>? type,
    Value<int>? value,
    Value<int>? orderIndex,
  }) {
    return HiitExercisesCompanion(
      id: id ?? this.id,
      circuitId: circuitId ?? this.circuitId,
      name: name ?? this.name,
      type: type ?? this.type,
      value: value ?? this.value,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (circuitId.present) {
      map['circuit_id'] = Variable<int>(circuitId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HiitExercisesCompanion(')
          ..write('id: $id, ')
          ..write('circuitId: $circuitId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $HiitWorkoutLogsTable extends HiitWorkoutLogs
    with TableInfo<$HiitWorkoutLogsTable, HiitWorkoutLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HiitWorkoutLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_sessions (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, startedAt, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hiit_workout_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<HiitWorkoutLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HiitWorkoutLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HiitWorkoutLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $HiitWorkoutLogsTable createAlias(String alias) {
    return $HiitWorkoutLogsTable(attachedDatabase, alias);
  }
}

class HiitWorkoutLog extends DataClass implements Insertable<HiitWorkoutLog> {
  final int id;
  final int sessionId;
  final DateTime startedAt;
  final DateTime? completedAt;
  const HiitWorkoutLog({
    required this.id,
    required this.sessionId,
    required this.startedAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  HiitWorkoutLogsCompanion toCompanion(bool nullToAbsent) {
    return HiitWorkoutLogsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory HiitWorkoutLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HiitWorkoutLog(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  HiitWorkoutLog copyWith({
    int? id,
    int? sessionId,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => HiitWorkoutLog(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  HiitWorkoutLog copyWithCompanion(HiitWorkoutLogsCompanion data) {
    return HiitWorkoutLog(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HiitWorkoutLog(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, startedAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HiitWorkoutLog &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt);
}

class HiitWorkoutLogsCompanion extends UpdateCompanion<HiitWorkoutLog> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  const HiitWorkoutLogsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  HiitWorkoutLogsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       startedAt = Value(startedAt);
  static Insertable<HiitWorkoutLog> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  HiitWorkoutLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
  }) {
    return HiitWorkoutLogsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HiitWorkoutLogsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $HiitExerciseLogsTable extends HiitExerciseLogs
    with TableInfo<$HiitExerciseLogsTable, HiitExerciseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HiitExerciseLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _workoutLogIdMeta = const VerificationMeta(
    'workoutLogId',
  );
  @override
  late final GeneratedColumn<int> workoutLogId = GeneratedColumn<int>(
    'workout_log_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hiit_workout_logs (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hiit_exercises (id)',
    ),
  );
  static const VerificationMeta _roundMeta = const VerificationMeta('round');
  @override
  late final GeneratedColumn<int> round = GeneratedColumn<int>(
    'round',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualValueMeta = const VerificationMeta(
    'actualValue',
  );
  @override
  late final GeneratedColumn<int> actualValue = GeneratedColumn<int>(
    'actual_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutLogId,
    exerciseId,
    round,
    actualValue,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hiit_exercise_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<HiitExerciseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_log_id')) {
      context.handle(
        _workoutLogIdMeta,
        workoutLogId.isAcceptableOrUnknown(
          data['workout_log_id']!,
          _workoutLogIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutLogIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('round')) {
      context.handle(
        _roundMeta,
        round.isAcceptableOrUnknown(data['round']!, _roundMeta),
      );
    } else if (isInserting) {
      context.missing(_roundMeta);
    }
    if (data.containsKey('actual_value')) {
      context.handle(
        _actualValueMeta,
        actualValue.isAcceptableOrUnknown(
          data['actual_value']!,
          _actualValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualValueMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HiitExerciseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HiitExerciseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workoutLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workout_log_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      round: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}round'],
      )!,
      actualValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_value'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $HiitExerciseLogsTable createAlias(String alias) {
    return $HiitExerciseLogsTable(attachedDatabase, alias);
  }
}

class HiitExerciseLog extends DataClass implements Insertable<HiitExerciseLog> {
  final int id;
  final int workoutLogId;
  final int exerciseId;
  final int round;
  final int actualValue;
  final DateTime completedAt;
  const HiitExerciseLog({
    required this.id,
    required this.workoutLogId,
    required this.exerciseId,
    required this.round,
    required this.actualValue,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_log_id'] = Variable<int>(workoutLogId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['round'] = Variable<int>(round);
    map['actual_value'] = Variable<int>(actualValue);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  HiitExerciseLogsCompanion toCompanion(bool nullToAbsent) {
    return HiitExerciseLogsCompanion(
      id: Value(id),
      workoutLogId: Value(workoutLogId),
      exerciseId: Value(exerciseId),
      round: Value(round),
      actualValue: Value(actualValue),
      completedAt: Value(completedAt),
    );
  }

  factory HiitExerciseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HiitExerciseLog(
      id: serializer.fromJson<int>(json['id']),
      workoutLogId: serializer.fromJson<int>(json['workoutLogId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      round: serializer.fromJson<int>(json['round']),
      actualValue: serializer.fromJson<int>(json['actualValue']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutLogId': serializer.toJson<int>(workoutLogId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'round': serializer.toJson<int>(round),
      'actualValue': serializer.toJson<int>(actualValue),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  HiitExerciseLog copyWith({
    int? id,
    int? workoutLogId,
    int? exerciseId,
    int? round,
    int? actualValue,
    DateTime? completedAt,
  }) => HiitExerciseLog(
    id: id ?? this.id,
    workoutLogId: workoutLogId ?? this.workoutLogId,
    exerciseId: exerciseId ?? this.exerciseId,
    round: round ?? this.round,
    actualValue: actualValue ?? this.actualValue,
    completedAt: completedAt ?? this.completedAt,
  );
  HiitExerciseLog copyWithCompanion(HiitExerciseLogsCompanion data) {
    return HiitExerciseLog(
      id: data.id.present ? data.id.value : this.id,
      workoutLogId: data.workoutLogId.present
          ? data.workoutLogId.value
          : this.workoutLogId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      round: data.round.present ? data.round.value : this.round,
      actualValue: data.actualValue.present
          ? data.actualValue.value
          : this.actualValue,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HiitExerciseLog(')
          ..write('id: $id, ')
          ..write('workoutLogId: $workoutLogId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('round: $round, ')
          ..write('actualValue: $actualValue, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutLogId,
    exerciseId,
    round,
    actualValue,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HiitExerciseLog &&
          other.id == this.id &&
          other.workoutLogId == this.workoutLogId &&
          other.exerciseId == this.exerciseId &&
          other.round == this.round &&
          other.actualValue == this.actualValue &&
          other.completedAt == this.completedAt);
}

class HiitExerciseLogsCompanion extends UpdateCompanion<HiitExerciseLog> {
  final Value<int> id;
  final Value<int> workoutLogId;
  final Value<int> exerciseId;
  final Value<int> round;
  final Value<int> actualValue;
  final Value<DateTime> completedAt;
  const HiitExerciseLogsCompanion({
    this.id = const Value.absent(),
    this.workoutLogId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.round = const Value.absent(),
    this.actualValue = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  HiitExerciseLogsCompanion.insert({
    this.id = const Value.absent(),
    required int workoutLogId,
    required int exerciseId,
    required int round,
    required int actualValue,
    required DateTime completedAt,
  }) : workoutLogId = Value(workoutLogId),
       exerciseId = Value(exerciseId),
       round = Value(round),
       actualValue = Value(actualValue),
       completedAt = Value(completedAt);
  static Insertable<HiitExerciseLog> custom({
    Expression<int>? id,
    Expression<int>? workoutLogId,
    Expression<int>? exerciseId,
    Expression<int>? round,
    Expression<int>? actualValue,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutLogId != null) 'workout_log_id': workoutLogId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (round != null) 'round': round,
      if (actualValue != null) 'actual_value': actualValue,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  HiitExerciseLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutLogId,
    Value<int>? exerciseId,
    Value<int>? round,
    Value<int>? actualValue,
    Value<DateTime>? completedAt,
  }) {
    return HiitExerciseLogsCompanion(
      id: id ?? this.id,
      workoutLogId: workoutLogId ?? this.workoutLogId,
      exerciseId: exerciseId ?? this.exerciseId,
      round: round ?? this.round,
      actualValue: actualValue ?? this.actualValue,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutLogId.present) {
      map['workout_log_id'] = Variable<int>(workoutLogId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (round.present) {
      map['round'] = Variable<int>(round.value);
    }
    if (actualValue.present) {
      map['actual_value'] = Variable<int>(actualValue.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HiitExerciseLogsCompanion(')
          ..write('id: $id, ')
          ..write('workoutLogId: $workoutLogId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('round: $round, ')
          ..write('actualValue: $actualValue, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $SetsTable sets = $SetsTable(this);
  late final $HiitCircuitsTable hiitCircuits = $HiitCircuitsTable(this);
  late final $HiitExercisesTable hiitExercises = $HiitExercisesTable(this);
  late final $HiitWorkoutLogsTable hiitWorkoutLogs = $HiitWorkoutLogsTable(
    this,
  );
  late final $HiitExerciseLogsTable hiitExerciseLogs = $HiitExerciseLogsTable(
    this,
  );
  late final RoutinesDao routinesDao = RoutinesDao(this as AppDatabase);
  late final SessionsDao sessionsDao = SessionsDao(this as AppDatabase);
  late final ExercisesDao exercisesDao = ExercisesDao(this as AppDatabase);
  late final SetsDao setsDao = SetsDao(this as AppDatabase);
  late final HiitCircuitsDao hiitCircuitsDao = HiitCircuitsDao(
    this as AppDatabase,
  );
  late final HiitExercisesDao hiitExercisesDao = HiitExercisesDao(
    this as AppDatabase,
  );
  late final HiitWorkoutLogsDao hiitWorkoutLogsDao = HiitWorkoutLogsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    routines,
    workoutSessions,
    exercises,
    sets,
    hiitCircuits,
    hiitExercises,
    hiitWorkoutLogs,
    hiitExerciseLogs,
  ];
}

typedef $$RoutinesTableCreateCompanionBuilder =
    RoutinesCompanion Function({
      Value<int> id,
      required String name,
      required String rawText,
      Value<DateTime> createdAt,
    });
typedef $$RoutinesTableUpdateCompanionBuilder =
    RoutinesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> rawText,
      Value<DateTime> createdAt,
    });

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawText => $composableBuilder(
    column: $table.rawText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get rawText =>
      $composableBuilder(column: $table.rawText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
          Routine,
          PrefetchHooks Function()
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> rawText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                name: name,
                rawText: rawText,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String rawText,
                Value<DateTime> createdAt = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                name: name,
                rawText: rawText,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
      Routine,
      PrefetchHooks Function()
    >;
typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      required DateTime date,
      Value<String?> notes,
      Value<String> type,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String?> notes,
      Value<String> type,
    });

final class $$WorkoutSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExercisesTable, List<Exercise>>
  _exercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exercises,
    aliasName: $_aliasNameGenerator(
      db.workoutSessions.id,
      db.exercises.sessionId,
    ),
  );

  $$ExercisesTableProcessedTableManager get exercisesRefs {
    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exercisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HiitCircuitsTable, List<HiitCircuit>>
  _hiitCircuitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.hiitCircuits,
    aliasName: $_aliasNameGenerator(
      db.workoutSessions.id,
      db.hiitCircuits.sessionId,
    ),
  );

  $$HiitCircuitsTableProcessedTableManager get hiitCircuitsRefs {
    final manager = $$HiitCircuitsTableTableManager(
      $_db,
      $_db.hiitCircuits,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_hiitCircuitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HiitWorkoutLogsTable, List<HiitWorkoutLog>>
  _hiitWorkoutLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.hiitWorkoutLogs,
    aliasName: $_aliasNameGenerator(
      db.workoutSessions.id,
      db.hiitWorkoutLogs.sessionId,
    ),
  );

  $$HiitWorkoutLogsTableProcessedTableManager get hiitWorkoutLogsRefs {
    final manager = $$HiitWorkoutLogsTableTableManager(
      $_db,
      $_db.hiitWorkoutLogs,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _hiitWorkoutLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exercisesRefs(
    Expression<bool> Function($$ExercisesTableFilterComposer f) f,
  ) {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> hiitCircuitsRefs(
    Expression<bool> Function($$HiitCircuitsTableFilterComposer f) f,
  ) {
    final $$HiitCircuitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitCircuits,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitCircuitsTableFilterComposer(
            $db: $db,
            $table: $db.hiitCircuits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> hiitWorkoutLogsRefs(
    Expression<bool> Function($$HiitWorkoutLogsTableFilterComposer f) f,
  ) {
    final $$HiitWorkoutLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitWorkoutLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitWorkoutLogsTableFilterComposer(
            $db: $db,
            $table: $db.hiitWorkoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  Expression<T> exercisesRefs<T extends Object>(
    Expression<T> Function($$ExercisesTableAnnotationComposer a) f,
  ) {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> hiitCircuitsRefs<T extends Object>(
    Expression<T> Function($$HiitCircuitsTableAnnotationComposer a) f,
  ) {
    final $$HiitCircuitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitCircuits,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitCircuitsTableAnnotationComposer(
            $db: $db,
            $table: $db.hiitCircuits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> hiitWorkoutLogsRefs<T extends Object>(
    Expression<T> Function($$HiitWorkoutLogsTableAnnotationComposer a) f,
  ) {
    final $$HiitWorkoutLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitWorkoutLogs,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitWorkoutLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.hiitWorkoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (WorkoutSession, $$WorkoutSessionsTableReferences),
          WorkoutSession,
          PrefetchHooks Function({
            bool exercisesRefs,
            bool hiitCircuitsRefs,
            bool hiitWorkoutLogsRefs,
          })
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                date: date,
                notes: notes,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                Value<String?> notes = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                date: date,
                notes: notes,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                exercisesRefs = false,
                hiitCircuitsRefs = false,
                hiitWorkoutLogsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (exercisesRefs) db.exercises,
                    if (hiitCircuitsRefs) db.hiitCircuits,
                    if (hiitWorkoutLogsRefs) db.hiitWorkoutLogs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (exercisesRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          Exercise
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._exercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).exercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (hiitCircuitsRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          HiitCircuit
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._hiitCircuitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).hiitCircuitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (hiitWorkoutLogsRefs)
                        await $_getPrefetchedData<
                          WorkoutSession,
                          $WorkoutSessionsTable,
                          HiitWorkoutLog
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutSessionsTableReferences
                              ._hiitWorkoutLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).hiitWorkoutLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
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

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (WorkoutSession, $$WorkoutSessionsTableReferences),
      WorkoutSession,
      PrefetchHooks Function({
        bool exercisesRefs,
        bool hiitCircuitsRefs,
        bool hiitWorkoutLogsRefs,
      })
    >;
typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      required int sessionId,
      required String name,
      required int orderIndex,
      Value<int?> restSeconds,
      Value<String?> muscleGroup,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> name,
      Value<int> orderIndex,
      Value<int?> restSeconds,
      Value<String?> muscleGroup,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.workoutSessions.createAlias(
        $_aliasNameGenerator(db.exercises.sessionId, db.workoutSessions.id),
      );

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SetsTable, List<WorkoutSet>> _setsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sets,
    aliasName: $_aliasNameGenerator(db.exercises.id, db.sets.exerciseId),
  );

  $$SetsTableProcessedTableManager get setsRefs {
    final manager = $$SetsTableTableManager(
      $_db,
      $_db.sets,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> setsRefs(
    Expression<bool> Function($$SetsTableFilterComposer f) f,
  ) {
    final $$SetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetsTableFilterComposer(
            $db: $db,
            $table: $db.sets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> setsRefs<T extends Object>(
    Expression<T> Function($$SetsTableAnnotationComposer a) f,
  ) {
    final $$SetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sets,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetsTableAnnotationComposer(
            $db: $db,
            $table: $db.sets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({bool sessionId, bool setsRefs})
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int?> restSeconds = const Value.absent(),
                Value<String?> muscleGroup = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                sessionId: sessionId,
                name: name,
                orderIndex: orderIndex,
                restSeconds: restSeconds,
                muscleGroup: muscleGroup,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String name,
                required int orderIndex,
                Value<int?> restSeconds = const Value.absent(),
                Value<String?> muscleGroup = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                sessionId: sessionId,
                name: name,
                orderIndex: orderIndex,
                restSeconds: restSeconds,
                muscleGroup: muscleGroup,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, setsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setsRefs) db.sets],
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$ExercisesTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$ExercisesTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setsRefs)
                    await $_getPrefetchedData<
                      Exercise,
                      $ExercisesTable,
                      WorkoutSet
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableReferences
                          ._setsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExercisesTableReferences(db, table, p0).setsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.exerciseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool sessionId, bool setsRefs})
    >;
typedef $$SetsTableCreateCompanionBuilder =
    SetsCompanion Function({
      Value<int> id,
      required int exerciseId,
      required int setNumber,
      Value<int?> reps,
      Value<double?> weight,
      Value<bool> toFailure,
      Value<bool> isPartial,
      Value<bool> isDone,
    });
typedef $$SetsTableUpdateCompanionBuilder =
    SetsCompanion Function({
      Value<int> id,
      Value<int> exerciseId,
      Value<int> setNumber,
      Value<int?> reps,
      Value<double?> weight,
      Value<bool> toFailure,
      Value<bool> isPartial,
      Value<bool> isDone,
    });

final class $$SetsTableReferences
    extends BaseReferences<_$AppDatabase, $SetsTable, WorkoutSet> {
  $$SetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) => db.exercises
      .createAlias($_aliasNameGenerator(db.sets.exerciseId, db.exercises.id));

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetsTableFilterComposer extends Composer<_$AppDatabase, $SetsTable> {
  $$SetsTableFilterComposer({
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

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get toFailure => $composableBuilder(
    column: $table.toFailure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPartial => $composableBuilder(
    column: $table.isPartial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetsTableOrderingComposer extends Composer<_$AppDatabase, $SetsTable> {
  $$SetsTableOrderingComposer({
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

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get toFailure => $composableBuilder(
    column: $table.toFailure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPartial => $composableBuilder(
    column: $table.isPartial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetsTable> {
  $$SetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<bool> get toFailure =>
      $composableBuilder(column: $table.toFailure, builder: (column) => column);

  GeneratedColumn<bool> get isPartial =>
      $composableBuilder(column: $table.isPartial, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetsTable,
          WorkoutSet,
          $$SetsTableFilterComposer,
          $$SetsTableOrderingComposer,
          $$SetsTableAnnotationComposer,
          $$SetsTableCreateCompanionBuilder,
          $$SetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$SetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$SetsTableTableManager(_$AppDatabase db, $SetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<bool> toFailure = const Value.absent(),
                Value<bool> isPartial = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
              }) => SetsCompanion(
                id: id,
                exerciseId: exerciseId,
                setNumber: setNumber,
                reps: reps,
                weight: weight,
                toFailure: toFailure,
                isPartial: isPartial,
                isDone: isDone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseId,
                required int setNumber,
                Value<int?> reps = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<bool> toFailure = const Value.absent(),
                Value<bool> isPartial = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
              }) => SetsCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                setNumber: setNumber,
                reps: reps,
                weight: weight,
                toFailure: toFailure,
                isPartial: isPartial,
                isDone: isDone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SetsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
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
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable: $$SetsTableReferences
                                    ._exerciseIdTable(db),
                                referencedColumn: $$SetsTableReferences
                                    ._exerciseIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$SetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetsTable,
      WorkoutSet,
      $$SetsTableFilterComposer,
      $$SetsTableOrderingComposer,
      $$SetsTableAnnotationComposer,
      $$SetsTableCreateCompanionBuilder,
      $$SetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$SetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({bool exerciseId})
    >;
typedef $$HiitCircuitsTableCreateCompanionBuilder =
    HiitCircuitsCompanion Function({
      Value<int> id,
      required int sessionId,
      required String letter,
      required String name,
      required int rounds,
      required int restBetweenRoundsSec,
      Value<int?> restBetweenExercisesSec,
      required int orderIndex,
    });
typedef $$HiitCircuitsTableUpdateCompanionBuilder =
    HiitCircuitsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<String> letter,
      Value<String> name,
      Value<int> rounds,
      Value<int> restBetweenRoundsSec,
      Value<int?> restBetweenExercisesSec,
      Value<int> orderIndex,
    });

final class $$HiitCircuitsTableReferences
    extends BaseReferences<_$AppDatabase, $HiitCircuitsTable, HiitCircuit> {
  $$HiitCircuitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.workoutSessions.createAlias(
        $_aliasNameGenerator(db.hiitCircuits.sessionId, db.workoutSessions.id),
      );

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HiitExercisesTable, List<HiitExercise>>
  _hiitExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.hiitExercises,
    aliasName: $_aliasNameGenerator(
      db.hiitCircuits.id,
      db.hiitExercises.circuitId,
    ),
  );

  $$HiitExercisesTableProcessedTableManager get hiitExercisesRefs {
    final manager = $$HiitExercisesTableTableManager(
      $_db,
      $_db.hiitExercises,
    ).filter((f) => f.circuitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_hiitExercisesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HiitCircuitsTableFilterComposer
    extends Composer<_$AppDatabase, $HiitCircuitsTable> {
  $$HiitCircuitsTableFilterComposer({
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

  ColumnFilters<String> get letter => $composableBuilder(
    column: $table.letter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rounds => $composableBuilder(
    column: $table.rounds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restBetweenRoundsSec => $composableBuilder(
    column: $table.restBetweenRoundsSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restBetweenExercisesSec => $composableBuilder(
    column: $table.restBetweenExercisesSec,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> hiitExercisesRefs(
    Expression<bool> Function($$HiitExercisesTableFilterComposer f) f,
  ) {
    final $$HiitExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitExercises,
      getReferencedColumn: (t) => t.circuitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitExercisesTableFilterComposer(
            $db: $db,
            $table: $db.hiitExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HiitCircuitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HiitCircuitsTable> {
  $$HiitCircuitsTableOrderingComposer({
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

  ColumnOrderings<String> get letter => $composableBuilder(
    column: $table.letter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rounds => $composableBuilder(
    column: $table.rounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restBetweenRoundsSec => $composableBuilder(
    column: $table.restBetweenRoundsSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restBetweenExercisesSec => $composableBuilder(
    column: $table.restBetweenExercisesSec,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HiitCircuitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HiitCircuitsTable> {
  $$HiitCircuitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get letter =>
      $composableBuilder(column: $table.letter, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get rounds =>
      $composableBuilder(column: $table.rounds, builder: (column) => column);

  GeneratedColumn<int> get restBetweenRoundsSec => $composableBuilder(
    column: $table.restBetweenRoundsSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restBetweenExercisesSec => $composableBuilder(
    column: $table.restBetweenExercisesSec,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> hiitExercisesRefs<T extends Object>(
    Expression<T> Function($$HiitExercisesTableAnnotationComposer a) f,
  ) {
    final $$HiitExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitExercises,
      getReferencedColumn: (t) => t.circuitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.hiitExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HiitCircuitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HiitCircuitsTable,
          HiitCircuit,
          $$HiitCircuitsTableFilterComposer,
          $$HiitCircuitsTableOrderingComposer,
          $$HiitCircuitsTableAnnotationComposer,
          $$HiitCircuitsTableCreateCompanionBuilder,
          $$HiitCircuitsTableUpdateCompanionBuilder,
          (HiitCircuit, $$HiitCircuitsTableReferences),
          HiitCircuit,
          PrefetchHooks Function({bool sessionId, bool hiitExercisesRefs})
        > {
  $$HiitCircuitsTableTableManager(_$AppDatabase db, $HiitCircuitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HiitCircuitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HiitCircuitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HiitCircuitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> letter = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rounds = const Value.absent(),
                Value<int> restBetweenRoundsSec = const Value.absent(),
                Value<int?> restBetweenExercisesSec = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => HiitCircuitsCompanion(
                id: id,
                sessionId: sessionId,
                letter: letter,
                name: name,
                rounds: rounds,
                restBetweenRoundsSec: restBetweenRoundsSec,
                restBetweenExercisesSec: restBetweenExercisesSec,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String letter,
                required String name,
                required int rounds,
                required int restBetweenRoundsSec,
                Value<int?> restBetweenExercisesSec = const Value.absent(),
                required int orderIndex,
              }) => HiitCircuitsCompanion.insert(
                id: id,
                sessionId: sessionId,
                letter: letter,
                name: name,
                rounds: rounds,
                restBetweenRoundsSec: restBetweenRoundsSec,
                restBetweenExercisesSec: restBetweenExercisesSec,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HiitCircuitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, hiitExercisesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (hiitExercisesRefs) db.hiitExercises,
                  ],
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
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$HiitCircuitsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$HiitCircuitsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (hiitExercisesRefs)
                        await $_getPrefetchedData<
                          HiitCircuit,
                          $HiitCircuitsTable,
                          HiitExercise
                        >(
                          currentTable: table,
                          referencedTable: $$HiitCircuitsTableReferences
                              ._hiitExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HiitCircuitsTableReferences(
                                db,
                                table,
                                p0,
                              ).hiitExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.circuitId == item.id,
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

typedef $$HiitCircuitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HiitCircuitsTable,
      HiitCircuit,
      $$HiitCircuitsTableFilterComposer,
      $$HiitCircuitsTableOrderingComposer,
      $$HiitCircuitsTableAnnotationComposer,
      $$HiitCircuitsTableCreateCompanionBuilder,
      $$HiitCircuitsTableUpdateCompanionBuilder,
      (HiitCircuit, $$HiitCircuitsTableReferences),
      HiitCircuit,
      PrefetchHooks Function({bool sessionId, bool hiitExercisesRefs})
    >;
typedef $$HiitExercisesTableCreateCompanionBuilder =
    HiitExercisesCompanion Function({
      Value<int> id,
      required int circuitId,
      required String name,
      required String type,
      required int value,
      required int orderIndex,
    });
typedef $$HiitExercisesTableUpdateCompanionBuilder =
    HiitExercisesCompanion Function({
      Value<int> id,
      Value<int> circuitId,
      Value<String> name,
      Value<String> type,
      Value<int> value,
      Value<int> orderIndex,
    });

final class $$HiitExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $HiitExercisesTable, HiitExercise> {
  $$HiitExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HiitCircuitsTable _circuitIdTable(_$AppDatabase db) =>
      db.hiitCircuits.createAlias(
        $_aliasNameGenerator(db.hiitExercises.circuitId, db.hiitCircuits.id),
      );

  $$HiitCircuitsTableProcessedTableManager get circuitId {
    final $_column = $_itemColumn<int>('circuit_id')!;

    final manager = $$HiitCircuitsTableTableManager(
      $_db,
      $_db.hiitCircuits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_circuitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HiitExerciseLogsTable, List<HiitExerciseLog>>
  _hiitExerciseLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.hiitExerciseLogs,
    aliasName: $_aliasNameGenerator(
      db.hiitExercises.id,
      db.hiitExerciseLogs.exerciseId,
    ),
  );

  $$HiitExerciseLogsTableProcessedTableManager get hiitExerciseLogsRefs {
    final manager = $$HiitExerciseLogsTableTableManager(
      $_db,
      $_db.hiitExerciseLogs,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _hiitExerciseLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HiitExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $HiitExercisesTable> {
  $$HiitExercisesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$HiitCircuitsTableFilterComposer get circuitId {
    final $$HiitCircuitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.circuitId,
      referencedTable: $db.hiitCircuits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitCircuitsTableFilterComposer(
            $db: $db,
            $table: $db.hiitCircuits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> hiitExerciseLogsRefs(
    Expression<bool> Function($$HiitExerciseLogsTableFilterComposer f) f,
  ) {
    final $$HiitExerciseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitExerciseLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitExerciseLogsTableFilterComposer(
            $db: $db,
            $table: $db.hiitExerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HiitExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $HiitExercisesTable> {
  $$HiitExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$HiitCircuitsTableOrderingComposer get circuitId {
    final $$HiitCircuitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.circuitId,
      referencedTable: $db.hiitCircuits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitCircuitsTableOrderingComposer(
            $db: $db,
            $table: $db.hiitCircuits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HiitExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HiitExercisesTable> {
  $$HiitExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$HiitCircuitsTableAnnotationComposer get circuitId {
    final $$HiitCircuitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.circuitId,
      referencedTable: $db.hiitCircuits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitCircuitsTableAnnotationComposer(
            $db: $db,
            $table: $db.hiitCircuits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> hiitExerciseLogsRefs<T extends Object>(
    Expression<T> Function($$HiitExerciseLogsTableAnnotationComposer a) f,
  ) {
    final $$HiitExerciseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitExerciseLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitExerciseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.hiitExerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HiitExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HiitExercisesTable,
          HiitExercise,
          $$HiitExercisesTableFilterComposer,
          $$HiitExercisesTableOrderingComposer,
          $$HiitExercisesTableAnnotationComposer,
          $$HiitExercisesTableCreateCompanionBuilder,
          $$HiitExercisesTableUpdateCompanionBuilder,
          (HiitExercise, $$HiitExercisesTableReferences),
          HiitExercise,
          PrefetchHooks Function({bool circuitId, bool hiitExerciseLogsRefs})
        > {
  $$HiitExercisesTableTableManager(_$AppDatabase db, $HiitExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HiitExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HiitExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HiitExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> circuitId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => HiitExercisesCompanion(
                id: id,
                circuitId: circuitId,
                name: name,
                type: type,
                value: value,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int circuitId,
                required String name,
                required String type,
                required int value,
                required int orderIndex,
              }) => HiitExercisesCompanion.insert(
                id: id,
                circuitId: circuitId,
                name: name,
                type: type,
                value: value,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HiitExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({circuitId = false, hiitExerciseLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (hiitExerciseLogsRefs) db.hiitExerciseLogs,
                  ],
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
                        if (circuitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.circuitId,
                                    referencedTable:
                                        $$HiitExercisesTableReferences
                                            ._circuitIdTable(db),
                                    referencedColumn:
                                        $$HiitExercisesTableReferences
                                            ._circuitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (hiitExerciseLogsRefs)
                        await $_getPrefetchedData<
                          HiitExercise,
                          $HiitExercisesTable,
                          HiitExerciseLog
                        >(
                          currentTable: table,
                          referencedTable: $$HiitExercisesTableReferences
                              ._hiitExerciseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HiitExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).hiitExerciseLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
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

typedef $$HiitExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HiitExercisesTable,
      HiitExercise,
      $$HiitExercisesTableFilterComposer,
      $$HiitExercisesTableOrderingComposer,
      $$HiitExercisesTableAnnotationComposer,
      $$HiitExercisesTableCreateCompanionBuilder,
      $$HiitExercisesTableUpdateCompanionBuilder,
      (HiitExercise, $$HiitExercisesTableReferences),
      HiitExercise,
      PrefetchHooks Function({bool circuitId, bool hiitExerciseLogsRefs})
    >;
typedef $$HiitWorkoutLogsTableCreateCompanionBuilder =
    HiitWorkoutLogsCompanion Function({
      Value<int> id,
      required int sessionId,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
    });
typedef $$HiitWorkoutLogsTableUpdateCompanionBuilder =
    HiitWorkoutLogsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
    });

final class $$HiitWorkoutLogsTableReferences
    extends
        BaseReferences<_$AppDatabase, $HiitWorkoutLogsTable, HiitWorkoutLog> {
  $$HiitWorkoutLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.workoutSessions.createAlias(
        $_aliasNameGenerator(
          db.hiitWorkoutLogs.sessionId,
          db.workoutSessions.id,
        ),
      );

  $$WorkoutSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$WorkoutSessionsTableTableManager(
      $_db,
      $_db.workoutSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HiitExerciseLogsTable, List<HiitExerciseLog>>
  _hiitExerciseLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.hiitExerciseLogs,
    aliasName: $_aliasNameGenerator(
      db.hiitWorkoutLogs.id,
      db.hiitExerciseLogs.workoutLogId,
    ),
  );

  $$HiitExerciseLogsTableProcessedTableManager get hiitExerciseLogsRefs {
    final manager = $$HiitExerciseLogsTableTableManager(
      $_db,
      $_db.hiitExerciseLogs,
    ).filter((f) => f.workoutLogId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _hiitExerciseLogsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HiitWorkoutLogsTableFilterComposer
    extends Composer<_$AppDatabase, $HiitWorkoutLogsTable> {
  $$HiitWorkoutLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutSessionsTableFilterComposer get sessionId {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> hiitExerciseLogsRefs(
    Expression<bool> Function($$HiitExerciseLogsTableFilterComposer f) f,
  ) {
    final $$HiitExerciseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitExerciseLogs,
      getReferencedColumn: (t) => t.workoutLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitExerciseLogsTableFilterComposer(
            $db: $db,
            $table: $db.hiitExerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HiitWorkoutLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $HiitWorkoutLogsTable> {
  $$HiitWorkoutLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutSessionsTableOrderingComposer get sessionId {
    final $$WorkoutSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HiitWorkoutLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HiitWorkoutLogsTable> {
  $$HiitWorkoutLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$WorkoutSessionsTableAnnotationComposer get sessionId {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.workoutSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> hiitExerciseLogsRefs<T extends Object>(
    Expression<T> Function($$HiitExerciseLogsTableAnnotationComposer a) f,
  ) {
    final $$HiitExerciseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hiitExerciseLogs,
      getReferencedColumn: (t) => t.workoutLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitExerciseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.hiitExerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HiitWorkoutLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HiitWorkoutLogsTable,
          HiitWorkoutLog,
          $$HiitWorkoutLogsTableFilterComposer,
          $$HiitWorkoutLogsTableOrderingComposer,
          $$HiitWorkoutLogsTableAnnotationComposer,
          $$HiitWorkoutLogsTableCreateCompanionBuilder,
          $$HiitWorkoutLogsTableUpdateCompanionBuilder,
          (HiitWorkoutLog, $$HiitWorkoutLogsTableReferences),
          HiitWorkoutLog,
          PrefetchHooks Function({bool sessionId, bool hiitExerciseLogsRefs})
        > {
  $$HiitWorkoutLogsTableTableManager(
    _$AppDatabase db,
    $HiitWorkoutLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HiitWorkoutLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HiitWorkoutLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HiitWorkoutLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => HiitWorkoutLogsCompanion(
                id: id,
                sessionId: sessionId,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
              }) => HiitWorkoutLogsCompanion.insert(
                id: id,
                sessionId: sessionId,
                startedAt: startedAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HiitWorkoutLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sessionId = false, hiitExerciseLogsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (hiitExerciseLogsRefs) db.hiitExerciseLogs,
                  ],
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
                        if (sessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sessionId,
                                    referencedTable:
                                        $$HiitWorkoutLogsTableReferences
                                            ._sessionIdTable(db),
                                    referencedColumn:
                                        $$HiitWorkoutLogsTableReferences
                                            ._sessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (hiitExerciseLogsRefs)
                        await $_getPrefetchedData<
                          HiitWorkoutLog,
                          $HiitWorkoutLogsTable,
                          HiitExerciseLog
                        >(
                          currentTable: table,
                          referencedTable: $$HiitWorkoutLogsTableReferences
                              ._hiitExerciseLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HiitWorkoutLogsTableReferences(
                                db,
                                table,
                                p0,
                              ).hiitExerciseLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutLogId == item.id,
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

typedef $$HiitWorkoutLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HiitWorkoutLogsTable,
      HiitWorkoutLog,
      $$HiitWorkoutLogsTableFilterComposer,
      $$HiitWorkoutLogsTableOrderingComposer,
      $$HiitWorkoutLogsTableAnnotationComposer,
      $$HiitWorkoutLogsTableCreateCompanionBuilder,
      $$HiitWorkoutLogsTableUpdateCompanionBuilder,
      (HiitWorkoutLog, $$HiitWorkoutLogsTableReferences),
      HiitWorkoutLog,
      PrefetchHooks Function({bool sessionId, bool hiitExerciseLogsRefs})
    >;
typedef $$HiitExerciseLogsTableCreateCompanionBuilder =
    HiitExerciseLogsCompanion Function({
      Value<int> id,
      required int workoutLogId,
      required int exerciseId,
      required int round,
      required int actualValue,
      required DateTime completedAt,
    });
typedef $$HiitExerciseLogsTableUpdateCompanionBuilder =
    HiitExerciseLogsCompanion Function({
      Value<int> id,
      Value<int> workoutLogId,
      Value<int> exerciseId,
      Value<int> round,
      Value<int> actualValue,
      Value<DateTime> completedAt,
    });

final class $$HiitExerciseLogsTableReferences
    extends
        BaseReferences<_$AppDatabase, $HiitExerciseLogsTable, HiitExerciseLog> {
  $$HiitExerciseLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HiitWorkoutLogsTable _workoutLogIdTable(_$AppDatabase db) =>
      db.hiitWorkoutLogs.createAlias(
        $_aliasNameGenerator(
          db.hiitExerciseLogs.workoutLogId,
          db.hiitWorkoutLogs.id,
        ),
      );

  $$HiitWorkoutLogsTableProcessedTableManager get workoutLogId {
    final $_column = $_itemColumn<int>('workout_log_id')!;

    final manager = $$HiitWorkoutLogsTableTableManager(
      $_db,
      $_db.hiitWorkoutLogs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $HiitExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.hiitExercises.createAlias(
        $_aliasNameGenerator(
          db.hiitExerciseLogs.exerciseId,
          db.hiitExercises.id,
        ),
      );

  $$HiitExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$HiitExercisesTableTableManager(
      $_db,
      $_db.hiitExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HiitExerciseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $HiitExerciseLogsTable> {
  $$HiitExerciseLogsTableFilterComposer({
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

  ColumnFilters<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualValue => $composableBuilder(
    column: $table.actualValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$HiitWorkoutLogsTableFilterComposer get workoutLogId {
    final $$HiitWorkoutLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutLogId,
      referencedTable: $db.hiitWorkoutLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitWorkoutLogsTableFilterComposer(
            $db: $db,
            $table: $db.hiitWorkoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HiitExercisesTableFilterComposer get exerciseId {
    final $$HiitExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.hiitExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitExercisesTableFilterComposer(
            $db: $db,
            $table: $db.hiitExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HiitExerciseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $HiitExerciseLogsTable> {
  $$HiitExerciseLogsTableOrderingComposer({
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

  ColumnOrderings<int> get round => $composableBuilder(
    column: $table.round,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualValue => $composableBuilder(
    column: $table.actualValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HiitWorkoutLogsTableOrderingComposer get workoutLogId {
    final $$HiitWorkoutLogsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutLogId,
      referencedTable: $db.hiitWorkoutLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitWorkoutLogsTableOrderingComposer(
            $db: $db,
            $table: $db.hiitWorkoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HiitExercisesTableOrderingComposer get exerciseId {
    final $$HiitExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.hiitExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.hiitExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HiitExerciseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HiitExerciseLogsTable> {
  $$HiitExerciseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get round =>
      $composableBuilder(column: $table.round, builder: (column) => column);

  GeneratedColumn<int> get actualValue => $composableBuilder(
    column: $table.actualValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$HiitWorkoutLogsTableAnnotationComposer get workoutLogId {
    final $$HiitWorkoutLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutLogId,
      referencedTable: $db.hiitWorkoutLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitWorkoutLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.hiitWorkoutLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$HiitExercisesTableAnnotationComposer get exerciseId {
    final $$HiitExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.hiitExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HiitExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.hiitExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HiitExerciseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HiitExerciseLogsTable,
          HiitExerciseLog,
          $$HiitExerciseLogsTableFilterComposer,
          $$HiitExerciseLogsTableOrderingComposer,
          $$HiitExerciseLogsTableAnnotationComposer,
          $$HiitExerciseLogsTableCreateCompanionBuilder,
          $$HiitExerciseLogsTableUpdateCompanionBuilder,
          (HiitExerciseLog, $$HiitExerciseLogsTableReferences),
          HiitExerciseLog,
          PrefetchHooks Function({bool workoutLogId, bool exerciseId})
        > {
  $$HiitExerciseLogsTableTableManager(
    _$AppDatabase db,
    $HiitExerciseLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HiitExerciseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HiitExerciseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HiitExerciseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutLogId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> round = const Value.absent(),
                Value<int> actualValue = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
              }) => HiitExerciseLogsCompanion(
                id: id,
                workoutLogId: workoutLogId,
                exerciseId: exerciseId,
                round: round,
                actualValue: actualValue,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutLogId,
                required int exerciseId,
                required int round,
                required int actualValue,
                required DateTime completedAt,
              }) => HiitExerciseLogsCompanion.insert(
                id: id,
                workoutLogId: workoutLogId,
                exerciseId: exerciseId,
                round: round,
                actualValue: actualValue,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HiitExerciseLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutLogId = false, exerciseId = false}) {
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
                    if (workoutLogId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutLogId,
                                referencedTable:
                                    $$HiitExerciseLogsTableReferences
                                        ._workoutLogIdTable(db),
                                referencedColumn:
                                    $$HiitExerciseLogsTableReferences
                                        ._workoutLogIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable:
                                    $$HiitExerciseLogsTableReferences
                                        ._exerciseIdTable(db),
                                referencedColumn:
                                    $$HiitExerciseLogsTableReferences
                                        ._exerciseIdTable(db)
                                        .id,
                              )
                              as T;
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

typedef $$HiitExerciseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HiitExerciseLogsTable,
      HiitExerciseLog,
      $$HiitExerciseLogsTableFilterComposer,
      $$HiitExerciseLogsTableOrderingComposer,
      $$HiitExerciseLogsTableAnnotationComposer,
      $$HiitExerciseLogsTableCreateCompanionBuilder,
      $$HiitExerciseLogsTableUpdateCompanionBuilder,
      (HiitExerciseLog, $$HiitExerciseLogsTableReferences),
      HiitExerciseLog,
      PrefetchHooks Function({bool workoutLogId, bool exerciseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$SetsTableTableManager get sets => $$SetsTableTableManager(_db, _db.sets);
  $$HiitCircuitsTableTableManager get hiitCircuits =>
      $$HiitCircuitsTableTableManager(_db, _db.hiitCircuits);
  $$HiitExercisesTableTableManager get hiitExercises =>
      $$HiitExercisesTableTableManager(_db, _db.hiitExercises);
  $$HiitWorkoutLogsTableTableManager get hiitWorkoutLogs =>
      $$HiitWorkoutLogsTableTableManager(_db, _db.hiitWorkoutLogs);
  $$HiitExerciseLogsTableTableManager get hiitExerciseLogs =>
      $$HiitExerciseLogsTableTableManager(_db, _db.hiitExerciseLogs);
}
