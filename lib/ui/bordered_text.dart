import 'package:flutter/material.dart';

class BorderedText extends StatelessWidget {
  final String text;
  final int maxLines;
  final Color borderColor;
  final Color color;

  BorderedText(this.text, {this.maxLines, this.borderColor, this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          maxLines: maxLines,
          style: TextStyle(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.5
              ..color = borderColor,
          ),
        ),
        Text(
          text,
          maxLines: maxLines,
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }
}