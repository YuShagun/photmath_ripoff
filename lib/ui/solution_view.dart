import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import '../models/solution/solution_view_model.dart';


class SolutionView {
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

  static TeXViewWidget view(SolutionViewModel model) {
    return TeXViewGroupItem(
      id: model.id,
      rippleEffect: false,
      child: TeXViewColumn(
        children: model.formattedText.map((item) => TeXViewDocument(
          item,
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