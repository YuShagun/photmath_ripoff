import 'package:flutter/material.dart';
import 'package:photomath_ripoff/models/crop_size.dart';

class DragDetector extends StatefulWidget {
  final CropSize size;
  final Function onDrag;

  DragDetector({Key key, @required this.size, @required this.onDrag}) : super(key: key);

  @override
  _DragDetectorState createState() => _DragDetectorState();
}

class _DragDetectorState extends State<DragDetector> {
  double initX;
  double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    double dx = details.globalPosition.dx - initX;
    double dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
      ),
    );
  }
}