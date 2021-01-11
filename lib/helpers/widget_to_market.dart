part of 'helpers.dart';

Future<BitmapDescriptor> getMarketBeginIcon(int segundo) async {
  // Empezar a grabar el picture
  final recorder = ui.PictureRecorder();
  // crear el canvas para pintar el custom paint
  final canvas = ui.Canvas(recorder);
  // Definir el tamano de cambas
  final size = ui.Size(350, 150);
  final minutos = (segundo / 60).floor();
  // comenzar a pintar el canvas
  final marketBegin = MarkerBeginPainter(minutos);
  marketBegin.paint(canvas, size);
  // detener la grabacion
  final picture = recorder.endRecording();
  // obtener la imagen grabada y asignarle un tamano
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  // Obtener los byte de la image para convertirlo en un BitmapDescriptor
  final byteDate = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteDate.buffer.asUint8List());
}

Future<BitmapDescriptor> getMarketEndIcon(
    String descripcion, double metros) async {
  // Empezar a grabar el picture
  final recorder = ui.PictureRecorder();
  // crear el canvas para pintar el custom paint
  final canvas = ui.Canvas(recorder);
  // Definir el tamano de cambas
  final size = ui.Size(350, 150);
  // comenzar a pintar el canvas
  final marketBegin = MarkerEndPainter(descripcion, metros);
  marketBegin.paint(canvas, size);
  // detener la grabacion
  final picture = recorder.endRecording();
  // obtener la imagen grabada y asignarle un tamano
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  // Obtener los byte de la image para convertirlo en un BitmapDescriptor
  final byteDate = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteDate.buffer.asUint8List());
}
