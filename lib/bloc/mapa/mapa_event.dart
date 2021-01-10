part of 'mapa_bloc.dart';

@immutable
abstract class MapaEvent {}

class OnMapReady extends MapaEvent {}

class OnLocationUpdate extends MapaEvent {
  final LatLng ubicacion;
  OnLocationUpdate(this.ubicacion);
}

class OnShowRoute extends MapaEvent {}

class OnSeguirUbicacion extends MapaEvent {}

class OnMoveMap extends MapaEvent {
  final LatLng centroMapa;
  OnMoveMap(this.centroMapa);
}

class OnCreateRouteBeginEnd extends MapaEvent {
  final List<LatLng> rutaCoordenadas;
  final double distancia;
  final double duracion;

  OnCreateRouteBeginEnd({this.rutaCoordenadas, this.distancia, this.duracion});
}
