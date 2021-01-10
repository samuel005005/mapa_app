part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
        builder: (BuildContext context, state) {
      return state.seleccionManual ? _BuildMardadorManual() : Container();
    });
  }
}

class _BuildMardadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _btnRegresar(context),
        _puntoCentral(),
        _confirmarDestino(context)
      ],
    );
  }

  Widget _btnRegresar(BuildContext context) {
    return Positioned(
      top: 70,
      left: 20,
      child: FadeInLeft(
        duration: Duration(milliseconds: 300),
        child: CircleAvatar(
          maxRadius: 25,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              BlocProvider.of<SearchBloc>(context)
                  .add(OnDesActivarMarcadorManual());
            },
          ),
        ),
      ),
    );
  }

  Widget _puntoCentral() {
    return Center(
      child: Transform.translate(
        offset: new Offset(0, -18),
        child: BounceInDown(
          from: 200,
          child: Icon(Icons.location_on, size: 50, color: Colors.black87),
        ),
      ),
    );
  }

  Positioned _confirmarDestino(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Positioned(
      child: FadeInUp(
        duration: Duration(milliseconds: 300),
        child: MaterialButton(
          child:
              Text('Confirma destino', style: TextStyle(color: Colors.white)),
          color: Colors.black87,
          shape: StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          minWidth: width - 120,
          onPressed: () {
            calculandoAlerta(context);
            this.calcularDestino(context);
          },
        ),
      ),
      bottom: 70,
      left: 40,
    );
  }

  void calcularDestino(BuildContext context) async {
    final trafficService = new TrafficService();
    final begin = context.read<MiUbicacionBloc>().state.ubicacion;
    final end = context.read<MapaBloc>().state.ubicacionCentral;

    //Obtener Informacion  Destino
    await trafficService.getCoordInfo(end);
    final trafficResponse = await trafficService.getCoordsBeginEnd(begin, end);
    final geometry = trafficResponse.routes[0].geometry;
    final duration = trafficResponse.routes[0].duration;
    final distance = trafficResponse.routes[0].distance;
    //Decodifcar los puntos geometries polyline6
    final List<LatLng> points =
        Poly.Polyline.Decode(encodedString: geometry, precision: 6)
            .decodedCoords
            .map((point) {
      return LatLng(point[0], point[1]);
    }).toList();

    context.read<MapaBloc>().add(OnCreateRouteBeginEnd(
        rutaCoordenadas: points, distancia: distance, duracion: duration));
    BlocProvider.of<SearchBloc>(context).add(OnDesActivarMarcadorManual());
    Navigator.of(context).pop();
  }
}
