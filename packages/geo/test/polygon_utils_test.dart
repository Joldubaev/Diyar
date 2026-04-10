import 'package:flutter_test/flutter_test.dart';
import 'package:geo/geo.dart';

void main() {
  group('isPointInPolygon', () {
    // Simple square: (0,0), (0,10), (10,10), (10,0)
    final square = [
      GeoPoint(latitude: 0, longitude: 0),
      GeoPoint(latitude: 0, longitude: 10),
      GeoPoint(latitude: 10, longitude: 10),
      GeoPoint(latitude: 10, longitude: 0),
    ];

    test('returns true for point inside polygon', () {
      final point = GeoPoint(latitude: 5, longitude: 5);
      expect(isPointInPolygon(point, square), isTrue);
    });

    test('returns false for point outside polygon', () {
      final point = GeoPoint(latitude: 15, longitude: 15);
      expect(isPointInPolygon(point, square), isFalse);
    });

    test('returns false for point clearly outside', () {
      final point = GeoPoint(latitude: -5, longitude: -5);
      expect(isPointInPolygon(point, square), isFalse);
    });

    test('returns false for polygon with less than 3 points', () {
      final line = [
        GeoPoint(latitude: 0, longitude: 0),
        GeoPoint(latitude: 10, longitude: 10),
      ];
      final point = GeoPoint(latitude: 5, longitude: 5);
      expect(isPointInPolygon(point, line), isFalse);
    });

    test('works with real Bishkek coordinates', () {
      // Simplified service zone around Bishkek center
      final bishkekZone = [
        GeoPoint(latitude: 42.85, longitude: 74.55),
        GeoPoint(latitude: 42.85, longitude: 74.65),
        GeoPoint(latitude: 42.90, longitude: 74.65),
        GeoPoint(latitude: 42.90, longitude: 74.55),
      ];

      // Diyar restaurant area
      final inside = GeoPoint(latitude: 42.882, longitude: 74.583);
      expect(isPointInPolygon(inside, bishkekZone), isTrue);

      // Outside Bishkek
      final outside = GeoPoint(latitude: 43.0, longitude: 75.0);
      expect(isPointInPolygon(outside, bishkekZone), isFalse);
    });
  });

  group('findZoneForPoint', () {
    final zones = [
      DeliveryZone(
        id: '1',
        name: 'zone_1',
        deliveryPrice: 150,
        boundary: [
          GeoPoint(latitude: 0, longitude: 0),
          GeoPoint(latitude: 0, longitude: 5),
          GeoPoint(latitude: 5, longitude: 5),
          GeoPoint(latitude: 5, longitude: 0),
        ],
      ),
      DeliveryZone(
        id: '2',
        name: 'zone_2',
        deliveryPrice: 250,
        boundary: [
          GeoPoint(latitude: 5, longitude: 0),
          GeoPoint(latitude: 5, longitude: 10),
          GeoPoint(latitude: 10, longitude: 10),
          GeoPoint(latitude: 10, longitude: 0),
        ],
      ),
    ];

    test('returns matching zone', () {
      final point = GeoPoint(latitude: 2, longitude: 2);
      final zone = findZoneForPoint(point, zones);
      expect(zone, isNotNull);
      expect(zone!.id, '1');
      expect(zone.deliveryPrice, 150);
    });

    test('returns second zone when point is in zone 2', () {
      final point = GeoPoint(latitude: 7, longitude: 5);
      final zone = findZoneForPoint(point, zones);
      expect(zone, isNotNull);
      expect(zone!.id, '2');
    });

    test('returns null when point is outside all zones', () {
      final point = GeoPoint(latitude: 20, longitude: 20);
      expect(findZoneForPoint(point, zones), isNull);
    });

    test('returns null for empty zones list', () {
      final point = GeoPoint(latitude: 2, longitude: 2);
      expect(findZoneForPoint(point, []), isNull);
    });
  });

  group('DeliveryZone', () {
    test('fromJson / toJson roundtrip', () {
      final json = {
        'id': '1',
        'name': 'test_zone',
        'deliveryPrice': 200,
        'boundary': [
          {'latitude': 42.0, 'longitude': 74.0},
          {'latitude': 42.1, 'longitude': 74.1},
          {'latitude': 42.2, 'longitude': 74.0},
        ],
      };

      final zone = DeliveryZone.fromJson(json);
      expect(zone.id, '1');
      expect(zone.name, 'test_zone');
      expect(zone.deliveryPrice, 200);
      expect(zone.boundary.length, 3);

      final back = zone.toJson();
      expect(back['id'], '1');
      expect(back['boundary'], isList);
      expect((back['boundary'] as List).length, 3);
    });
  });

  group('GeoPoint', () {
    test('fromJson / toJson roundtrip', () {
      final json = {'latitude': 42.882, 'longitude': 74.583};
      final point = GeoPoint.fromJson(json);
      expect(point.latitude, 42.882);
      expect(point.longitude, 74.583);

      final back = point.toJson();
      expect(back['latitude'], 42.882);
      expect(back['longitude'], 74.583);
    });
  });
}
