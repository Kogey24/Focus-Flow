// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MaterialsTableTable extends MaterialsTable
    with TableInfo<$MaterialsTableTable, MaterialEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaterialsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalDurationMeta = const VerificationMeta(
    'totalDuration',
  );
  @override
  late final GeneratedColumn<int> totalDuration = GeneratedColumn<int>(
    'total_duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalPagesMeta = const VerificationMeta(
    'totalPages',
  );
  @override
  late final GeneratedColumn<int> totalPages = GeneratedColumn<int>(
    'total_pages',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('not_started'),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    type,
    filePath,
    thumbnailPath,
    totalDuration,
    totalPages,
    createdAt,
    status,
    tags,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'materials';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaterialEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('total_duration')) {
      context.handle(
        _totalDurationMeta,
        totalDuration.isAcceptableOrUnknown(
          data['total_duration']!,
          _totalDurationMeta,
        ),
      );
    }
    if (data.containsKey('total_pages')) {
      context.handle(
        _totalPagesMeta,
        totalPages.isAcceptableOrUnknown(data['total_pages']!, _totalPagesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MaterialEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaterialEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      totalDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_duration'],
      ),
      totalPages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pages'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
    );
  }

  @override
  $MaterialsTableTable createAlias(String alias) {
    return $MaterialsTableTable(attachedDatabase, alias);
  }
}

class MaterialEntity extends DataClass implements Insertable<MaterialEntity> {
  final String id;
  final String title;
  final String? author;
  final String type;
  final String? filePath;
  final String? thumbnailPath;
  final int? totalDuration;
  final int? totalPages;
  final int createdAt;
  final String status;
  final String? tags;
  const MaterialEntity({
    required this.id,
    required this.title,
    this.author,
    required this.type,
    this.filePath,
    this.thumbnailPath,
    this.totalDuration,
    this.totalPages,
    required this.createdAt,
    required this.status,
    this.tags,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || totalDuration != null) {
      map['total_duration'] = Variable<int>(totalDuration);
    }
    if (!nullToAbsent || totalPages != null) {
      map['total_pages'] = Variable<int>(totalPages);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    return map;
  }

  MaterialsTableCompanion toCompanion(bool nullToAbsent) {
    return MaterialsTableCompanion(
      id: Value(id),
      title: Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      type: Value(type),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      totalDuration: totalDuration == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDuration),
      totalPages: totalPages == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPages),
      createdAt: Value(createdAt),
      status: Value(status),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
    );
  }

  factory MaterialEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaterialEntity(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      type: serializer.fromJson<String>(json['type']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      totalDuration: serializer.fromJson<int?>(json['totalDuration']),
      totalPages: serializer.fromJson<int?>(json['totalPages']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      tags: serializer.fromJson<String?>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'type': serializer.toJson<String>(type),
      'filePath': serializer.toJson<String?>(filePath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'totalDuration': serializer.toJson<int?>(totalDuration),
      'totalPages': serializer.toJson<int?>(totalPages),
      'createdAt': serializer.toJson<int>(createdAt),
      'status': serializer.toJson<String>(status),
      'tags': serializer.toJson<String?>(tags),
    };
  }

  MaterialEntity copyWith({
    String? id,
    String? title,
    Value<String?> author = const Value.absent(),
    String? type,
    Value<String?> filePath = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    Value<int?> totalDuration = const Value.absent(),
    Value<int?> totalPages = const Value.absent(),
    int? createdAt,
    String? status,
    Value<String?> tags = const Value.absent(),
  }) => MaterialEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author.present ? author.value : this.author,
    type: type ?? this.type,
    filePath: filePath.present ? filePath.value : this.filePath,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    totalDuration: totalDuration.present
        ? totalDuration.value
        : this.totalDuration,
    totalPages: totalPages.present ? totalPages.value : this.totalPages,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    tags: tags.present ? tags.value : this.tags,
  );
  MaterialEntity copyWithCompanion(MaterialsTableCompanion data) {
    return MaterialEntity(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      type: data.type.present ? data.type.value : this.type,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      totalDuration: data.totalDuration.present
          ? data.totalDuration.value
          : this.totalDuration,
      totalPages: data.totalPages.present
          ? data.totalPages.value
          : this.totalPages,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaterialEntity(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('totalDuration: $totalDuration, ')
          ..write('totalPages: $totalPages, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    author,
    type,
    filePath,
    thumbnailPath,
    totalDuration,
    totalPages,
    createdAt,
    status,
    tags,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaterialEntity &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.type == this.type &&
          other.filePath == this.filePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.totalDuration == this.totalDuration &&
          other.totalPages == this.totalPages &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.tags == this.tags);
}

class MaterialsTableCompanion extends UpdateCompanion<MaterialEntity> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> author;
  final Value<String> type;
  final Value<String?> filePath;
  final Value<String?> thumbnailPath;
  final Value<int?> totalDuration;
  final Value<int?> totalPages;
  final Value<int> createdAt;
  final Value<String> status;
  final Value<String?> tags;
  final Value<int> rowid;
  const MaterialsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.type = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.totalDuration = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaterialsTableCompanion.insert({
    required String id,
    required String title,
    this.author = const Value.absent(),
    required String type,
    this.filePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.totalDuration = const Value.absent(),
    this.totalPages = const Value.absent(),
    required int createdAt,
    this.status = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<MaterialEntity> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? type,
    Expression<String>? filePath,
    Expression<String>? thumbnailPath,
    Expression<int>? totalDuration,
    Expression<int>? totalPages,
    Expression<int>? createdAt,
    Expression<String>? status,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (type != null) 'type': type,
      if (filePath != null) 'file_path': filePath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (totalDuration != null) 'total_duration': totalDuration,
      if (totalPages != null) 'total_pages': totalPages,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaterialsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? author,
    Value<String>? type,
    Value<String?>? filePath,
    Value<String?>? thumbnailPath,
    Value<int?>? totalDuration,
    Value<int?>? totalPages,
    Value<int>? createdAt,
    Value<String>? status,
    Value<String?>? tags,
    Value<int>? rowid,
  }) {
    return MaterialsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      totalDuration: totalDuration ?? this.totalDuration,
      totalPages: totalPages ?? this.totalPages,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (totalDuration.present) {
      map['total_duration'] = Variable<int>(totalDuration.value);
    }
    if (totalPages.present) {
      map['total_pages'] = Variable<int>(totalPages.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaterialsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('totalDuration: $totalDuration, ')
          ..write('totalPages: $totalPages, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTableTable extends ChaptersTable
    with TableInfo<$ChaptersTableTable, ChapterEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _materialIdMeta = const VerificationMeta(
    'materialId',
  );
  @override
  late final GeneratedColumn<String> materialId = GeneratedColumn<String>(
    'material_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES materials (id)',
    ),
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
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
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
  static const VerificationMeta _pageStartMeta = const VerificationMeta(
    'pageStart',
  );
  @override
  late final GeneratedColumn<int> pageStart = GeneratedColumn<int>(
    'page_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageEndMeta = const VerificationMeta(
    'pageEnd',
  );
  @override
  late final GeneratedColumn<int> pageEnd = GeneratedColumn<int>(
    'page_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    materialId,
    title,
    parentId,
    orderIndex,
    pageStart,
    pageEnd,
    duration,
    filePath,
    isCompleted,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChapterEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('material_id')) {
      context.handle(
        _materialIdMeta,
        materialId.isAcceptableOrUnknown(data['material_id']!, _materialIdMeta),
      );
    } else if (isInserting) {
      context.missing(_materialIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
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
    if (data.containsKey('page_start')) {
      context.handle(
        _pageStartMeta,
        pageStart.isAcceptableOrUnknown(data['page_start']!, _pageStartMeta),
      );
    }
    if (data.containsKey('page_end')) {
      context.handle(
        _pageEndMeta,
        pageEnd.isAcceptableOrUnknown(data['page_end']!, _pageEndMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
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
  ChapterEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      materialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      pageStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_start'],
      ),
      pageEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_end'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $ChaptersTableTable createAlias(String alias) {
    return $ChaptersTableTable(attachedDatabase, alias);
  }
}

class ChapterEntity extends DataClass implements Insertable<ChapterEntity> {
  final String id;
  final String materialId;
  final String title;
  final String? parentId;
  final int orderIndex;
  final int? pageStart;
  final int? pageEnd;
  final int? duration;
  final String? filePath;
  final bool isCompleted;
  final int? completedAt;
  const ChapterEntity({
    required this.id,
    required this.materialId,
    required this.title,
    this.parentId,
    required this.orderIndex,
    this.pageStart,
    this.pageEnd,
    this.duration,
    this.filePath,
    required this.isCompleted,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['material_id'] = Variable<String>(materialId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || pageStart != null) {
      map['page_start'] = Variable<int>(pageStart);
    }
    if (!nullToAbsent || pageEnd != null) {
      map['page_end'] = Variable<int>(pageEnd);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || filePath != null) {
      map['file_path'] = Variable<String>(filePath);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    return map;
  }

  ChaptersTableCompanion toCompanion(bool nullToAbsent) {
    return ChaptersTableCompanion(
      id: Value(id),
      materialId: Value(materialId),
      title: Value(title),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      orderIndex: Value(orderIndex),
      pageStart: pageStart == null && nullToAbsent
          ? const Value.absent()
          : Value(pageStart),
      pageEnd: pageEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(pageEnd),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      filePath: filePath == null && nullToAbsent
          ? const Value.absent()
          : Value(filePath),
      isCompleted: Value(isCompleted),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory ChapterEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterEntity(
      id: serializer.fromJson<String>(json['id']),
      materialId: serializer.fromJson<String>(json['materialId']),
      title: serializer.fromJson<String>(json['title']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      pageStart: serializer.fromJson<int?>(json['pageStart']),
      pageEnd: serializer.fromJson<int?>(json['pageEnd']),
      duration: serializer.fromJson<int?>(json['duration']),
      filePath: serializer.fromJson<String?>(json['filePath']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'materialId': serializer.toJson<String>(materialId),
      'title': serializer.toJson<String>(title),
      'parentId': serializer.toJson<String?>(parentId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'pageStart': serializer.toJson<int?>(pageStart),
      'pageEnd': serializer.toJson<int?>(pageEnd),
      'duration': serializer.toJson<int?>(duration),
      'filePath': serializer.toJson<String?>(filePath),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<int?>(completedAt),
    };
  }

  ChapterEntity copyWith({
    String? id,
    String? materialId,
    String? title,
    Value<String?> parentId = const Value.absent(),
    int? orderIndex,
    Value<int?> pageStart = const Value.absent(),
    Value<int?> pageEnd = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    Value<String?> filePath = const Value.absent(),
    bool? isCompleted,
    Value<int?> completedAt = const Value.absent(),
  }) => ChapterEntity(
    id: id ?? this.id,
    materialId: materialId ?? this.materialId,
    title: title ?? this.title,
    parentId: parentId.present ? parentId.value : this.parentId,
    orderIndex: orderIndex ?? this.orderIndex,
    pageStart: pageStart.present ? pageStart.value : this.pageStart,
    pageEnd: pageEnd.present ? pageEnd.value : this.pageEnd,
    duration: duration.present ? duration.value : this.duration,
    filePath: filePath.present ? filePath.value : this.filePath,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  ChapterEntity copyWithCompanion(ChaptersTableCompanion data) {
    return ChapterEntity(
      id: data.id.present ? data.id.value : this.id,
      materialId: data.materialId.present
          ? data.materialId.value
          : this.materialId,
      title: data.title.present ? data.title.value : this.title,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      pageStart: data.pageStart.present ? data.pageStart.value : this.pageStart,
      pageEnd: data.pageEnd.present ? data.pageEnd.value : this.pageEnd,
      duration: data.duration.present ? data.duration.value : this.duration,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterEntity(')
          ..write('id: $id, ')
          ..write('materialId: $materialId, ')
          ..write('title: $title, ')
          ..write('parentId: $parentId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('pageStart: $pageStart, ')
          ..write('pageEnd: $pageEnd, ')
          ..write('duration: $duration, ')
          ..write('filePath: $filePath, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    materialId,
    title,
    parentId,
    orderIndex,
    pageStart,
    pageEnd,
    duration,
    filePath,
    isCompleted,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterEntity &&
          other.id == this.id &&
          other.materialId == this.materialId &&
          other.title == this.title &&
          other.parentId == this.parentId &&
          other.orderIndex == this.orderIndex &&
          other.pageStart == this.pageStart &&
          other.pageEnd == this.pageEnd &&
          other.duration == this.duration &&
          other.filePath == this.filePath &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt);
}

class ChaptersTableCompanion extends UpdateCompanion<ChapterEntity> {
  final Value<String> id;
  final Value<String> materialId;
  final Value<String> title;
  final Value<String?> parentId;
  final Value<int> orderIndex;
  final Value<int?> pageStart;
  final Value<int?> pageEnd;
  final Value<int?> duration;
  final Value<String?> filePath;
  final Value<bool> isCompleted;
  final Value<int?> completedAt;
  final Value<int> rowid;
  const ChaptersTableCompanion({
    this.id = const Value.absent(),
    this.materialId = const Value.absent(),
    this.title = const Value.absent(),
    this.parentId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.pageStart = const Value.absent(),
    this.pageEnd = const Value.absent(),
    this.duration = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersTableCompanion.insert({
    required String id,
    required String materialId,
    required String title,
    this.parentId = const Value.absent(),
    required int orderIndex,
    this.pageStart = const Value.absent(),
    this.pageEnd = const Value.absent(),
    this.duration = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       materialId = Value(materialId),
       title = Value(title),
       orderIndex = Value(orderIndex);
  static Insertable<ChapterEntity> custom({
    Expression<String>? id,
    Expression<String>? materialId,
    Expression<String>? title,
    Expression<String>? parentId,
    Expression<int>? orderIndex,
    Expression<int>? pageStart,
    Expression<int>? pageEnd,
    Expression<int>? duration,
    Expression<String>? filePath,
    Expression<bool>? isCompleted,
    Expression<int>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (materialId != null) 'material_id': materialId,
      if (title != null) 'title': title,
      if (parentId != null) 'parent_id': parentId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (pageStart != null) 'page_start': pageStart,
      if (pageEnd != null) 'page_end': pageEnd,
      if (duration != null) 'duration': duration,
      if (filePath != null) 'file_path': filePath,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? materialId,
    Value<String>? title,
    Value<String?>? parentId,
    Value<int>? orderIndex,
    Value<int?>? pageStart,
    Value<int?>? pageEnd,
    Value<int?>? duration,
    Value<String?>? filePath,
    Value<bool>? isCompleted,
    Value<int?>? completedAt,
    Value<int>? rowid,
  }) {
    return ChaptersTableCompanion(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      title: title ?? this.title,
      parentId: parentId ?? this.parentId,
      orderIndex: orderIndex ?? this.orderIndex,
      pageStart: pageStart ?? this.pageStart,
      pageEnd: pageEnd ?? this.pageEnd,
      duration: duration ?? this.duration,
      filePath: filePath ?? this.filePath,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (materialId.present) {
      map['material_id'] = Variable<String>(materialId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (pageStart.present) {
      map['page_start'] = Variable<int>(pageStart.value);
    }
    if (pageEnd.present) {
      map['page_end'] = Variable<int>(pageEnd.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersTableCompanion(')
          ..write('id: $id, ')
          ..write('materialId: $materialId, ')
          ..write('title: $title, ')
          ..write('parentId: $parentId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('pageStart: $pageStart, ')
          ..write('pageEnd: $pageEnd, ')
          ..write('duration: $duration, ')
          ..write('filePath: $filePath, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTableTable extends FocusSessionsTable
    with TableInfo<$FocusSessionsTableTable, FocusSessionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _materialIdMeta = const VerificationMeta(
    'materialId',
  );
  @override
  late final GeneratedColumn<String> materialId = GeneratedColumn<String>(
    'material_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES materials (id)',
    ),
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    materialId,
    chapterId,
    startedAt,
    endedAt,
    durationSeconds,
    status,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSessionEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('material_id')) {
      context.handle(
        _materialIdMeta,
        materialId.isAcceptableOrUnknown(data['material_id']!, _materialIdMeta),
      );
    } else if (isInserting) {
      context.missing(_materialIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSessionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSessionEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      materialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $FocusSessionsTableTable createAlias(String alias) {
    return $FocusSessionsTableTable(attachedDatabase, alias);
  }
}

class FocusSessionEntity extends DataClass
    implements Insertable<FocusSessionEntity> {
  final String id;
  final String materialId;
  final String? chapterId;
  final int startedAt;
  final int? endedAt;
  final int durationSeconds;
  final String status;
  final String? notes;
  const FocusSessionEntity({
    required this.id,
    required this.materialId,
    this.chapterId,
    required this.startedAt,
    this.endedAt,
    required this.durationSeconds,
    required this.status,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['material_id'] = Variable<String>(materialId);
    if (!nullToAbsent || chapterId != null) {
      map['chapter_id'] = Variable<String>(chapterId);
    }
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(endedAt);
    }
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FocusSessionsTableCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsTableCompanion(
      id: Value(id),
      materialId: Value(materialId),
      chapterId: chapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationSeconds: Value(durationSeconds),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory FocusSessionEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSessionEntity(
      id: serializer.fromJson<String>(json['id']),
      materialId: serializer.fromJson<String>(json['materialId']),
      chapterId: serializer.fromJson<String?>(json['chapterId']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int?>(json['endedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'materialId': serializer.toJson<String>(materialId),
      'chapterId': serializer.toJson<String?>(chapterId),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int?>(endedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  FocusSessionEntity copyWith({
    String? id,
    String? materialId,
    Value<String?> chapterId = const Value.absent(),
    int? startedAt,
    Value<int?> endedAt = const Value.absent(),
    int? durationSeconds,
    String? status,
    Value<String?> notes = const Value.absent(),
  }) => FocusSessionEntity(
    id: id ?? this.id,
    materialId: materialId ?? this.materialId,
    chapterId: chapterId.present ? chapterId.value : this.chapterId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
  );
  FocusSessionEntity copyWithCompanion(FocusSessionsTableCompanion data) {
    return FocusSessionEntity(
      id: data.id.present ? data.id.value : this.id,
      materialId: data.materialId.present
          ? data.materialId.value
          : this.materialId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionEntity(')
          ..write('id: $id, ')
          ..write('materialId: $materialId, ')
          ..write('chapterId: $chapterId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('status: $status, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    materialId,
    chapterId,
    startedAt,
    endedAt,
    durationSeconds,
    status,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSessionEntity &&
          other.id == this.id &&
          other.materialId == this.materialId &&
          other.chapterId == this.chapterId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.status == this.status &&
          other.notes == this.notes);
}

class FocusSessionsTableCompanion extends UpdateCompanion<FocusSessionEntity> {
  final Value<String> id;
  final Value<String> materialId;
  final Value<String?> chapterId;
  final Value<int> startedAt;
  final Value<int?> endedAt;
  final Value<int> durationSeconds;
  final Value<String> status;
  final Value<String?> notes;
  final Value<int> rowid;
  const FocusSessionsTableCompanion({
    this.id = const Value.absent(),
    this.materialId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsTableCompanion.insert({
    required String id,
    required String materialId,
    this.chapterId = const Value.absent(),
    required int startedAt,
    this.endedAt = const Value.absent(),
    required int durationSeconds,
    required String status,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       materialId = Value(materialId),
       startedAt = Value(startedAt),
       durationSeconds = Value(durationSeconds),
       status = Value(status);
  static Insertable<FocusSessionEntity> custom({
    Expression<String>? id,
    Expression<String>? materialId,
    Expression<String>? chapterId,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<int>? durationSeconds,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (materialId != null) 'material_id': materialId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? materialId,
    Value<String?>? chapterId,
    Value<int>? startedAt,
    Value<int?>? endedAt,
    Value<int>? durationSeconds,
    Value<String>? status,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return FocusSessionsTableCompanion(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      chapterId: chapterId ?? this.chapterId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (materialId.present) {
      map['material_id'] = Variable<String>(materialId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('materialId: $materialId, ')
          ..write('chapterId: $chapterId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressSnapshotsTableTable extends ProgressSnapshotsTable
    with TableInfo<$ProgressSnapshotsTableTable, ProgressSnapshotEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressSnapshotsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _materialIdMeta = const VerificationMeta(
    'materialId',
  );
  @override
  late final GeneratedColumn<String> materialId = GeneratedColumn<String>(
    'material_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES materials (id)',
    ),
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id)',
    ),
  );
  static const VerificationMeta _snapshotAtMeta = const VerificationMeta(
    'snapshotAt',
  );
  @override
  late final GeneratedColumn<int> snapshotAt = GeneratedColumn<int>(
    'snapshot_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _percentCompleteMeta = const VerificationMeta(
    'percentComplete',
  );
  @override
  late final GeneratedColumn<double> percentComplete = GeneratedColumn<double>(
    'percent_complete',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPositionSecondsMeta =
      const VerificationMeta('lastPositionSeconds');
  @override
  late final GeneratedColumn<int> lastPositionSeconds = GeneratedColumn<int>(
    'last_position_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    materialId,
    chapterId,
    snapshotAt,
    percentComplete,
    lastPositionSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressSnapshotEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('material_id')) {
      context.handle(
        _materialIdMeta,
        materialId.isAcceptableOrUnknown(data['material_id']!, _materialIdMeta),
      );
    } else if (isInserting) {
      context.missing(_materialIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    }
    if (data.containsKey('snapshot_at')) {
      context.handle(
        _snapshotAtMeta,
        snapshotAt.isAcceptableOrUnknown(data['snapshot_at']!, _snapshotAtMeta),
      );
    } else if (isInserting) {
      context.missing(_snapshotAtMeta);
    }
    if (data.containsKey('percent_complete')) {
      context.handle(
        _percentCompleteMeta,
        percentComplete.isAcceptableOrUnknown(
          data['percent_complete']!,
          _percentCompleteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_percentCompleteMeta);
    }
    if (data.containsKey('last_position_seconds')) {
      context.handle(
        _lastPositionSecondsMeta,
        lastPositionSeconds.isAcceptableOrUnknown(
          data['last_position_seconds']!,
          _lastPositionSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressSnapshotEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressSnapshotEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      materialId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      ),
      snapshotAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snapshot_at'],
      )!,
      percentComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percent_complete'],
      )!,
      lastPositionSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_position_seconds'],
      ),
    );
  }

  @override
  $ProgressSnapshotsTableTable createAlias(String alias) {
    return $ProgressSnapshotsTableTable(attachedDatabase, alias);
  }
}

class ProgressSnapshotEntity extends DataClass
    implements Insertable<ProgressSnapshotEntity> {
  final String id;
  final String materialId;
  final String? chapterId;
  final int snapshotAt;
  final double percentComplete;
  final int? lastPositionSeconds;
  const ProgressSnapshotEntity({
    required this.id,
    required this.materialId,
    this.chapterId,
    required this.snapshotAt,
    required this.percentComplete,
    this.lastPositionSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['material_id'] = Variable<String>(materialId);
    if (!nullToAbsent || chapterId != null) {
      map['chapter_id'] = Variable<String>(chapterId);
    }
    map['snapshot_at'] = Variable<int>(snapshotAt);
    map['percent_complete'] = Variable<double>(percentComplete);
    if (!nullToAbsent || lastPositionSeconds != null) {
      map['last_position_seconds'] = Variable<int>(lastPositionSeconds);
    }
    return map;
  }

  ProgressSnapshotsTableCompanion toCompanion(bool nullToAbsent) {
    return ProgressSnapshotsTableCompanion(
      id: Value(id),
      materialId: Value(materialId),
      chapterId: chapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterId),
      snapshotAt: Value(snapshotAt),
      percentComplete: Value(percentComplete),
      lastPositionSeconds: lastPositionSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPositionSeconds),
    );
  }

  factory ProgressSnapshotEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressSnapshotEntity(
      id: serializer.fromJson<String>(json['id']),
      materialId: serializer.fromJson<String>(json['materialId']),
      chapterId: serializer.fromJson<String?>(json['chapterId']),
      snapshotAt: serializer.fromJson<int>(json['snapshotAt']),
      percentComplete: serializer.fromJson<double>(json['percentComplete']),
      lastPositionSeconds: serializer.fromJson<int?>(
        json['lastPositionSeconds'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'materialId': serializer.toJson<String>(materialId),
      'chapterId': serializer.toJson<String?>(chapterId),
      'snapshotAt': serializer.toJson<int>(snapshotAt),
      'percentComplete': serializer.toJson<double>(percentComplete),
      'lastPositionSeconds': serializer.toJson<int?>(lastPositionSeconds),
    };
  }

  ProgressSnapshotEntity copyWith({
    String? id,
    String? materialId,
    Value<String?> chapterId = const Value.absent(),
    int? snapshotAt,
    double? percentComplete,
    Value<int?> lastPositionSeconds = const Value.absent(),
  }) => ProgressSnapshotEntity(
    id: id ?? this.id,
    materialId: materialId ?? this.materialId,
    chapterId: chapterId.present ? chapterId.value : this.chapterId,
    snapshotAt: snapshotAt ?? this.snapshotAt,
    percentComplete: percentComplete ?? this.percentComplete,
    lastPositionSeconds: lastPositionSeconds.present
        ? lastPositionSeconds.value
        : this.lastPositionSeconds,
  );
  ProgressSnapshotEntity copyWithCompanion(
    ProgressSnapshotsTableCompanion data,
  ) {
    return ProgressSnapshotEntity(
      id: data.id.present ? data.id.value : this.id,
      materialId: data.materialId.present
          ? data.materialId.value
          : this.materialId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      snapshotAt: data.snapshotAt.present
          ? data.snapshotAt.value
          : this.snapshotAt,
      percentComplete: data.percentComplete.present
          ? data.percentComplete.value
          : this.percentComplete,
      lastPositionSeconds: data.lastPositionSeconds.present
          ? data.lastPositionSeconds.value
          : this.lastPositionSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressSnapshotEntity(')
          ..write('id: $id, ')
          ..write('materialId: $materialId, ')
          ..write('chapterId: $chapterId, ')
          ..write('snapshotAt: $snapshotAt, ')
          ..write('percentComplete: $percentComplete, ')
          ..write('lastPositionSeconds: $lastPositionSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    materialId,
    chapterId,
    snapshotAt,
    percentComplete,
    lastPositionSeconds,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressSnapshotEntity &&
          other.id == this.id &&
          other.materialId == this.materialId &&
          other.chapterId == this.chapterId &&
          other.snapshotAt == this.snapshotAt &&
          other.percentComplete == this.percentComplete &&
          other.lastPositionSeconds == this.lastPositionSeconds);
}

class ProgressSnapshotsTableCompanion
    extends UpdateCompanion<ProgressSnapshotEntity> {
  final Value<String> id;
  final Value<String> materialId;
  final Value<String?> chapterId;
  final Value<int> snapshotAt;
  final Value<double> percentComplete;
  final Value<int?> lastPositionSeconds;
  final Value<int> rowid;
  const ProgressSnapshotsTableCompanion({
    this.id = const Value.absent(),
    this.materialId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.snapshotAt = const Value.absent(),
    this.percentComplete = const Value.absent(),
    this.lastPositionSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressSnapshotsTableCompanion.insert({
    required String id,
    required String materialId,
    this.chapterId = const Value.absent(),
    required int snapshotAt,
    required double percentComplete,
    this.lastPositionSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       materialId = Value(materialId),
       snapshotAt = Value(snapshotAt),
       percentComplete = Value(percentComplete);
  static Insertable<ProgressSnapshotEntity> custom({
    Expression<String>? id,
    Expression<String>? materialId,
    Expression<String>? chapterId,
    Expression<int>? snapshotAt,
    Expression<double>? percentComplete,
    Expression<int>? lastPositionSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (materialId != null) 'material_id': materialId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (snapshotAt != null) 'snapshot_at': snapshotAt,
      if (percentComplete != null) 'percent_complete': percentComplete,
      if (lastPositionSeconds != null)
        'last_position_seconds': lastPositionSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressSnapshotsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? materialId,
    Value<String?>? chapterId,
    Value<int>? snapshotAt,
    Value<double>? percentComplete,
    Value<int?>? lastPositionSeconds,
    Value<int>? rowid,
  }) {
    return ProgressSnapshotsTableCompanion(
      id: id ?? this.id,
      materialId: materialId ?? this.materialId,
      chapterId: chapterId ?? this.chapterId,
      snapshotAt: snapshotAt ?? this.snapshotAt,
      percentComplete: percentComplete ?? this.percentComplete,
      lastPositionSeconds: lastPositionSeconds ?? this.lastPositionSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (materialId.present) {
      map['material_id'] = Variable<String>(materialId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (snapshotAt.present) {
      map['snapshot_at'] = Variable<int>(snapshotAt.value);
    }
    if (percentComplete.present) {
      map['percent_complete'] = Variable<double>(percentComplete.value);
    }
    if (lastPositionSeconds.present) {
      map['last_position_seconds'] = Variable<int>(lastPositionSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressSnapshotsTableCompanion(')
          ..write('id: $id, ')
          ..write('materialId: $materialId, ')
          ..write('chapterId: $chapterId, ')
          ..write('snapshotAt: $snapshotAt, ')
          ..write('percentComplete: $percentComplete, ')
          ..write('lastPositionSeconds: $lastPositionSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreaksTableTable extends StreaksTable
    with TableInfo<$StreaksTableTable, StreakEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalFocusSecondsMeta = const VerificationMeta(
    'totalFocusSeconds',
  );
  @override
  late final GeneratedColumn<int> totalFocusSeconds = GeneratedColumn<int>(
    'total_focus_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sessionCountMeta = const VerificationMeta(
    'sessionCount',
  );
  @override
  late final GeneratedColumn<int> sessionCount = GeneratedColumn<int>(
    'session_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    totalFocusSeconds,
    sessionCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreakEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_focus_seconds')) {
      context.handle(
        _totalFocusSecondsMeta,
        totalFocusSeconds.isAcceptableOrUnknown(
          data['total_focus_seconds']!,
          _totalFocusSecondsMeta,
        ),
      );
    }
    if (data.containsKey('session_count')) {
      context.handle(
        _sessionCountMeta,
        sessionCount.isAcceptableOrUnknown(
          data['session_count']!,
          _sessionCountMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreakEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreakEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      totalFocusSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_focus_seconds'],
      )!,
      sessionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_count'],
      )!,
    );
  }

  @override
  $StreaksTableTable createAlias(String alias) {
    return $StreaksTableTable(attachedDatabase, alias);
  }
}

class StreakEntity extends DataClass implements Insertable<StreakEntity> {
  final String id;
  final String date;
  final int totalFocusSeconds;
  final int sessionCount;
  const StreakEntity({
    required this.id,
    required this.date,
    required this.totalFocusSeconds,
    required this.sessionCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['total_focus_seconds'] = Variable<int>(totalFocusSeconds);
    map['session_count'] = Variable<int>(sessionCount);
    return map;
  }

  StreaksTableCompanion toCompanion(bool nullToAbsent) {
    return StreaksTableCompanion(
      id: Value(id),
      date: Value(date),
      totalFocusSeconds: Value(totalFocusSeconds),
      sessionCount: Value(sessionCount),
    );
  }

  factory StreakEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreakEntity(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      totalFocusSeconds: serializer.fromJson<int>(json['totalFocusSeconds']),
      sessionCount: serializer.fromJson<int>(json['sessionCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'totalFocusSeconds': serializer.toJson<int>(totalFocusSeconds),
      'sessionCount': serializer.toJson<int>(sessionCount),
    };
  }

  StreakEntity copyWith({
    String? id,
    String? date,
    int? totalFocusSeconds,
    int? sessionCount,
  }) => StreakEntity(
    id: id ?? this.id,
    date: date ?? this.date,
    totalFocusSeconds: totalFocusSeconds ?? this.totalFocusSeconds,
    sessionCount: sessionCount ?? this.sessionCount,
  );
  StreakEntity copyWithCompanion(StreaksTableCompanion data) {
    return StreakEntity(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      totalFocusSeconds: data.totalFocusSeconds.present
          ? data.totalFocusSeconds.value
          : this.totalFocusSeconds,
      sessionCount: data.sessionCount.present
          ? data.sessionCount.value
          : this.sessionCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreakEntity(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalFocusSeconds: $totalFocusSeconds, ')
          ..write('sessionCount: $sessionCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, totalFocusSeconds, sessionCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreakEntity &&
          other.id == this.id &&
          other.date == this.date &&
          other.totalFocusSeconds == this.totalFocusSeconds &&
          other.sessionCount == this.sessionCount);
}

class StreaksTableCompanion extends UpdateCompanion<StreakEntity> {
  final Value<String> id;
  final Value<String> date;
  final Value<int> totalFocusSeconds;
  final Value<int> sessionCount;
  final Value<int> rowid;
  const StreaksTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.totalFocusSeconds = const Value.absent(),
    this.sessionCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StreaksTableCompanion.insert({
    required String id,
    required String date,
    this.totalFocusSeconds = const Value.absent(),
    this.sessionCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date);
  static Insertable<StreakEntity> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<int>? totalFocusSeconds,
    Expression<int>? sessionCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (totalFocusSeconds != null) 'total_focus_seconds': totalFocusSeconds,
      if (sessionCount != null) 'session_count': sessionCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StreaksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<int>? totalFocusSeconds,
    Value<int>? sessionCount,
    Value<int>? rowid,
  }) {
    return StreaksTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      totalFocusSeconds: totalFocusSeconds ?? this.totalFocusSeconds,
      sessionCount: sessionCount ?? this.sessionCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (totalFocusSeconds.present) {
      map['total_focus_seconds'] = Variable<int>(totalFocusSeconds.value);
    }
    if (sessionCount.present) {
      map['session_count'] = Variable<int>(sessionCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalFocusSeconds: $totalFocusSeconds, ')
          ..write('sessionCount: $sessionCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChapterNotesTableTable extends ChapterNotesTable
    with TableInfo<$ChapterNotesTableTable, ChapterNoteEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChapterNotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    note,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapter_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChapterNoteEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChapterNoteEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterNoteEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ChapterNotesTableTable createAlias(String alias) {
    return $ChapterNotesTableTable(attachedDatabase, alias);
  }
}

class ChapterNoteEntity extends DataClass
    implements Insertable<ChapterNoteEntity> {
  final String id;
  final String chapterId;
  final String note;
  final int createdAt;
  final int updatedAt;
  const ChapterNoteEntity({
    required this.id,
    required this.chapterId,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['note'] = Variable<String>(note);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ChapterNotesTableCompanion toCompanion(bool nullToAbsent) {
    return ChapterNotesTableCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      note: Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChapterNoteEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterNoteEntity(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      note: serializer.fromJson<String>(json['note']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'note': serializer.toJson<String>(note),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ChapterNoteEntity copyWith({
    String? id,
    String? chapterId,
    String? note,
    int? createdAt,
    int? updatedAt,
  }) => ChapterNoteEntity(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    note: note ?? this.note,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChapterNoteEntity copyWithCompanion(ChapterNotesTableCompanion data) {
    return ChapterNoteEntity(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterNoteEntity(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chapterId, note, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterNoteEntity &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChapterNotesTableCompanion extends UpdateCompanion<ChapterNoteEntity> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String> note;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ChapterNotesTableCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChapterNotesTableCompanion.insert({
    required String id,
    required String chapterId,
    required String note,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       chapterId = Value(chapterId),
       note = Value(note),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChapterNoteEntity> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<String>? note,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChapterNotesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? chapterId,
    Value<String>? note,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ChapterNotesTableCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChapterNotesTableCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MaterialsTableTable materialsTable = $MaterialsTableTable(this);
  late final $ChaptersTableTable chaptersTable = $ChaptersTableTable(this);
  late final $FocusSessionsTableTable focusSessionsTable =
      $FocusSessionsTableTable(this);
  late final $ProgressSnapshotsTableTable progressSnapshotsTable =
      $ProgressSnapshotsTableTable(this);
  late final $StreaksTableTable streaksTable = $StreaksTableTable(this);
  late final $ChapterNotesTableTable chapterNotesTable =
      $ChapterNotesTableTable(this);
  late final Index chaptersMaterialIdx = Index(
    'chapters_material_idx',
    'CREATE INDEX chapters_material_idx ON chapters (material_id)',
  );
  late final Index focusSessionsStartedIdx = Index(
    'focus_sessions_started_idx',
    'CREATE INDEX focus_sessions_started_idx ON focus_sessions (started_at)',
  );
  late final Index streaksDateIdx = Index(
    'streaks_date_idx',
    'CREATE INDEX streaks_date_idx ON streaks (date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    materialsTable,
    chaptersTable,
    focusSessionsTable,
    progressSnapshotsTable,
    streaksTable,
    chapterNotesTable,
    chaptersMaterialIdx,
    focusSessionsStartedIdx,
    streaksDateIdx,
  ];
}

typedef $$MaterialsTableTableCreateCompanionBuilder =
    MaterialsTableCompanion Function({
      required String id,
      required String title,
      Value<String?> author,
      required String type,
      Value<String?> filePath,
      Value<String?> thumbnailPath,
      Value<int?> totalDuration,
      Value<int?> totalPages,
      required int createdAt,
      Value<String> status,
      Value<String?> tags,
      Value<int> rowid,
    });
typedef $$MaterialsTableTableUpdateCompanionBuilder =
    MaterialsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> author,
      Value<String> type,
      Value<String?> filePath,
      Value<String?> thumbnailPath,
      Value<int?> totalDuration,
      Value<int?> totalPages,
      Value<int> createdAt,
      Value<String> status,
      Value<String?> tags,
      Value<int> rowid,
    });

final class $$MaterialsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $MaterialsTableTable, MaterialEntity> {
  $$MaterialsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ChaptersTableTable, List<ChapterEntity>>
  _chaptersTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chaptersTable,
    aliasName: $_aliasNameGenerator(
      db.materialsTable.id,
      db.chaptersTable.materialId,
    ),
  );

  $$ChaptersTableTableProcessedTableManager get chaptersTableRefs {
    final manager = $$ChaptersTableTableTableManager(
      $_db,
      $_db.chaptersTable,
    ).filter((f) => f.materialId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTableTable, List<FocusSessionEntity>>
  _focusSessionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.focusSessionsTable,
        aliasName: $_aliasNameGenerator(
          db.materialsTable.id,
          db.focusSessionsTable.materialId,
        ),
      );

  $$FocusSessionsTableTableProcessedTableManager get focusSessionsTableRefs {
    final manager = $$FocusSessionsTableTableTableManager(
      $_db,
      $_db.focusSessionsTable,
    ).filter((f) => f.materialId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _focusSessionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ProgressSnapshotsTableTable,
    List<ProgressSnapshotEntity>
  >
  _progressSnapshotsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.progressSnapshotsTable,
        aliasName: $_aliasNameGenerator(
          db.materialsTable.id,
          db.progressSnapshotsTable.materialId,
        ),
      );

  $$ProgressSnapshotsTableTableProcessedTableManager
  get progressSnapshotsTableRefs {
    final manager = $$ProgressSnapshotsTableTableTableManager(
      $_db,
      $_db.progressSnapshotsTable,
    ).filter((f) => f.materialId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _progressSnapshotsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MaterialsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MaterialsTableTable> {
  $$MaterialsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chaptersTableRefs(
    Expression<bool> Function($$ChaptersTableTableFilterComposer f) f,
  ) {
    final $$ChaptersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.materialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableFilterComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> focusSessionsTableRefs(
    Expression<bool> Function($$FocusSessionsTableTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessionsTable,
      getReferencedColumn: (t) => t.materialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableTableFilterComposer(
            $db: $db,
            $table: $db.focusSessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> progressSnapshotsTableRefs(
    Expression<bool> Function($$ProgressSnapshotsTableTableFilterComposer f) f,
  ) {
    final $$ProgressSnapshotsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.progressSnapshotsTable,
          getReferencedColumn: (t) => t.materialId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProgressSnapshotsTableTableFilterComposer(
                $db: $db,
                $table: $db.progressSnapshotsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MaterialsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MaterialsTableTable> {
  $$MaterialsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MaterialsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaterialsTableTable> {
  $$MaterialsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalDuration => $composableBuilder(
    column: $table.totalDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  Expression<T> chaptersTableRefs<T extends Object>(
    Expression<T> Function($$ChaptersTableTableAnnotationComposer a) f,
  ) {
    final $$ChaptersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.materialId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> focusSessionsTableRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.focusSessionsTable,
          getReferencedColumn: (t) => t.materialId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FocusSessionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.focusSessionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> progressSnapshotsTableRefs<T extends Object>(
    Expression<T> Function($$ProgressSnapshotsTableTableAnnotationComposer a) f,
  ) {
    final $$ProgressSnapshotsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.progressSnapshotsTable,
          getReferencedColumn: (t) => t.materialId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProgressSnapshotsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.progressSnapshotsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MaterialsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MaterialsTableTable,
          MaterialEntity,
          $$MaterialsTableTableFilterComposer,
          $$MaterialsTableTableOrderingComposer,
          $$MaterialsTableTableAnnotationComposer,
          $$MaterialsTableTableCreateCompanionBuilder,
          $$MaterialsTableTableUpdateCompanionBuilder,
          (MaterialEntity, $$MaterialsTableTableReferences),
          MaterialEntity,
          PrefetchHooks Function({
            bool chaptersTableRefs,
            bool focusSessionsTableRefs,
            bool progressSnapshotsTableRefs,
          })
        > {
  $$MaterialsTableTableTableManager(
    _$AppDatabase db,
    $MaterialsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaterialsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaterialsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaterialsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<int?> totalDuration = const Value.absent(),
                Value<int?> totalPages = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaterialsTableCompanion(
                id: id,
                title: title,
                author: author,
                type: type,
                filePath: filePath,
                thumbnailPath: thumbnailPath,
                totalDuration: totalDuration,
                totalPages: totalPages,
                createdAt: createdAt,
                status: status,
                tags: tags,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> author = const Value.absent(),
                required String type,
                Value<String?> filePath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<int?> totalDuration = const Value.absent(),
                Value<int?> totalPages = const Value.absent(),
                required int createdAt,
                Value<String> status = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaterialsTableCompanion.insert(
                id: id,
                title: title,
                author: author,
                type: type,
                filePath: filePath,
                thumbnailPath: thumbnailPath,
                totalDuration: totalDuration,
                totalPages: totalPages,
                createdAt: createdAt,
                status: status,
                tags: tags,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MaterialsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chaptersTableRefs = false,
                focusSessionsTableRefs = false,
                progressSnapshotsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chaptersTableRefs) db.chaptersTable,
                    if (focusSessionsTableRefs) db.focusSessionsTable,
                    if (progressSnapshotsTableRefs) db.progressSnapshotsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chaptersTableRefs)
                        await $_getPrefetchedData<
                          MaterialEntity,
                          $MaterialsTableTable,
                          ChapterEntity
                        >(
                          currentTable: table,
                          referencedTable: $$MaterialsTableTableReferences
                              ._chaptersTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MaterialsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).chaptersTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.materialId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (focusSessionsTableRefs)
                        await $_getPrefetchedData<
                          MaterialEntity,
                          $MaterialsTableTable,
                          FocusSessionEntity
                        >(
                          currentTable: table,
                          referencedTable: $$MaterialsTableTableReferences
                              ._focusSessionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MaterialsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.materialId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (progressSnapshotsTableRefs)
                        await $_getPrefetchedData<
                          MaterialEntity,
                          $MaterialsTableTable,
                          ProgressSnapshotEntity
                        >(
                          currentTable: table,
                          referencedTable: $$MaterialsTableTableReferences
                              ._progressSnapshotsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MaterialsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).progressSnapshotsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.materialId == item.id,
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

typedef $$MaterialsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MaterialsTableTable,
      MaterialEntity,
      $$MaterialsTableTableFilterComposer,
      $$MaterialsTableTableOrderingComposer,
      $$MaterialsTableTableAnnotationComposer,
      $$MaterialsTableTableCreateCompanionBuilder,
      $$MaterialsTableTableUpdateCompanionBuilder,
      (MaterialEntity, $$MaterialsTableTableReferences),
      MaterialEntity,
      PrefetchHooks Function({
        bool chaptersTableRefs,
        bool focusSessionsTableRefs,
        bool progressSnapshotsTableRefs,
      })
    >;
typedef $$ChaptersTableTableCreateCompanionBuilder =
    ChaptersTableCompanion Function({
      required String id,
      required String materialId,
      required String title,
      Value<String?> parentId,
      required int orderIndex,
      Value<int?> pageStart,
      Value<int?> pageEnd,
      Value<int?> duration,
      Value<String?> filePath,
      Value<bool> isCompleted,
      Value<int?> completedAt,
      Value<int> rowid,
    });
typedef $$ChaptersTableTableUpdateCompanionBuilder =
    ChaptersTableCompanion Function({
      Value<String> id,
      Value<String> materialId,
      Value<String> title,
      Value<String?> parentId,
      Value<int> orderIndex,
      Value<int?> pageStart,
      Value<int?> pageEnd,
      Value<int?> duration,
      Value<String?> filePath,
      Value<bool> isCompleted,
      Value<int?> completedAt,
      Value<int> rowid,
    });

final class $$ChaptersTableTableReferences
    extends BaseReferences<_$AppDatabase, $ChaptersTableTable, ChapterEntity> {
  $$ChaptersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MaterialsTableTable _materialIdTable(_$AppDatabase db) =>
      db.materialsTable.createAlias(
        $_aliasNameGenerator(db.chaptersTable.materialId, db.materialsTable.id),
      );

  $$MaterialsTableTableProcessedTableManager get materialId {
    final $_column = $_itemColumn<String>('material_id')!;

    final manager = $$MaterialsTableTableTableManager(
      $_db,
      $_db.materialsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_materialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTableTable, List<FocusSessionEntity>>
  _focusSessionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.focusSessionsTable,
        aliasName: $_aliasNameGenerator(
          db.chaptersTable.id,
          db.focusSessionsTable.chapterId,
        ),
      );

  $$FocusSessionsTableTableProcessedTableManager get focusSessionsTableRefs {
    final manager = $$FocusSessionsTableTableTableManager(
      $_db,
      $_db.focusSessionsTable,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _focusSessionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ProgressSnapshotsTableTable,
    List<ProgressSnapshotEntity>
  >
  _progressSnapshotsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.progressSnapshotsTable,
        aliasName: $_aliasNameGenerator(
          db.chaptersTable.id,
          db.progressSnapshotsTable.chapterId,
        ),
      );

  $$ProgressSnapshotsTableTableProcessedTableManager
  get progressSnapshotsTableRefs {
    final manager = $$ProgressSnapshotsTableTableTableManager(
      $_db,
      $_db.progressSnapshotsTable,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _progressSnapshotsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChapterNotesTableTable, List<ChapterNoteEntity>>
  _chapterNotesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.chapterNotesTable,
        aliasName: $_aliasNameGenerator(
          db.chaptersTable.id,
          db.chapterNotesTable.chapterId,
        ),
      );

  $$ChapterNotesTableTableProcessedTableManager get chapterNotesTableRefs {
    final manager = $$ChapterNotesTableTableTableManager(
      $_db,
      $_db.chapterNotesTable,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _chapterNotesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChaptersTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageStart => $composableBuilder(
    column: $table.pageStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageEnd => $composableBuilder(
    column: $table.pageEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MaterialsTableTableFilterComposer get materialId {
    final $$MaterialsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.materialsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableTableFilterComposer(
            $db: $db,
            $table: $db.materialsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> focusSessionsTableRefs(
    Expression<bool> Function($$FocusSessionsTableTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessionsTable,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableTableFilterComposer(
            $db: $db,
            $table: $db.focusSessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> progressSnapshotsTableRefs(
    Expression<bool> Function($$ProgressSnapshotsTableTableFilterComposer f) f,
  ) {
    final $$ProgressSnapshotsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.progressSnapshotsTable,
          getReferencedColumn: (t) => t.chapterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProgressSnapshotsTableTableFilterComposer(
                $db: $db,
                $table: $db.progressSnapshotsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> chapterNotesTableRefs(
    Expression<bool> Function($$ChapterNotesTableTableFilterComposer f) f,
  ) {
    final $$ChapterNotesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapterNotesTable,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChapterNotesTableTableFilterComposer(
            $db: $db,
            $table: $db.chapterNotesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageStart => $composableBuilder(
    column: $table.pageStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageEnd => $composableBuilder(
    column: $table.pageEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MaterialsTableTableOrderingComposer get materialId {
    final $$MaterialsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.materialsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableTableOrderingComposer(
            $db: $db,
            $table: $db.materialsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageStart =>
      $composableBuilder(column: $table.pageStart, builder: (column) => column);

  GeneratedColumn<int> get pageEnd =>
      $composableBuilder(column: $table.pageEnd, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$MaterialsTableTableAnnotationComposer get materialId {
    final $$MaterialsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.materialsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.materialsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> focusSessionsTableRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.focusSessionsTable,
          getReferencedColumn: (t) => t.chapterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FocusSessionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.focusSessionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> progressSnapshotsTableRefs<T extends Object>(
    Expression<T> Function($$ProgressSnapshotsTableTableAnnotationComposer a) f,
  ) {
    final $$ProgressSnapshotsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.progressSnapshotsTable,
          getReferencedColumn: (t) => t.chapterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProgressSnapshotsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.progressSnapshotsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> chapterNotesTableRefs<T extends Object>(
    Expression<T> Function($$ChapterNotesTableTableAnnotationComposer a) f,
  ) {
    final $$ChapterNotesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.chapterNotesTable,
          getReferencedColumn: (t) => t.chapterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ChapterNotesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.chapterNotesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ChaptersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTableTable,
          ChapterEntity,
          $$ChaptersTableTableFilterComposer,
          $$ChaptersTableTableOrderingComposer,
          $$ChaptersTableTableAnnotationComposer,
          $$ChaptersTableTableCreateCompanionBuilder,
          $$ChaptersTableTableUpdateCompanionBuilder,
          (ChapterEntity, $$ChaptersTableTableReferences),
          ChapterEntity,
          PrefetchHooks Function({
            bool materialId,
            bool focusSessionsTableRefs,
            bool progressSnapshotsTableRefs,
            bool chapterNotesTableRefs,
          })
        > {
  $$ChaptersTableTableTableManager(_$AppDatabase db, $ChaptersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> materialId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int?> pageStart = const Value.absent(),
                Value<int?> pageEnd = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersTableCompanion(
                id: id,
                materialId: materialId,
                title: title,
                parentId: parentId,
                orderIndex: orderIndex,
                pageStart: pageStart,
                pageEnd: pageEnd,
                duration: duration,
                filePath: filePath,
                isCompleted: isCompleted,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String materialId,
                required String title,
                Value<String?> parentId = const Value.absent(),
                required int orderIndex,
                Value<int?> pageStart = const Value.absent(),
                Value<int?> pageEnd = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> filePath = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersTableCompanion.insert(
                id: id,
                materialId: materialId,
                title: title,
                parentId: parentId,
                orderIndex: orderIndex,
                pageStart: pageStart,
                pageEnd: pageEnd,
                duration: duration,
                filePath: filePath,
                isCompleted: isCompleted,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChaptersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                materialId = false,
                focusSessionsTableRefs = false,
                progressSnapshotsTableRefs = false,
                chapterNotesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (focusSessionsTableRefs) db.focusSessionsTable,
                    if (progressSnapshotsTableRefs) db.progressSnapshotsTable,
                    if (chapterNotesTableRefs) db.chapterNotesTable,
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
                        if (materialId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.materialId,
                                    referencedTable:
                                        $$ChaptersTableTableReferences
                                            ._materialIdTable(db),
                                    referencedColumn:
                                        $$ChaptersTableTableReferences
                                            ._materialIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (focusSessionsTableRefs)
                        await $_getPrefetchedData<
                          ChapterEntity,
                          $ChaptersTableTable,
                          FocusSessionEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableTableReferences
                              ._focusSessionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (progressSnapshotsTableRefs)
                        await $_getPrefetchedData<
                          ChapterEntity,
                          $ChaptersTableTable,
                          ProgressSnapshotEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableTableReferences
                              ._progressSnapshotsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).progressSnapshotsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (chapterNotesTableRefs)
                        await $_getPrefetchedData<
                          ChapterEntity,
                          $ChaptersTableTable,
                          ChapterNoteEntity
                        >(
                          currentTable: table,
                          referencedTable: $$ChaptersTableTableReferences
                              ._chapterNotesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChaptersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).chapterNotesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.chapterId == item.id,
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

typedef $$ChaptersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTableTable,
      ChapterEntity,
      $$ChaptersTableTableFilterComposer,
      $$ChaptersTableTableOrderingComposer,
      $$ChaptersTableTableAnnotationComposer,
      $$ChaptersTableTableCreateCompanionBuilder,
      $$ChaptersTableTableUpdateCompanionBuilder,
      (ChapterEntity, $$ChaptersTableTableReferences),
      ChapterEntity,
      PrefetchHooks Function({
        bool materialId,
        bool focusSessionsTableRefs,
        bool progressSnapshotsTableRefs,
        bool chapterNotesTableRefs,
      })
    >;
typedef $$FocusSessionsTableTableCreateCompanionBuilder =
    FocusSessionsTableCompanion Function({
      required String id,
      required String materialId,
      Value<String?> chapterId,
      required int startedAt,
      Value<int?> endedAt,
      required int durationSeconds,
      required String status,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableTableUpdateCompanionBuilder =
    FocusSessionsTableCompanion Function({
      Value<String> id,
      Value<String> materialId,
      Value<String?> chapterId,
      Value<int> startedAt,
      Value<int?> endedAt,
      Value<int> durationSeconds,
      Value<String> status,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$FocusSessionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FocusSessionsTableTable,
          FocusSessionEntity
        > {
  $$FocusSessionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MaterialsTableTable _materialIdTable(_$AppDatabase db) =>
      db.materialsTable.createAlias(
        $_aliasNameGenerator(
          db.focusSessionsTable.materialId,
          db.materialsTable.id,
        ),
      );

  $$MaterialsTableTableProcessedTableManager get materialId {
    final $_column = $_itemColumn<String>('material_id')!;

    final manager = $$MaterialsTableTableTableManager(
      $_db,
      $_db.materialsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_materialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChaptersTableTable _chapterIdTable(_$AppDatabase db) =>
      db.chaptersTable.createAlias(
        $_aliasNameGenerator(
          db.focusSessionsTable.chapterId,
          db.chaptersTable.id,
        ),
      );

  $$ChaptersTableTableProcessedTableManager? get chapterId {
    final $_column = $_itemColumn<String>('chapter_id');
    if ($_column == null) return null;
    final manager = $$ChaptersTableTableTableManager(
      $_db,
      $_db.chaptersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FocusSessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTableTable> {
  $$FocusSessionsTableTableFilterComposer({
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

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$MaterialsTableTableFilterComposer get materialId {
    final $$MaterialsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.materialsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableTableFilterComposer(
            $db: $db,
            $table: $db.materialsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableTableFilterComposer get chapterId {
    final $$ChaptersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableFilterComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTableTable> {
  $$FocusSessionsTableTableOrderingComposer({
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

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$MaterialsTableTableOrderingComposer get materialId {
    final $$MaterialsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.materialsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableTableOrderingComposer(
            $db: $db,
            $table: $db.materialsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableTableOrderingComposer get chapterId {
    final $$ChaptersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableOrderingComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTableTable> {
  $$FocusSessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$MaterialsTableTableAnnotationComposer get materialId {
    final $$MaterialsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.materialsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.materialsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableTableAnnotationComposer get chapterId {
    final $$ChaptersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTableTable,
          FocusSessionEntity,
          $$FocusSessionsTableTableFilterComposer,
          $$FocusSessionsTableTableOrderingComposer,
          $$FocusSessionsTableTableAnnotationComposer,
          $$FocusSessionsTableTableCreateCompanionBuilder,
          $$FocusSessionsTableTableUpdateCompanionBuilder,
          (FocusSessionEntity, $$FocusSessionsTableTableReferences),
          FocusSessionEntity,
          PrefetchHooks Function({bool materialId, bool chapterId})
        > {
  $$FocusSessionsTableTableTableManager(
    _$AppDatabase db,
    $FocusSessionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> materialId = const Value.absent(),
                Value<String?> chapterId = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> endedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsTableCompanion(
                id: id,
                materialId: materialId,
                chapterId: chapterId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                status: status,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String materialId,
                Value<String?> chapterId = const Value.absent(),
                required int startedAt,
                Value<int?> endedAt = const Value.absent(),
                required int durationSeconds,
                required String status,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsTableCompanion.insert(
                id: id,
                materialId: materialId,
                chapterId: chapterId,
                startedAt: startedAt,
                endedAt: endedAt,
                durationSeconds: durationSeconds,
                status: status,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FocusSessionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({materialId = false, chapterId = false}) {
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
                    if (materialId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.materialId,
                                referencedTable:
                                    $$FocusSessionsTableTableReferences
                                        ._materialIdTable(db),
                                referencedColumn:
                                    $$FocusSessionsTableTableReferences
                                        ._materialIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable:
                                    $$FocusSessionsTableTableReferences
                                        ._chapterIdTable(db),
                                referencedColumn:
                                    $$FocusSessionsTableTableReferences
                                        ._chapterIdTable(db)
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

typedef $$FocusSessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTableTable,
      FocusSessionEntity,
      $$FocusSessionsTableTableFilterComposer,
      $$FocusSessionsTableTableOrderingComposer,
      $$FocusSessionsTableTableAnnotationComposer,
      $$FocusSessionsTableTableCreateCompanionBuilder,
      $$FocusSessionsTableTableUpdateCompanionBuilder,
      (FocusSessionEntity, $$FocusSessionsTableTableReferences),
      FocusSessionEntity,
      PrefetchHooks Function({bool materialId, bool chapterId})
    >;
typedef $$ProgressSnapshotsTableTableCreateCompanionBuilder =
    ProgressSnapshotsTableCompanion Function({
      required String id,
      required String materialId,
      Value<String?> chapterId,
      required int snapshotAt,
      required double percentComplete,
      Value<int?> lastPositionSeconds,
      Value<int> rowid,
    });
typedef $$ProgressSnapshotsTableTableUpdateCompanionBuilder =
    ProgressSnapshotsTableCompanion Function({
      Value<String> id,
      Value<String> materialId,
      Value<String?> chapterId,
      Value<int> snapshotAt,
      Value<double> percentComplete,
      Value<int?> lastPositionSeconds,
      Value<int> rowid,
    });

final class $$ProgressSnapshotsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProgressSnapshotsTableTable,
          ProgressSnapshotEntity
        > {
  $$ProgressSnapshotsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MaterialsTableTable _materialIdTable(_$AppDatabase db) =>
      db.materialsTable.createAlias(
        $_aliasNameGenerator(
          db.progressSnapshotsTable.materialId,
          db.materialsTable.id,
        ),
      );

  $$MaterialsTableTableProcessedTableManager get materialId {
    final $_column = $_itemColumn<String>('material_id')!;

    final manager = $$MaterialsTableTableTableManager(
      $_db,
      $_db.materialsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_materialIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ChaptersTableTable _chapterIdTable(_$AppDatabase db) =>
      db.chaptersTable.createAlias(
        $_aliasNameGenerator(
          db.progressSnapshotsTable.chapterId,
          db.chaptersTable.id,
        ),
      );

  $$ChaptersTableTableProcessedTableManager? get chapterId {
    final $_column = $_itemColumn<String>('chapter_id');
    if ($_column == null) return null;
    final manager = $$ChaptersTableTableTableManager(
      $_db,
      $_db.chaptersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProgressSnapshotsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressSnapshotsTableTable> {
  $$ProgressSnapshotsTableTableFilterComposer({
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

  ColumnFilters<int> get snapshotAt => $composableBuilder(
    column: $table.snapshotAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPositionSeconds => $composableBuilder(
    column: $table.lastPositionSeconds,
    builder: (column) => ColumnFilters(column),
  );

  $$MaterialsTableTableFilterComposer get materialId {
    final $$MaterialsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.materialsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableTableFilterComposer(
            $db: $db,
            $table: $db.materialsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableTableFilterComposer get chapterId {
    final $$ChaptersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableFilterComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressSnapshotsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressSnapshotsTableTable> {
  $$ProgressSnapshotsTableTableOrderingComposer({
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

  ColumnOrderings<int> get snapshotAt => $composableBuilder(
    column: $table.snapshotAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPositionSeconds => $composableBuilder(
    column: $table.lastPositionSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  $$MaterialsTableTableOrderingComposer get materialId {
    final $$MaterialsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.materialsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableTableOrderingComposer(
            $db: $db,
            $table: $db.materialsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableTableOrderingComposer get chapterId {
    final $$ChaptersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableOrderingComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressSnapshotsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressSnapshotsTableTable> {
  $$ProgressSnapshotsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get snapshotAt => $composableBuilder(
    column: $table.snapshotAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get percentComplete => $composableBuilder(
    column: $table.percentComplete,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastPositionSeconds => $composableBuilder(
    column: $table.lastPositionSeconds,
    builder: (column) => column,
  );

  $$MaterialsTableTableAnnotationComposer get materialId {
    final $$MaterialsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.materialId,
      referencedTable: $db.materialsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MaterialsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.materialsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ChaptersTableTableAnnotationComposer get chapterId {
    final $$ChaptersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressSnapshotsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressSnapshotsTableTable,
          ProgressSnapshotEntity,
          $$ProgressSnapshotsTableTableFilterComposer,
          $$ProgressSnapshotsTableTableOrderingComposer,
          $$ProgressSnapshotsTableTableAnnotationComposer,
          $$ProgressSnapshotsTableTableCreateCompanionBuilder,
          $$ProgressSnapshotsTableTableUpdateCompanionBuilder,
          (ProgressSnapshotEntity, $$ProgressSnapshotsTableTableReferences),
          ProgressSnapshotEntity,
          PrefetchHooks Function({bool materialId, bool chapterId})
        > {
  $$ProgressSnapshotsTableTableTableManager(
    _$AppDatabase db,
    $ProgressSnapshotsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressSnapshotsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ProgressSnapshotsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProgressSnapshotsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> materialId = const Value.absent(),
                Value<String?> chapterId = const Value.absent(),
                Value<int> snapshotAt = const Value.absent(),
                Value<double> percentComplete = const Value.absent(),
                Value<int?> lastPositionSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressSnapshotsTableCompanion(
                id: id,
                materialId: materialId,
                chapterId: chapterId,
                snapshotAt: snapshotAt,
                percentComplete: percentComplete,
                lastPositionSeconds: lastPositionSeconds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String materialId,
                Value<String?> chapterId = const Value.absent(),
                required int snapshotAt,
                required double percentComplete,
                Value<int?> lastPositionSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressSnapshotsTableCompanion.insert(
                id: id,
                materialId: materialId,
                chapterId: chapterId,
                snapshotAt: snapshotAt,
                percentComplete: percentComplete,
                lastPositionSeconds: lastPositionSeconds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProgressSnapshotsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({materialId = false, chapterId = false}) {
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
                    if (materialId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.materialId,
                                referencedTable:
                                    $$ProgressSnapshotsTableTableReferences
                                        ._materialIdTable(db),
                                referencedColumn:
                                    $$ProgressSnapshotsTableTableReferences
                                        ._materialIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable:
                                    $$ProgressSnapshotsTableTableReferences
                                        ._chapterIdTable(db),
                                referencedColumn:
                                    $$ProgressSnapshotsTableTableReferences
                                        ._chapterIdTable(db)
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

typedef $$ProgressSnapshotsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressSnapshotsTableTable,
      ProgressSnapshotEntity,
      $$ProgressSnapshotsTableTableFilterComposer,
      $$ProgressSnapshotsTableTableOrderingComposer,
      $$ProgressSnapshotsTableTableAnnotationComposer,
      $$ProgressSnapshotsTableTableCreateCompanionBuilder,
      $$ProgressSnapshotsTableTableUpdateCompanionBuilder,
      (ProgressSnapshotEntity, $$ProgressSnapshotsTableTableReferences),
      ProgressSnapshotEntity,
      PrefetchHooks Function({bool materialId, bool chapterId})
    >;
typedef $$StreaksTableTableCreateCompanionBuilder =
    StreaksTableCompanion Function({
      required String id,
      required String date,
      Value<int> totalFocusSeconds,
      Value<int> sessionCount,
      Value<int> rowid,
    });
typedef $$StreaksTableTableUpdateCompanionBuilder =
    StreaksTableCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<int> totalFocusSeconds,
      Value<int> sessionCount,
      Value<int> rowid,
    });

class $$StreaksTableTableFilterComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableFilterComposer({
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

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalFocusSeconds => $composableBuilder(
    column: $table.totalFocusSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessionCount => $composableBuilder(
    column: $table.sessionCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreaksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableOrderingComposer({
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

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalFocusSeconds => $composableBuilder(
    column: $table.totalFocusSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessionCount => $composableBuilder(
    column: $table.sessionCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreaksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalFocusSeconds => $composableBuilder(
    column: $table.totalFocusSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessionCount => $composableBuilder(
    column: $table.sessionCount,
    builder: (column) => column,
  );
}

class $$StreaksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreaksTableTable,
          StreakEntity,
          $$StreaksTableTableFilterComposer,
          $$StreaksTableTableOrderingComposer,
          $$StreaksTableTableAnnotationComposer,
          $$StreaksTableTableCreateCompanionBuilder,
          $$StreaksTableTableUpdateCompanionBuilder,
          (
            StreakEntity,
            BaseReferences<_$AppDatabase, $StreaksTableTable, StreakEntity>,
          ),
          StreakEntity,
          PrefetchHooks Function()
        > {
  $$StreaksTableTableTableManager(_$AppDatabase db, $StreaksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreaksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreaksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreaksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> totalFocusSeconds = const Value.absent(),
                Value<int> sessionCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StreaksTableCompanion(
                id: id,
                date: date,
                totalFocusSeconds: totalFocusSeconds,
                sessionCount: sessionCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                Value<int> totalFocusSeconds = const Value.absent(),
                Value<int> sessionCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StreaksTableCompanion.insert(
                id: id,
                date: date,
                totalFocusSeconds: totalFocusSeconds,
                sessionCount: sessionCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreaksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreaksTableTable,
      StreakEntity,
      $$StreaksTableTableFilterComposer,
      $$StreaksTableTableOrderingComposer,
      $$StreaksTableTableAnnotationComposer,
      $$StreaksTableTableCreateCompanionBuilder,
      $$StreaksTableTableUpdateCompanionBuilder,
      (
        StreakEntity,
        BaseReferences<_$AppDatabase, $StreaksTableTable, StreakEntity>,
      ),
      StreakEntity,
      PrefetchHooks Function()
    >;
typedef $$ChapterNotesTableTableCreateCompanionBuilder =
    ChapterNotesTableCompanion Function({
      required String id,
      required String chapterId,
      required String note,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ChapterNotesTableTableUpdateCompanionBuilder =
    ChapterNotesTableCompanion Function({
      Value<String> id,
      Value<String> chapterId,
      Value<String> note,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$ChapterNotesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChapterNotesTableTable,
          ChapterNoteEntity
        > {
  $$ChapterNotesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChaptersTableTable _chapterIdTable(_$AppDatabase db) =>
      db.chaptersTable.createAlias(
        $_aliasNameGenerator(
          db.chapterNotesTable.chapterId,
          db.chaptersTable.id,
        ),
      );

  $$ChaptersTableTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager = $$ChaptersTableTableTableManager(
      $_db,
      $_db.chaptersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChapterNotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChapterNotesTableTable> {
  $$ChapterNotesTableTableFilterComposer({
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

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChaptersTableTableFilterComposer get chapterId {
    final $$ChaptersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableFilterComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChapterNotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChapterNotesTableTable> {
  $$ChapterNotesTableTableOrderingComposer({
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

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChaptersTableTableOrderingComposer get chapterId {
    final $$ChaptersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableOrderingComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChapterNotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChapterNotesTableTable> {
  $$ChapterNotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ChaptersTableTableAnnotationComposer get chapterId {
    final $$ChaptersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChapterNotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChapterNotesTableTable,
          ChapterNoteEntity,
          $$ChapterNotesTableTableFilterComposer,
          $$ChapterNotesTableTableOrderingComposer,
          $$ChapterNotesTableTableAnnotationComposer,
          $$ChapterNotesTableTableCreateCompanionBuilder,
          $$ChapterNotesTableTableUpdateCompanionBuilder,
          (ChapterNoteEntity, $$ChapterNotesTableTableReferences),
          ChapterNoteEntity,
          PrefetchHooks Function({bool chapterId})
        > {
  $$ChapterNotesTableTableTableManager(
    _$AppDatabase db,
    $ChapterNotesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChapterNotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChapterNotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChapterNotesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChapterNotesTableCompanion(
                id: id,
                chapterId: chapterId,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String chapterId,
                required String note,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ChapterNotesTableCompanion.insert(
                id: id,
                chapterId: chapterId,
                note: note,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChapterNotesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chapterId = false}) {
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
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable:
                                    $$ChapterNotesTableTableReferences
                                        ._chapterIdTable(db),
                                referencedColumn:
                                    $$ChapterNotesTableTableReferences
                                        ._chapterIdTable(db)
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

typedef $$ChapterNotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChapterNotesTableTable,
      ChapterNoteEntity,
      $$ChapterNotesTableTableFilterComposer,
      $$ChapterNotesTableTableOrderingComposer,
      $$ChapterNotesTableTableAnnotationComposer,
      $$ChapterNotesTableTableCreateCompanionBuilder,
      $$ChapterNotesTableTableUpdateCompanionBuilder,
      (ChapterNoteEntity, $$ChapterNotesTableTableReferences),
      ChapterNoteEntity,
      PrefetchHooks Function({bool chapterId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MaterialsTableTableTableManager get materialsTable =>
      $$MaterialsTableTableTableManager(_db, _db.materialsTable);
  $$ChaptersTableTableTableManager get chaptersTable =>
      $$ChaptersTableTableTableManager(_db, _db.chaptersTable);
  $$FocusSessionsTableTableTableManager get focusSessionsTable =>
      $$FocusSessionsTableTableTableManager(_db, _db.focusSessionsTable);
  $$ProgressSnapshotsTableTableTableManager get progressSnapshotsTable =>
      $$ProgressSnapshotsTableTableTableManager(
        _db,
        _db.progressSnapshotsTable,
      );
  $$StreaksTableTableTableManager get streaksTable =>
      $$StreaksTableTableTableManager(_db, _db.streaksTable);
  $$ChapterNotesTableTableTableManager get chapterNotesTable =>
      $$ChapterNotesTableTableTableManager(_db, _db.chapterNotesTable);
}
