part of 'widgets.dart';

class BtnUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(Icons.my_location, color: Colors.black87),
          onPressed: () {
            final destino =
                BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
            BlocProvider.of<MapaBloc>(context).moveCamera(destino);
          },
        ),
      ),
    );
  }
}
