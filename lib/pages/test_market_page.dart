import 'package:flutter/material.dart';
import 'package:mapa_app/custom_markers/custom_markers.dart';

class TestMarketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 150,
          color: Colors.red,
          child: CustomPaint(
            painter: MarkerEndPainter(
                '120 East 13th Street, Nueva York, Nueva York 10003, Estados Unidos ',
                2500),
          ),
        ),
      ),
    );
  }
}
