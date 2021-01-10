import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/models/search_reponse.dart';
import 'package:mapa_app/models/search_result.dart';
import 'package:mapa_app/services/traffic_service.dart';

class SearchDestino extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximidad;
  SearchDestino({this.proximidad})
      : this.searchFieldLabel = 'Buscar...',
        this._trafficService = new TrafficService();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => this.close(context, SearchResult(canceled: true)));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (this.query.length == 0) {
      return ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Colocar ubicacion manualmente'),
            onTap: () {
              this.close(context,
                  SearchResult(canceled: false, manualUbication: true));
            },
          )
        ],
      );
    }

    return this._buildResultsSuggestions();
  }

  Widget _buildResultsSuggestions() {
    if (this.query.length == 0) {
      return Container();
    }
// this._trafficService.getResultsByQuery(this.query.trim(), proximidad),
    this._trafficService.getSuggestionByQuery(this.query.trim(), proximidad);

    return StreamBuilder(
      stream: this._trafficService.suggestionsStream,
      builder: (context, AsyncSnapshot<SearchResponse> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final places = snapshot.data.features;

        if (places.length == 0) {
          return ListTile(title: Text('No hay resultados con $query'));
        }
        return ListView.separated(
          separatorBuilder: (_, i) => Divider(),
          itemCount: places.length,
          itemBuilder: (_, index) {
            final place = places[index];
            return ListTile(
              leading: Icon(Icons.place),
              title: Text(place.textEs),
              subtitle: Text(place.placeNameEs),
              onTap: () {
                this.close(
                  context,
                  SearchResult(
                      canceled: false,
                      manualUbication: false,
                      positionDestination:
                          LatLng(place.center[1], place.center[0]),
                      nombreDestino: place.textEs,
                      description: place.placeNameEs),
                );
              },
            );
          },
        );
      },
    );
  }
}
