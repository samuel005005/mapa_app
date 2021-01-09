part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class OnActivarMarcadorManual extends SearchEvent {}

class OnDesActivarMarcadorManual extends SearchEvent {}
