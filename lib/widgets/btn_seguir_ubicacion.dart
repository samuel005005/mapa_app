part of 'widgets.dart';

class BtnSeguirUbucacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapaBloc, MapaState>(
      builder: (BuildContext context, state) => _crearBoton(context, state),
    );
  }

  Widget _crearBoton(BuildContext context, MapaState state) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
              BlocProvider.of<MapaBloc>(context).state.seguirUbicacion
                  ? Icons.location_off
                  : Icons.location_on,
              color: Colors.black87),
          onPressed: () {
            BlocProvider.of<MapaBloc>(context).add(OnSeguirUbicacion());
          },
        ),
      ),
    );
  }
}
