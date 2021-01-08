part of 'mapa_bloc.dart';

@immutable
class MapaState {
  final bool mapaReady;
  final bool dibujarRecorrido;

  // PolyLines

  final Map<String, Polyline> polylines;

  MapaState(
      {this.mapaReady = false,
      this.dibujarRecorrido = true,
      Map<String, Polyline> polylines})
      : this.polylines = polylines ?? new Map();

  MapaState copyWith(
          {bool mapaReady,
          bool dibujarRecorrido,
          Map<String, Polyline> polylines}) =>
      new MapaState(
          mapaReady: mapaReady ?? this.mapaReady,
          dibujarRecorrido: dibujarRecorrido ?? this.dibujarRecorrido,
          polylines: polylines ?? this.polylines);
}
