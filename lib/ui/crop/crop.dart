import 'package:flutter/material.dart';
import 'crop_rect.dart';
import 'shaded_box_painter.dart';

class Crop extends StatefulWidget {
  final screenSize; // size of the screen
  final center; // center of the crop area
  final size; // size of the area

  Crop({
    Key key,
    @required this.screenSize,
    @required this.center,
    @required this.size
  }) : super(key: key);

  @override
  _CropState createState() => _CropState(screenSize);
}

class _CropState extends State<Crop> {

  double maxWidth;
  double maxHeight;

  _CropState(screenSize) {
    maxWidth = screenSize.width - 20.0;
    maxHeight = maxWidth / 16 * 9.0;
  }

  void onDrag(double dx, double dy) {
    final newWidth = widget.size.width + dx;
    final newHeight = widget.size.height + dy;

    setState(() {
      widget.size.height = newHeight > 54.0 && newHeight < maxHeight ?
      newHeight :
      (newHeight - maxHeight).abs() < (newHeight - 54.0) ? maxHeight : 54.0;
      widget.size.width = newWidth > 54.0 && newWidth < maxWidth ?
      newWidth :
      (newWidth - maxWidth).abs() < (newWidth - 54.0) ? maxWidth : 54.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          size: widget.screenSize,
          painter: ShadedBoxPainter(
            center: widget.center,
            size: widget.size,
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        CropRect(
          center: widget.center,
          size: widget.size,
          onDrag: onDrag,
        ),
      ],
    );
  }
}