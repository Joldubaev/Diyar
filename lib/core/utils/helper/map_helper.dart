import 'dart:math';
// import 'dart:math' show asin, cos, sqrt;

import 'package:diyar/features/map/presentation/widgets/coordinats.dart';

class MapHelper {
  // Check if a coordinate is within Bishkek bounds
  static bool isInBishkekBounds(double latitude, double longitude) {
    double minLatitude = 42.8000;
    double maxLatitude = 42.9200;
    double minLongitude = 74.4500;
    double maxLongitude = 74.6200;
    return latitude >= minLatitude &&
        latitude <= maxLatitude &&
        longitude >= minLongitude &&
        longitude <= maxLongitude;
  }

  // Calculate the distance between two coordinates
  static double calculateDistance(double startLatitude, double startLongitude,
      double destinationLatitude, double destinationLongitude) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((destinationLatitude - startLatitude) * p) / 2 +
        c(startLatitude * p) *
            c(destinationLatitude * p) *
            (1 - c((destinationLongitude - startLongitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  // Check if a coordinate is inside a polygon
  static double isCoordinateInsidePolygons(double latitude, double longitude,
      {required List<DeliveryPolygon> polygons}) {
    for (var polygon in polygons) {
      if (isPointInPolygon(latitude, longitude, polygon.coordinates)) {
        return polygon.deliveryPrice;
      }
    }
    return 500;
  }

  // Check if a point is within a polygon
  static bool isPointInPolygon(
    double latitude,
    double longitude,
    List<Coordinate> coordinates,
  ) {
    int intersectCount = 0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      double vertex1Lat = coordinates[i].latitude;
      double vertex1Long = coordinates[i].longitude;
      double vertex2Lat = coordinates[i + 1].latitude;
      double vertex2Long = coordinates[i + 1].longitude;
      // Check if the point is within the y-range of the edge
      if ((vertex1Long > longitude) != (vertex2Long > longitude)) {
        // Calculate the x-coordinate where the edge intersects with the vertical line of longitude
        double xIntersect = (vertex2Lat - vertex1Lat) *
                (longitude - vertex1Long) /
                (vertex2Long - vertex1Long) +
            vertex1Lat;
        // Check if the intersection point is above the given latitude
        if (latitude < xIntersect) {
          intersectCount++;
        }
      }
    }
    // If the number of intersections is odd, the point is inside the polygon
    return intersectCount % 2 == 1;
  }
}
