import 'dart:developer';
import 'dart:math' as math;

import 'package:geo/geo.dart';

/// Utility for delivery zone geometry checks.
///
/// Zones are loaded lazily on first use and cached.
/// All public methods are async to support the initial load.
class MapHelper {
  static ZoneRepository? _zoneRepo;
  static List<DeliveryZone>? _cachedZones;
  static DeliveryZone? _cachedServiceZone;

  static ZoneRepository get _repo => _zoneRepo ??= ZoneRepository();

  /// Ensures zones are loaded. Call early (e.g. in bootstrap) for warm cache.
  static Future<void> preloadZones() async {
    _cachedServiceZone ??= await _repo.getServiceZone();
    _cachedZones ??= await _repo.getDeliveryZones();
  }

  /// Checks if a point is inside the service zone (outer delivery boundary).
  static Future<bool> isPointInServiceZone(
    double latitude,
    double longitude,
  ) async {
    await preloadZones();
    return isPointInPolygon(
      GeoPoint(latitude: latitude, longitude: longitude),
      _cachedServiceZone!.boundary,
    );
  }

  /// Returns the delivery zone ID for the given coordinate, or null.
  static Future<int?> getYandexIdForCoordinate(
    double latitude,
    double longitude,
  ) async {
    await preloadZones();
    final point = GeoPoint(latitude: latitude, longitude: longitude);

    log('Checking coordinate: $latitude, $longitude');
    final zone = findZoneForPoint(point, _cachedZones!);
    if (zone != null) {
      log('Point is inside zone ID: ${zone.id}');
      return int.tryParse(zone.id);
    }
    log('Point is not inside any polygon');
    return null;
  }

  /// Returns service zone boundary points (for map drawing).
  static Future<List<GeoPoint>> getServiceZoneBoundary() async {
    await preloadZones();
    return _cachedServiceZone!.boundary;
  }

  static bool isInBishkekBounds(double latitude, double longitude) {
    return latitude >= 42.8000 &&
        latitude <= 42.9200 &&
        longitude >= 74.4500 &&
        longitude <= 74.6200;
  }

  static double calculateDistance(
    double startLat,
    double startLon,
    double destLat,
    double destLon,
  ) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        math.cos((destLat - startLat) * p) / 2 +
        math.cos(startLat * p) *
            math.cos(destLat * p) *
            (1 - math.cos((destLon - startLon) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a));
  }
}
