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
            final resultado =
                await showSearch(context: context, delegate: SearchDestino());
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

  void retornoBusqueda(BuildContext context, SearchResult result) {
    if (result.canceled) return;
    if (result.manualUbication) {
      BlocProvider.of<SearchBloc>(context).add(OnActivarMarcadorManual());
      return;
    }
  }
}
