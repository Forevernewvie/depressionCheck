// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_preference.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppPreferenceCollection on Isar {
  IsarCollection<AppPreference> get appPreferences => this.collection();
}

const AppPreferenceSchema = CollectionSchema(
  name: r'AppPreference',
  id: -632636125728214278,
  properties: {
    r'languagePreference': PropertySchema(
      id: 0,
      name: r'languagePreference',
      type: IsarType.string,
    ),
    r'onboardingCompleted': PropertySchema(
      id: 1,
      name: r'onboardingCompleted',
      type: IsarType.bool,
    ),
    r'themePreference': PropertySchema(
      id: 2,
      name: r'themePreference',
      type: IsarType.string,
    ),
  },
  estimateSize: _appPreferenceEstimateSize,
  serialize: _appPreferenceSerialize,
  deserialize: _appPreferenceDeserialize,
  deserializeProp: _appPreferenceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appPreferenceGetId,
  getLinks: _appPreferenceGetLinks,
  attach: _appPreferenceAttach,
  version: '3.1.0+1',
);

int _appPreferenceEstimateSize(
  AppPreference object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.languagePreference.length * 3;
  bytesCount += 3 + object.themePreference.length * 3;
  return bytesCount;
}

void _appPreferenceSerialize(
  AppPreference object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.languagePreference);
  writer.writeBool(offsets[1], object.onboardingCompleted);
  writer.writeString(offsets[2], object.themePreference);
}

AppPreference _appPreferenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppPreference(
    id: id,
    languagePreference: reader.readStringOrNull(offsets[0]) ?? 'system',
    onboardingCompleted: reader.readBoolOrNull(offsets[1]) ?? false,
    themePreference: reader.readStringOrNull(offsets[2]) ?? 'system',
  );
  return object;
}

P _appPreferenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? 'system') as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? 'system') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appPreferenceGetId(AppPreference object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appPreferenceGetLinks(AppPreference object) {
  return [];
}

void _appPreferenceAttach(
  IsarCollection<dynamic> col,
  Id id,
  AppPreference object,
) {
  object.id = id;
}

extension AppPreferenceQueryWhereSort
    on QueryBuilder<AppPreference, AppPreference, QWhere> {
  QueryBuilder<AppPreference, AppPreference, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppPreferenceQueryWhere
    on QueryBuilder<AppPreference, AppPreference, QWhereClause> {
  QueryBuilder<AppPreference, AppPreference, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<AppPreference, AppPreference, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterWhereClause> idBetween(
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
}

extension AppPreferenceQueryFilter
    on QueryBuilder<AppPreference, AppPreference, QFilterCondition> {
  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
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

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'languagePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'languagePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'languagePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'languagePreference',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'languagePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'languagePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'languagePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'languagePreference',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'languagePreference', value: ''),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  languagePreferenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'languagePreference', value: ''),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  onboardingCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'onboardingCompleted', value: value),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'themePreference',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'themePreference',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'themePreference', value: ''),
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterFilterCondition>
  themePreferenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'themePreference', value: ''),
      );
    });
  }
}

extension AppPreferenceQueryObject
    on QueryBuilder<AppPreference, AppPreference, QFilterCondition> {}

extension AppPreferenceQueryLinks
    on QueryBuilder<AppPreference, AppPreference, QFilterCondition> {}

extension AppPreferenceQuerySortBy
    on QueryBuilder<AppPreference, AppPreference, QSortBy> {
  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  sortByLanguagePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languagePreference', Sort.asc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  sortByLanguagePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languagePreference', Sort.desc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  sortByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  sortByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  sortByThemePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.asc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  sortByThemePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.desc);
    });
  }
}

extension AppPreferenceQuerySortThenBy
    on QueryBuilder<AppPreference, AppPreference, QSortThenBy> {
  QueryBuilder<AppPreference, AppPreference, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  thenByLanguagePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languagePreference', Sort.asc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  thenByLanguagePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languagePreference', Sort.desc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  thenByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  thenByOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  thenByThemePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.asc);
    });
  }

  QueryBuilder<AppPreference, AppPreference, QAfterSortBy>
  thenByThemePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.desc);
    });
  }
}

extension AppPreferenceQueryWhereDistinct
    on QueryBuilder<AppPreference, AppPreference, QDistinct> {
  QueryBuilder<AppPreference, AppPreference, QDistinct>
  distinctByLanguagePreference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'languagePreference',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<AppPreference, AppPreference, QDistinct>
  distinctByOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingCompleted');
    });
  }

  QueryBuilder<AppPreference, AppPreference, QDistinct>
  distinctByThemePreference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'themePreference',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension AppPreferenceQueryProperty
    on QueryBuilder<AppPreference, AppPreference, QQueryProperty> {
  QueryBuilder<AppPreference, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppPreference, String, QQueryOperations>
  languagePreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languagePreference');
    });
  }

  QueryBuilder<AppPreference, bool, QQueryOperations>
  onboardingCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingCompleted');
    });
  }

  QueryBuilder<AppPreference, String, QQueryOperations>
  themePreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themePreference');
    });
  }
}
