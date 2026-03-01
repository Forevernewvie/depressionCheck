// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_plan_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSafetyPlanRecordCollection on Isar {
  IsarCollection<SafetyPlanRecord> get safetyPlanRecords => this.collection();
}

const SafetyPlanRecordSchema = CollectionSchema(
  name: r'SafetyPlanRecord',
  id: 7285333413161372042,
  properties: {
    r'copingStrategies': PropertySchema(
      id: 0,
      name: r'copingStrategies',
      type: IsarType.string,
    ),
    r'emergencySteps': PropertySchema(
      id: 1,
      name: r'emergencySteps',
      type: IsarType.string,
    ),
    r'reasonsToStaySafe': PropertySchema(
      id: 2,
      name: r'reasonsToStaySafe',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'warningSigns': PropertySchema(
      id: 4,
      name: r'warningSigns',
      type: IsarType.string,
    ),
  },
  estimateSize: _safetyPlanRecordEstimateSize,
  serialize: _safetyPlanRecordSerialize,
  deserialize: _safetyPlanRecordDeserialize,
  deserializeProp: _safetyPlanRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _safetyPlanRecordGetId,
  getLinks: _safetyPlanRecordGetLinks,
  attach: _safetyPlanRecordAttach,
  version: '3.1.0+1',
);

int _safetyPlanRecordEstimateSize(
  SafetyPlanRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.copingStrategies.length * 3;
  bytesCount += 3 + object.emergencySteps.length * 3;
  bytesCount += 3 + object.reasonsToStaySafe.length * 3;
  bytesCount += 3 + object.warningSigns.length * 3;
  return bytesCount;
}

void _safetyPlanRecordSerialize(
  SafetyPlanRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.copingStrategies);
  writer.writeString(offsets[1], object.emergencySteps);
  writer.writeString(offsets[2], object.reasonsToStaySafe);
  writer.writeDateTime(offsets[3], object.updatedAt);
  writer.writeString(offsets[4], object.warningSigns);
}

SafetyPlanRecord _safetyPlanRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SafetyPlanRecord(id: id);
  object.copingStrategies = reader.readString(offsets[0]);
  object.emergencySteps = reader.readString(offsets[1]);
  object.reasonsToStaySafe = reader.readString(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  object.warningSigns = reader.readString(offsets[4]);
  return object;
}

P _safetyPlanRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _safetyPlanRecordGetId(SafetyPlanRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _safetyPlanRecordGetLinks(SafetyPlanRecord object) {
  return [];
}

void _safetyPlanRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  SafetyPlanRecord object,
) {
  object.id = id;
}

extension SafetyPlanRecordQueryWhereSort
    on QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QWhere> {
  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension SafetyPlanRecordQueryWhere
    on QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QWhereClause> {
  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause>
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

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause>
  updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'updatedAt', value: [updatedAt]),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause>
  updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [],
                upper: [updatedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [updatedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [updatedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'updatedAt',
                lower: [],
                upper: [updatedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause>
  updatedAtGreaterThan(DateTime updatedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'updatedAt',
          lower: [updatedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause>
  updatedAtLessThan(DateTime updatedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'updatedAt',
          lower: [],
          upper: [updatedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterWhereClause>
  updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'updatedAt',
          lower: [lowerUpdatedAt],
          includeLower: includeLower,
          upper: [upperUpdatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension SafetyPlanRecordQueryFilter
    on QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QFilterCondition> {
  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'copingStrategies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'copingStrategies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'copingStrategies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'copingStrategies',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'copingStrategies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'copingStrategies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'copingStrategies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'copingStrategies',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'copingStrategies', value: ''),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  copingStrategiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'copingStrategies', value: ''),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'emergencySteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'emergencySteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'emergencySteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'emergencySteps',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'emergencySteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'emergencySteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'emergencySteps',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'emergencySteps',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'emergencySteps', value: ''),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  emergencyStepsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'emergencySteps', value: ''),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
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

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
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

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
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

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'reasonsToStaySafe',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reasonsToStaySafe',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reasonsToStaySafe',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reasonsToStaySafe',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'reasonsToStaySafe',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'reasonsToStaySafe',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'reasonsToStaySafe',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'reasonsToStaySafe',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reasonsToStaySafe', value: ''),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  reasonsToStaySafeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'reasonsToStaySafe', value: ''),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'warningSigns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'warningSigns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'warningSigns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'warningSigns',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'warningSigns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'warningSigns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'warningSigns',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'warningSigns',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'warningSigns', value: ''),
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterFilterCondition>
  warningSignsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'warningSigns', value: ''),
      );
    });
  }
}

extension SafetyPlanRecordQueryObject
    on QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QFilterCondition> {}

extension SafetyPlanRecordQueryLinks
    on QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QFilterCondition> {}

extension SafetyPlanRecordQuerySortBy
    on QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QSortBy> {
  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByCopingStrategies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copingStrategies', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByCopingStrategiesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copingStrategies', Sort.desc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByEmergencySteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emergencySteps', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByEmergencyStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emergencySteps', Sort.desc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByReasonsToStaySafe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonsToStaySafe', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByReasonsToStaySafeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonsToStaySafe', Sort.desc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByWarningSigns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warningSigns', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  sortByWarningSignsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warningSigns', Sort.desc);
    });
  }
}

extension SafetyPlanRecordQuerySortThenBy
    on QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QSortThenBy> {
  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByCopingStrategies() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copingStrategies', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByCopingStrategiesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copingStrategies', Sort.desc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByEmergencySteps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emergencySteps', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByEmergencyStepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emergencySteps', Sort.desc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByReasonsToStaySafe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonsToStaySafe', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByReasonsToStaySafeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reasonsToStaySafe', Sort.desc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByWarningSigns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warningSigns', Sort.asc);
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QAfterSortBy>
  thenByWarningSignsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'warningSigns', Sort.desc);
    });
  }
}

extension SafetyPlanRecordQueryWhereDistinct
    on QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QDistinct> {
  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QDistinct>
  distinctByCopingStrategies({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'copingStrategies',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QDistinct>
  distinctByEmergencySteps({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'emergencySteps',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QDistinct>
  distinctByReasonsToStaySafe({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'reasonsToStaySafe',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QDistinct>
  distinctByWarningSigns({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'warningSigns', caseSensitive: caseSensitive);
    });
  }
}

extension SafetyPlanRecordQueryProperty
    on QueryBuilder<SafetyPlanRecord, SafetyPlanRecord, QQueryProperty> {
  QueryBuilder<SafetyPlanRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SafetyPlanRecord, String, QQueryOperations>
  copingStrategiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'copingStrategies');
    });
  }

  QueryBuilder<SafetyPlanRecord, String, QQueryOperations>
  emergencyStepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emergencySteps');
    });
  }

  QueryBuilder<SafetyPlanRecord, String, QQueryOperations>
  reasonsToStaySafeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reasonsToStaySafe');
    });
  }

  QueryBuilder<SafetyPlanRecord, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<SafetyPlanRecord, String, QQueryOperations>
  warningSignsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'warningSigns');
    });
  }
}
