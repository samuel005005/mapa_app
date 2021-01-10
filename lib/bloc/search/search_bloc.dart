import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapa_app/models/search_result.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState());

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is OnActivarMarcadorManual) {
      yield state.copyWith(seleccionManual: true);
    } else if (event is OnDesActivarMarcadorManual) {
      yield state.copyWith(seleccionManual: false);
    } else if (event is OnAddHistory) {
      final exist = state.history
          .where((result) => result.nombreDestino == event.result.nombreDestino)
          .length;

      if (exist == 0) {
        final newHistory = [...state.history, event.result];
        yield state.copyWith(history: newHistory);
      }
    }
  }
}
