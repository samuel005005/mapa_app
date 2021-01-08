part of 'mi_ubicacion_bloc.dart';

@immutable
abstract class MiUbicacionEvent {}

class OnChangeLocation extends MiUbicacionEvent {
  final LatLng ubicacion;
  OnChangeLocation(this.ubicacion);
}
