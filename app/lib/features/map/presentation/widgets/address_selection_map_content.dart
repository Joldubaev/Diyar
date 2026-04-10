import 'package:flutter/material.dart';
import 'package:geo/geo.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../user_map/order_map.dart';
import 'address_selection_map_controls.dart';

/// Map content for address selection: map, center pin, zoom/location controls.
class AddressSelectionMapContent extends StatelessWidget {
  final void Function(YandexMapController) onMapCreated;
  final void Function(CameraPosition, CameraUpdateReason, bool)
      onCameraPositionChanged;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onLocate;
  final void Function(Point point)? onMapTap;

  /// Service zone boundary points for drawing the polygon overlay.
  /// Pass from parent after loading via [MapHelper.getServiceZoneBoundary()].
  final List<GeoPoint> serviceZoneBoundary;

  const AddressSelectionMapContent({
    super.key,
    required this.onMapCreated,
    required this.onCameraPositionChanged,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onLocate,
    required this.serviceZoneBoundary,
    this.onMapTap,
  });

  static const _serviceZoneCameraBounds = CameraBounds(
    minZoom: 10,
    maxZoom: 21,
    latLngBounds: BoundingBox(
      northEast: Point(latitude: 42.957, longitude: 74.924),
      southWest: Point(latitude: 42.71, longitude: 74.285),
    ),
  );

  List<MapObject> _getServiceZoneMapObjects() {
    if (serviceZoneBoundary.isEmpty) return const [];
    return [
      PolygonMapObject(
        mapId: const MapObjectId('service_zone'),
        polygon: Polygon(
          outerRing: LinearRing(
            points: serviceZoneBoundary
                .map((c) =>
                    Point(latitude: c.latitude, longitude: c.longitude))
                .toList(),
          ),
          innerRings: const [],
        ),
        fillColor: Colors.transparent,
        strokeColor: Colors.transparent,
        strokeWidth: 2,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWidget(
          key: const ValueKey('address_selection_map'),
          mapObjects: _getServiceZoneMapObjects(),
          onCameraPositionChanged: onCameraPositionChanged,
          onMapCreated: onMapCreated,
          cameraBounds: _serviceZoneCameraBounds,
          onMapTap: onMapTap,
        ),
        const Positioned.fill(
          child: Center(
            child: Icon(Icons.location_on, size: 30, color: Colors.red),
          ),
        ),
        AddressSelectionMapControls(
          onZoomIn: onZoomIn,
          onZoomOut: onZoomOut,
          onLocate: onLocate,
        ),
      ],
    );
  }
}
