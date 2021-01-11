part of 'helpers.dart';

Future<BitmapDescriptor> getAssetImageMarker() async {
  return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/custom-pin.png');
}

Future<BitmapDescriptor> getNetworkImageMarker() async {
  final resp = await Dio().get(
      'https://w7.pngwing.com/pngs/770/688/png-transparent-computer-icons-google-map-maker-map-marker-angle-black-map.png',
      options: Options(responseType: ResponseType.bytes));
  final bytes = resp.data;

  final imageCodec = await ui.instantiateImageCodec(bytes,
      targetWidth: 150, targetHeight: 150);
  final frame = await imageCodec.getNextFrame();
  final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}
