import 'delivery_zone.dart';

/// Checks whether a [point] is inside a [polygon] using the
/// ray-casting algorithm.
///
/// Returns `true` if the point is inside or on the boundary.
bool isPointInPolygon(GeoPoint point, List<GeoPoint> polygon) {
  if (polygon.length < 3) return false;

  var inside = false;
  final n = polygon.length;

  for (var i = 0, j = n - 1; i < n; j = i++) {
    final xi = polygon[i].latitude;
    final yi = polygon[i].longitude;
    final xj = polygon[j].latitude;
    final yj = polygon[j].longitude;

    final intersect = ((yi > point.longitude) != (yj > point.longitude)) &&
        (point.latitude < (xj - xi) * (point.longitude - yi) / (yj - yi) + xi);

    if (intersect) inside = !inside;
  }

  return inside;
}

/// Finds the first [DeliveryZone] that contains the given [point].
/// Returns `null` if the point is not in any zone.
DeliveryZone? findZoneForPoint(GeoPoint point, List<DeliveryZone> zones) {
  for (final zone in zones) {
    if (isPointInPolygon(point, zone.boundary)) return zone;
  }
  return null;
}
