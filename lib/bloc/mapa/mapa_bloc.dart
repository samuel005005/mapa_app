import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

import 'package:mapa_app/themes/uber_map_theme.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(new MapaState());

  //Controlador del mapa
  GoogleMapController _mapController;

  //Polylines
  Polyline _miRuta =
      new Polyline(polylineId: PolylineId('miRuta'), width: 4, points: []);

  void initMap(GoogleMapController controller) {
    if (!state.mapaReady) {
      this._mapController = controller;
      // Cambiar estilo del mapa
      _mapController.setMapStyle(jsonEncode(uberMapTheme));
      add(OnMapReady());
    }
  }

  void moveCamera(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(
    MapaEvent event,
  ) async* {
    if (event is OnMapReady) {
      yield state.copyWith(mapaReady: true);
    } else if (event is OnLocationUpdate) {
      List<LatLng> points = [..._miRuta.points, event.ubicacion];
      this._miRuta = this._miRuta.copyWith(pointsParam: points);

      final currentPolylines = state.polylines;
      currentPolylines['miRuta'] = this._miRuta;

      yield state.copyWith(polylines: currentPolylines);
    }
  }
}
