import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';


class AboutDialogContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: AndroidView(
          viewType: "platform_text_view",
          creationParams: <String, dynamic>{"text": "Photomath Ripoff \n\nVersion 1.0.0 \n\nThis text is printed with native android view"},
          creationParamsCodec: const StandardMessageCodec(),
        ),
      ),
      width: max(MediaQuery.of(context).size.width / 2, 200),
      height: max(MediaQuery.of(context).size.height / 4, 300),
      margin: EdgeInsets.all(15),
    );
  }
}