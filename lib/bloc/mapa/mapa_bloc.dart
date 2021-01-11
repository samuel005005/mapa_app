import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' show Colors, Offset;
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:meta/meta.dart';

import 'package:mapa_app/themes/uber_map_theme.dart';

import 'package:mapa_app/helpers/helpers.dart' as helpers;
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

    // Icono inicio
    final iconBegin = await helpers.getMarketBeginIcon(event.duracion.toInt());
    // final iconBegin = await helpers.getAssetImageMarker();
    // final iconEnd = await helpers.getNetworkImageMarker();
    final iconEnd =
        await helpers.getMarketEndIcon(event.nombreDestino, event.distancia);
    // Marcadores
    final markerBegin = new Marker(
      markerId: MarkerId('begin'),
      icon: iconBegin,
      position: event.rutaCoordenadas[0],
      anchor: Offset(0.0, 1.0),
      // infoWindow: InfoWindow(
      //   title: 'Mi Ubicacion',
      //   snippet: 'Duracion recorrido: ${(event.duracion / 60).floor()} minutos',
      // ),
    );

    // double kilometros = event.distancia / 100;
    // kilometros = (kilometros * 10).floor().toDouble();
    // kilometros = kilometros / 100;
    // Marcadores
    final markerEnd = new Marker(
      markerId: MarkerId('end'),
      icon: iconEnd,
      anchor: Offset(0.1, 0.90),
      position: event.rutaCoordenadas[event.rutaCoordenadas.length - 1],
      // infoWindow: InfoWindow(
      //   title: event.nombreDestino,
      //   snippet: 'Distancia kilometro: $kilometros Km',
      // ),
    );

    final newMarkers = {...state.markers};

    newMarkers['begin'] = markerBegin;
    newMarkers['end'] = markerEnd;

    Future.delayed(Duration(milliseconds: 300)).then((value) {
      // _mapController.showMarkerInfoWindow(MarkerId('end'));
    });

    yield state.copyWith(markers: newMarkers);
  }
}
