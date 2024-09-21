
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapWidget extends StatelessWidget {
  final List<MapObject> mapObjects;
  final Function(CameraPosition, CameraUpdateReason, bool)
      onCameraPositionChanged;
  final Function(YandexMapController) onMapCreated;

  const MapWidget({
    Key? key,
    required this.mapObjects,
    required this.onCameraPositionChanged,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 350,
      child: YandexMap(
        mapObjects: mapObjects,
        onCameraPositionChanged: onCameraPositionChanged,
        onMapCreated: onMapCreated,
      ),
    );
  }
}

