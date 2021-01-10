import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapa_app/helpers/debouncer.dart';
import 'package:mapa_app/models/search_reponse.dart';
import 'package:mapa_app/models/traffic_response.dart';

class TrafficService {
  final _dio = new Dio();

  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 400));

  final _suggestionsStreamController =
      StreamController<SearchResponse>.broadcast();

  Stream<SearchResponse> get suggestionsStream =>
      _suggestionsStreamController.stream;

  final String _baseUrl = 'https://api.mapbox.com';
  final String _apiKey =
      'pk.eyJ1Ijoic3BhZXoiLCJhIjoiY2tqcHJ5OHliMHp1YzJ5cWxyOHNoZmJsYSJ9.47eCEX2RysR9MU27he2lBg';

  TrafficService._privateConstrunctor();

  static final _instance = TrafficService._privateConstrunctor();

  factory TrafficService() {
    return _instance;
  }

  Future<TrafficResponse> getCoordsBeginEnd(LatLng begin, LatLng end) async {
    final coordString =
        '${begin.longitude},${begin.latitude};${end.longitude},${end.latitude}';
    final url = '${this._baseUrl}/directions/v5/mapbox/driving/$coordString';
    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': true,
      'geometries': 'polyline6',
      'access_token': this._apiKey,
      'language': 'es',
      'steps': false,
    });

    final data = TrafficResponse.fromJson(resp.data);
    return data;
  }

  Future<SearchResponse> getResultsByQuery(
      String search, LatLng proximidad) async {
    try {
      print('Buscando....');
      final url = '${this._baseUrl}/geocoding/v5/mapbox.places/$search.json';
      final resp = await this._dio.get(url, queryParameters: {
        'access_token': this._apiKey,
        'autocomplete': true,
        'proximity': '${proximidad.longitude},${proximidad.latitude}',
        'language': 'es'
      });

      final data = searchResponseFromJson(resp.data);
      return data;
    } catch (e) {
      return SearchResponse(features: []);
    }
  }

  void getSuggestionByQuery(String search, LatLng proximidad) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.getResultsByQuery(search, proximidad);
      this._suggestionsStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = search;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }

  void dispose() {
    _suggestionsStreamController?.close();
  }
}
