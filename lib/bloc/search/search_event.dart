part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class OnActivarMarcadorManual extends SearchEvent {}

class OnDesActivarMarcadorManual extends SearchEvent {}

class OnAddHistory extends SearchEvent {
  final SearchResult result;

  OnAddHistory(this.result);
}
