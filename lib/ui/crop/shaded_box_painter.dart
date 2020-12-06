import 'package:flutter/material.dart';

class ShadedBoxPainter extends CustomPainter {
  final center;
  final size;
  final color;

  double dx;
  double dy;

  ShadedBoxPainter({this.center, this.size, this.color}) {
    dx = (this.size.width + 14) / 2;
    dy = (this.size.height + 14) / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill; // Change this to fill

    final topLeftX = center.x - dx;
    final topLeftY = center.y - dy;
    final botRightX = center.x + dx;
    final botRightY = center.y + dy;

    canvas.drawDRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(Offset(0, 0), Offset(size.width, size.height)),
          Radius.circular(0),
        ),
        RRect.fromRectAndRadius(
            Rect.fromPoints(Offset(topLeftX, topLeftY), Offset(botRightX, botRightY)),
            Radius.circular(15)
        ),
        paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}