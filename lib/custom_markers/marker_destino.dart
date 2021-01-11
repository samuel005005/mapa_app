part of 'custom_markers.dart';

class MarkerEndPainter extends CustomPainter {
  final String descripcion;
  final double metros;

  MarkerEndPainter(this.descripcion, this.metros);

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
    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    // Cajas Blanca
    final cajaBlanca = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(cajaBlanca, paint);

    // Cajas negra
    paint.color = Colors.black;
    final cajaNega = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(cajaNega, paint);

    double kilometros = this.metros / 1000;
    kilometros = (kilometros * 100).floorToDouble();
    kilometros = kilometros / 100;
    // Dibujar textos
    TextSpan textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
      text: '$kilometros',
    );
    TextPainter textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70, minWidth: 70);

    textPainter.paint(canvas, Offset(0, 35));

    // Minutos
    textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
      text: 'Km',
    );
    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70);

    textPainter.paint(canvas, Offset(20, 67));
    // Mi ubicacion

    textSpan = new TextSpan(
      style: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.w400),
      text: this.descripcion,
    );
    textPainter = new TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        maxLines: 2,
        ellipsis: '...')
      ..layout(maxWidth: size.width - 130);

    textPainter.paint(canvas, Offset(90, 30));
  }

  @override
  bool shouldRepaint(MarkerEndPainter oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(MarkerEndPainter oldDelegate) => true;
}
