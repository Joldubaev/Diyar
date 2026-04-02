/// A geographic point with latitude and longitude.
class GeoPoint {
  const GeoPoint({required this.latitude, required this.longitude});

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}

/// A named delivery zone defined by a polygon boundary.
class DeliveryZone {
  const DeliveryZone({
    required this.id,
    required this.name,
    required this.boundary,
    this.deliveryPrice = 0,
  });

  factory DeliveryZone.fromJson(Map<String, dynamic> json) {
    return DeliveryZone(
      id: json['id'] as String,
      name: json['name'] as String,
      deliveryPrice: (json['deliveryPrice'] as num?)?.toDouble() ?? 0,
      boundary: (json['boundary'] as List)
          .map((p) => GeoPoint.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String name;
  final List<GeoPoint> boundary;
  final double deliveryPrice;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'deliveryPrice': deliveryPrice,
        'boundary': boundary.map((p) => p.toJson()).toList(),
      };
}
