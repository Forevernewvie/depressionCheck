import 'package:flutter_test/flutter_test.dart';
import 'package:vibemental_app/features/map/data/overpass/overpass_query_builder.dart';

void main() {
  test('builds query with radius and both clinic filter groups', () {
    const builder = OverpassQueryBuilder();

    final query = builder.buildNearbyClinicQuery(
      latitude: 37.5665,
      longitude: 126.9780,
      radiusMeters: 5000,
    );

    expect(query, contains('[out:json][timeout:25];'));
    expect(
      query,
      contains(
        'node(around:5000,37.5665,126.978)["amenity"~"hospital|clinic"];',
      ),
    );
    expect(
      query,
      contains(
        'relation(around:5000,37.5665,126.978)["healthcare"~"psychiatrist|mental_health"];',
      ),
    );
    expect(query, contains('out center 80;'));
  });
}
