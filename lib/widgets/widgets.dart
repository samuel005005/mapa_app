import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:polyline/polyline.dart' as Poly;

import 'package:mapa_app/helpers/helpers.dart';

import 'package:mapa_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapa_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapa_app/bloc/search/search_bloc.dart';

import 'package:mapa_app/models/search_result.dart';

import 'package:mapa_app/search/search_destino.dart';

import 'package:mapa_app/services/traffic_service.dart';

part 'btn_location.dart';
part 'btn_mi_ruta.dart';
part 'btn_seguir_ubicacion.dart';
part 'search_bar.dart';
part 'marcador_manual.dart';
