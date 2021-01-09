part of 'widgets.dart';

class BtnMiRuta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapaBloc, MapaState>(
      builder: (BuildContext context, state) {
        return Container(
          margin: EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 25,
            child: IconButton(
              icon: Icon(
                  BlocProvider.of<MapaBloc>(context).state.dibujarRecorrido
                      ? Icons.map
                      : Icons.map_outlined,
                  color: Colors.black87),
              onPressed: () {
                BlocProvider.of<MapaBloc>(context).add(OnShowRoute());
              },
            ),
          ),
        );
      },
    );
  }
}
