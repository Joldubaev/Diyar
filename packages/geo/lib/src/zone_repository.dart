import 'dart:convert';

import 'package:flutter/services.dart';

import 'delivery_zone.dart';

/// Loads delivery zones from bundled JSON asset.
class ZoneRepository {
  ZoneRepository({this.assetPath = 'packages/geo/assets/delivery_zones.json'});

  final String assetPath;

  List<DeliveryZone>? _cachedZones;
  DeliveryZone? _cachedServiceZone;

  /// Load and cache all delivery zones from the JSON asset.
  Future<List<DeliveryZone>> getDeliveryZones() async {
    if (_cachedZones != null) return _cachedZones!;
    await _load();
    return _cachedZones!;
  }

  /// Load and cache the service zone boundary.
  Future<DeliveryZone> getServiceZone() async {
    if (_cachedServiceZone != null) return _cachedServiceZone!;
    await _load();
    return _cachedServiceZone!;
  }

  Future<void> _load() async {
    final jsonString = await rootBundle.loadString(assetPath);
    final data = json.decode(jsonString) as Map<String, dynamic>;

    _cachedServiceZone = DeliveryZone.fromJson(
      data['serviceZone'] as Map<String, dynamic>,
    );

    final zones = data['deliveryZones'] as List;
    _cachedZones = zones
        .map((z) => DeliveryZone.fromJson(z as Map<String, dynamic>))
        .toList();
  }

  /// Clear cached data (useful for testing or hot reload).
  void clearCache() {
    _cachedZones = null;
    _cachedServiceZone = null;
  }
}
