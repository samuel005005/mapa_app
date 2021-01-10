import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart ';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/widgets/widgets.dart';

class MapaPage extends StatefulWidget {
  static final routeName = 'mapa';

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  void initState() {
    context.read<MiUbicacionBloc>().iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    context.read<MiUbicacionBloc>().cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: (_, state) => createMap(state),
          ),
          Positioned(top: 15, child: SearchBar()),
          MarcadorManual()
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          BtnUbicacion(),
          BtnMiRuta(),
          BtnSeguirUbucacion(),
        ],
      ),
    );
  }

  Widget createMap(MiUbicacionState state) {
    if (!state.existeUbicacion) return Center(child: Text('Localizando .....'));

    context.read<MapaBloc>().add(OnLocationUpdate(state.ubicacion));

    final cameraPosition =
        new CameraPosition(target: state.ubicacion, zoom: 15);

    return BlocBuilder<MapaBloc, MapaState>(
      builder: (_, state) {
        return GoogleMap(
          initialCameraPosition: cameraPosition,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: context.read<MapaBloc>().initMap,
          polylines: state.polylines.values.toSet(),
          markers: state.markers.values.toSet(),
          onCameraMove: (CameraPosition cameraPosition) {
            context.read<MapaBloc>().add(OnMoveMap(cameraPosition.target));
          },
        );
      },
    );
  }
}
