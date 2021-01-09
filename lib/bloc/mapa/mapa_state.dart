part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaReady;
  final bool dibujarRecorrido;
  final bool seguirUbicacion;
  final LatLng ubicacionCentral;

  // PolyLines

  final Map<String, Polyline> polylines;

  MapaState(
      {this.mapaReady = false,
      this.dibujarRecorrido = false,
      this.seguirUbicacion = false,
      this.ubicacionCentral,
      Map<String, Polyline> polylines})
      : this.polylines = polylines ?? new Map();

  MapaState copyWith(
          {bool mapaReady,
          bool dibujarRecorrido,
          bool seguirUbicacion,
          Map<String, Polyline> polylines,
          LatLng ubicacionCentral}) =>
      new MapaState(
          mapaReady: mapaReady ?? this.mapaReady,
          dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
          seguirUbicacion: seguirUbicacion ?? this.seguirUbicacion,
          ubicacionCentral: ubicacionCentral ?? this.ubicacionCentral,
          polylines: polylines ?? this.polylines);
}
