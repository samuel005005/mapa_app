part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, state) {
        return state.seleccionManual
            ? Container()
            : FadeInDown(
                child: buildSearchBar(context),
                duration: Duration(milliseconds: 300),
              );
      },
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: size.width,
        child: GestureDetector(
          onTap: () async {
            final resultado = await showSearch(
                context: context,
                delegate: SearchDestino(
                    proximidad:
                        context.read<MiUbicacionBloc>().state.ubicacion));
            retornoBusqueda(context, resultado);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: double.infinity,
            height: 50,
            child: Text(
              'Donde quieres ir?',
              style: TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.normal),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: new Offset(0, 5),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> retornoBusqueda(
      BuildContext context, SearchResult result) async {
    if (result.canceled) return;
    if (result.manualUbication) {
      BlocProvider.of<SearchBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
    calculandoAlerta(context);
    final trafficService = new TrafficService();
    final begin = BlocProvider.of<MiUbicacionBloc>(context).state.ubicacion;
    final end = result.positionDestination;
    final drivingTraffic = await trafficService.getCoordsBeginEnd(begin, end);
    final geometry = drivingTraffic.routes[0].geometry;
    final duration = drivingTraffic.routes[0].duration;
    final distance = drivingTraffic.routes[0].distance;

    final List<LatLng> points =
        Poly.Polyline.Decode(encodedString: geometry, precision: 6)
            .decodedCoords
            .map((point) {
      return LatLng(point[0], point[1]);
    }).toList();

    context.read<MapaBloc>().add(OnCreateRouteBeginEnd(
        rutaCoordenadas: points, distancia: distance, duracion: duration));

    Navigator.of(context).pop();
  }
}
