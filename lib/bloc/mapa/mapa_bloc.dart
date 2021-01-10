import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
  Polyline _miRuta = new Polyline(
      polylineId: PolylineId('miRuta'),
      width: 4,
      color: Colors.transparent,
      points: []);

  Polyline _miRutaDestino = new Polyline(
      polylineId: PolylineId('miRutaDestino'),
      width: 4,
      color: Colors.black87,
      points: []);

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
      yield* this._onLocationUpdate(event);
    } else if (event is OnShowRoute) {
      yield* this._onShowRoute(event);
    } else if (event is OnSeguirUbicacion) {
      yield* this._onSeguirUbicacion(event);
    } else if (event is OnMoveMap) {
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    } else if (event is OnCreateRouteBeginEnd) {
      yield* this._onCreateRouteBeginEnd(event);
    }
  }

  Stream<MapaState> _onLocationUpdate(OnLocationUpdate event) async* {
    if (state.seguirUbicacion) {
      this.moveCamera(event.ubicacion);
    }

    final List<LatLng> points = [..._miRuta.points, event.ubicacion];
    this._miRuta = this._miRuta.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['miRuta'] = this._miRuta;

    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onShowRoute(OnShowRoute event) async* {
    if (!state.dibujarRecorrido) {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.black87);
    } else {
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);
    }

    final currentPolylines = state.polylines;
    currentPolylines['miRuta'] = this._miRuta;

    yield state.copyWith(
        polylines: currentPolylines, dibujarRecorrido: !state.dibujarRecorrido);
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }

  Stream<MapaState> _onCreateRouteBeginEnd(OnCreateRouteBeginEnd event) async* {
    this._miRutaDestino = this._miRutaDestino.copyWith(
          pointsParam: event.rutaCoordenadas,
        );

    final currentPolylines = state.polylines;
    currentPolylines['miRutaDestino'] = this._miRutaDestino;
    yield state.copyWith(polylines: currentPolylines);
  }
}
