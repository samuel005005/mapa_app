part of 'search_bloc.dart';

@immutable
class SearchState {
  final bool seleccionManual;

  SearchState({
    this.seleccionManual = false,
  });

  SearchState copyWith({bool seleccionManual}) =>
      SearchState(seleccionManual: seleccionManual ?? this.seleccionManual);
}
