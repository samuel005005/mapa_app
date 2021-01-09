import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchResult {
  final bool canceled;
  final bool manualUbication;
  final LatLng positionDestination;
  final String nombreDestino;
  final String description;

  SearchResult(
      {@required this.canceled,
      this.manualUbication,
      this.positionDestination,
      this.nombreDestino,
      this.description});
}
