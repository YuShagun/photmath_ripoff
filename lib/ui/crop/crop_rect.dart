import 'dart:math';
import 'package:flutter/material.dart';
import 'drag_detector.dart';
import 'package:photomath_ripoff/models/crop_size.dart';


class CropRect extends StatefulWidget {
  final Point center;
  final CropSize size;
  final Function onDrag;

  const CropRect({Key key, @required this.center, @required this.size, @required this.onDrag}) : super(key: key);

  @override
  _CropRectState createState() => _CropRectState();
}

class _CropRectState extends State<CropRect> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.center.x - widget.size.width / 2,
      top: widget.center.y - widget.size.height / 2,
      child:
      Container(
        width: widget.size.width,
        height: widget.size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.blueGrey.shade400,
            width: 4,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.north_west,
                color: Colors.blueGrey.shade400,
                size: 16,
              ),
            ),
            DragDetector(size: widget.size, onDrag: widget.onDrag),
          ],
        ),
      ),
    );
  }
}