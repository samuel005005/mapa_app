part of 'custom_markers.dart';

class MarkerBeginPainter extends CustomPainter {
  final int minutos;

  MarkerBeginPainter(this.minutos);
  @override
  void paint(Canvas canvas, Size size) {
    // Lapiz
    final double circuloNegroR = 20;
    final double circuloBlancoR = 7;
    final height = size.height;
    Paint paint = new Paint()..color = Colors.black;
    // Dibujar Circulo Negro
    canvas.drawCircle(
        Offset(circuloNegroR, height - circuloNegroR), circuloNegroR, paint);
    // Dibujar Circulo Blanco
    paint..color = Colors.white;
    canvas.drawCircle(
        Offset(circuloNegroR, height - circuloNegroR), circuloBlancoR, paint);

    //Sombra
    final path = new Path();
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    // Cajas Blanca
    final cajaBlanca = Rect.fromLTWH(40, 20, size.width - 55, 80);
    canvas.drawRect(cajaBlanca, paint);

    // Cajas negra
    paint.color = Colors.black;
    final cajaNega = Rect.fromLTWH(40, 20, 70, 80);
    canvas.drawRect(cajaNega, paint);

    // Dibujar textos
    TextSpan textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      text: '${this.minutos}',
    );
    TextPainter textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 35));

    // Minutos
    textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      text: 'Min',
    );
    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(40, 67));
    // Mi ubicacion

    textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.w400),
      text: 'Mi ubicacion',
    );
    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: size.width - 130);

    textPainter.paint(canvas, Offset(155, 45));
  }

  @override
  bool shouldRepaint(MarkerBeginPainter oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(MarkerBeginPainter oldDelegate) => true;
}
