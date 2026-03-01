// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_checkin_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyCheckInRecordCollection on Isar {
  IsarCollection<DailyCheckInRecord> get dailyCheckInRecords =>
      this.collection();
}

const DailyCheckInRecordSchema = CollectionSchema(
  name: r'DailyCheckInRecord',
  id: 4096539654204961486,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'energy': PropertySchema(id: 1, name: r'energy', type: IsarType.long),
    r'localDateKey': PropertySchema(
      id: 2,
      name: r'localDateKey',
      type: IsarType.string,
    ),
    r'mood': PropertySchema(id: 3, name: r'mood', type: IsarType.long),
    r'note': PropertySchema(id: 4, name: r'note', type: IsarType.string),
  },
  estimateSize: _dailyCheckInRecordEstimateSize,
  serialize: _dailyCheckInRecordSerialize,
  deserialize: _dailyCheckInRecordDeserialize,
  deserializeProp: _dailyCheckInRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'localDateKey': IndexSchema(
      id: -4285120956082274571,
      name: r'localDateKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'localDateKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyCheckInRecordGetId,
  getLinks: _dailyCheckInRecordGetLinks,
  attach: _dailyCheckInRecordAttach,
  version: '3.1.0+1',
);

int _dailyCheckInRecordEstimateSize(
  DailyCheckInRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.localDateKey.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _dailyCheckInRecordSerialize(
  DailyCheckInRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.energy);
  writer.writeString(offsets[2], object.localDateKey);
  writer.writeLong(offsets[3], object.mood);
  writer.writeString(offsets[4], object.note);
}

DailyCheckInRecord _dailyCheckInRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyCheckInRecord();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.energy = reader.readLong(offsets[1]);
  object.id = id;
  object.localDateKey = reader.readString(offsets[2]);
  object.mood = reader.readLong(offsets[3]);
  object.note = reader.readStringOrNull(offsets[4]);
  return object;
}

P _dailyCheckInRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyCheckInRecordGetId(DailyCheckInRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyCheckInRecordGetLinks(
  DailyCheckInRecord object,
) {
  return [];
}

void _dailyCheckInRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  DailyCheckInRecord object,
) {
  object.id = id;
}

extension DailyCheckInRecordByIndex on IsarCollection<DailyCheckInRecord> {
  Future<DailyCheckInRecord?> getByLocalDateKey(String localDateKey) {
    return getByIndex(r'localDateKey', [localDateKey]);
  }

  DailyCheckInRecord? getByLocalDateKeySync(String localDateKey) {
    return getByIndexSync(r'localDateKey', [localDateKey]);
  }

  Future<bool> deleteByLocalDateKey(String localDateKey) {
    return deleteByIndex(r'localDateKey', [localDateKey]);
  }

  bool deleteByLocalDateKeySync(String localDateKey) {
    return deleteByIndexSync(r'localDateKey', [localDateKey]);
  }

  Future<List<DailyCheckInRecord?>> getAllByLocalDateKey(
    List<String> localDateKeyValues,
  ) {
    final values = localDateKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'localDateKey', values);
  }

  List<DailyCheckInRecord?> getAllByLocalDateKeySync(
    List<String> localDateKeyValues,
  ) {
    final values = localDateKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'localDateKey', values);
  }

  Future<int> deleteAllByLocalDateKey(List<String> localDateKeyValues) {
    final values = localDateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'localDateKey', values);
  }

  int deleteAllByLocalDateKeySync(List<String> localDateKeyValues) {
    final values = localDateKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'localDateKey', values);
  }

  Future<Id> putByLocalDateKey(DailyCheckInRecord object) {
    return putByIndex(r'localDateKey', object);
  }

  Id putByLocalDateKeySync(DailyCheckInRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'localDateKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByLocalDateKey(List<DailyCheckInRecord> objects) {
    return putAllByIndex(r'localDateKey', objects);
  }

  List<Id> putAllByLocalDateKeySync(
    List<DailyCheckInRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'localDateKey', objects, saveLinks: saveLinks);
  }
}

extension DailyCheckInRecordQueryWhereSort
    on QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QWhere> {
  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhere>
  anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension DailyCheckInRecordQueryWhere
    on QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QWhereClause> {
  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  localDateKeyEqualTo(String localDateKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'localDateKey',
          value: [localDateKey],
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  localDateKeyNotEqualTo(String localDateKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'localDateKey',
                lower: [],
                upper: [localDateKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'localDateKey',
                lower: [localDateKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'localDateKey',
                lower: [localDateKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'localDateKey',
                lower: [],
                upper: [localDateKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  createdAtGreaterThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [createdAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  createdAtLessThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [],
          upper: [createdAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterWhereClause>
  createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [lowerCreatedAt],
          includeLower: includeLower,
          upper: [upperCreatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DailyCheckInRecordQueryFilter
    on QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QFilterCondition> {
  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  energyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'energy', value: value),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  energyGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'energy',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  energyLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'energy',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  energyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'energy',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localDateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localDateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localDateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localDateKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'localDateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'localDateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'localDateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'localDateKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'localDateKey', value: ''),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  localDateKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'localDateKey', value: ''),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  moodEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mood', value: value),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  moodGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  moodLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  moodBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mood',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'note',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'note',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterFilterCondition>
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }
}

extension DailyCheckInRecordQueryObject
    on QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QFilterCondition> {}

extension DailyCheckInRecordQueryLinks
    on QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QFilterCondition> {}

extension DailyCheckInRecordQuerySortBy
    on QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QSortBy> {
  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.desc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByLocalDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localDateKey', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByLocalDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localDateKey', Sort.desc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension DailyCheckInRecordQuerySortThenBy
    on QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QSortThenBy> {
  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energy', Sort.desc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByLocalDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localDateKey', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByLocalDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localDateKey', Sort.desc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QAfterSortBy>
  thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }
}

extension DailyCheckInRecordQueryWhereDistinct
    on QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QDistinct> {
  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QDistinct>
  distinctByEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energy');
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QDistinct>
  distinctByLocalDateKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localDateKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QDistinct>
  distinctByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mood');
    });
  }

  QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QDistinct>
  distinctByNote({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }
}

extension DailyCheckInRecordQueryProperty
    on QueryBuilder<DailyCheckInRecord, DailyCheckInRecord, QQueryProperty> {
  QueryBuilder<DailyCheckInRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyCheckInRecord, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DailyCheckInRecord, int, QQueryOperations> energyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energy');
    });
  }

  QueryBuilder<DailyCheckInRecord, String, QQueryOperations>
  localDateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localDateKey');
    });
  }

  QueryBuilder<DailyCheckInRecord, int, QQueryOperations> moodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mood');
    });
  }

  QueryBuilder<DailyCheckInRecord, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }
}
