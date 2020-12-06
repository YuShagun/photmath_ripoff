import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_tex/flutter_tex.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String croppedImagePath;

  DisplayPictureScreen({Key key, @required this.imagePath, @required this.croppedImagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          '$imagePath',
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child:ListView(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          children: <Widget>[
            Image.file(
              File(imagePath),
              fit: BoxFit.scaleDown,
            ),
            Image.file(
              File(croppedImagePath),
              fit: BoxFit.scaleDown,
            ),
            TeXView(
              child: TeXViewColumn(children: [
                TeXViewInkWell(
                  id: "id_0",
                  child: TeXViewColumn(
                      children: [
                        TeXViewDocument(r"""<h2>Flutter \( \rm\\TeX \)</h2>""",
                            style: TeXViewStyle(textAlign: TeXViewTextAlign.Center)
                        ),
                        TeXViewContainer(
                          child: TeXViewImage.network('https://raw.githubusercontent.com/shah-xad/flutter_tex/master/example/assets/flutter_tex_banner.png'),
                          style: TeXViewStyle(
                            margin: TeXViewMargin.all(10),
                            borderRadius: TeXViewBorderRadius.all(20),
                          ),
                        ),
                        TeXViewDocument(
                            r"""<p>
                            When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are
                            $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$</p>""",
                            style: TeXViewStyle.fromCSS('padding: 15px; color: white; background: green')
                        )
                      ]
                  ),
                )
              ]
              ),
            )
          ],
        ),
      ),
    );
  }
}
