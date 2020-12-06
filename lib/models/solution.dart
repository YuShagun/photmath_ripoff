import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

import 'image_text.dart';
import 'expression_solution.dart';
import 'package:photomath_ripoff/common/http_service.dart';


final String tableSolution = 'Solution';
final String columnId = '_id';
final String columnText = 'text';
final String columnType = 'type';
final String columnValue = 'value';

class Solution {
  int id;
  List<String> text;
  String type;
  String value;

  Solution({this.id, this.text, this.type, this.value});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnText: text.join(' @ '),
      columnType: type,
      columnValue: value,
    };
  }

  Solution.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    text = map[columnText].split(RegExp(r'\s+@\s+'));
    type = map[columnType];
    value = map[columnValue];
  }

  static Future<Solution> fetch(String imgPath) async {
    ImageText text = await postImage(imgPath);
    ExpressionSolution solution = await postTeX(text);
    print(solution.type);
    return Solution(
        text: text.text,
        type: solution.type,
        value: solution.value
    );
  }

  static const padding = TeXViewPadding.all(10);
  static const margin = TeXViewMargin.only(bottom: 10);
  static final border = TeXViewBorder.all(
    TeXViewBorderDecoration(
      borderWidth: 3,
      borderStyle: TeXViewBorderStyle.Solid,
      borderColor: Colors.blueGrey[600],
    ),
  );
  static const borderRadius = TeXViewBorderRadius.all(10);

  TeXViewWidget view() {
    return TeXViewGroupItem(
      id: id.toString(),
      rippleEffect: false,
      child: TeXViewColumn(
        children: text.map((item) => TeXViewDocument(
          '\\($item\\)',
          style:  TeXViewStyle(
            textAlign: TeXViewTextAlign.Left,
            fontStyle: TeXViewFontStyle(
              fontSize: 26,
            ),
          ),
        )).toList(),
      ),
    );
  }
}
