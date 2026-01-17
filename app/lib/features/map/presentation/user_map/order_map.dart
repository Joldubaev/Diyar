import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapWidget extends StatefulWidget {
  final List<MapObject> mapObjects;
  final Function(CameraPosition, CameraUpdateReason, bool) onCameraPositionChanged;
  final Function(YandexMapController) onMapCreated;

  const MapWidget({
    super.key,
    required this.mapObjects,
    required this.onCameraPositionChanged,
    required this.onMapCreated,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late final Key _mapKey;

  @override
  void initState() {
    super.initState();
    _mapKey = UniqueKey();
  }

  @override
  Widget build(BuildContext context) {
    return YandexMap(
      key: _mapKey,
      mapObjects: widget.mapObjects,
      onCameraPositionChanged: widget.onCameraPositionChanged,
      onMapCreated: widget.onMapCreated,
    );
  }
}
