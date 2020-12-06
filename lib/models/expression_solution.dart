class ExpressionSolution {
  String type;
  String value;

  ExpressionSolution(this.type, this.value);

  ExpressionSolution.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = allowBreaks(replaceBrackets(json['value']));
  }

  @override
  String toString() {
    return '$type\n$value';
  }
}

String allowBreaks(String str) {
  String res = str.replaceAll(',', ', \\allowbreak');
  return res.splitMapJoin(
    RegExp(r'\s+([+-])\s+'),
    onMatch: (match) => match.start == 0
        ? ' ${match.group(1)} '
        : '(,{'.contains(res[match.start - 1])
        ? ' ${match.group(1)} '
        : ' ${match.group(1)} \\allowbreak ',
    onNonMatch: (nonMatch) => nonMatch,
  );
}

String replaceBrackets(String str) {
  return str.replaceAll('\\left(', '(').replaceAll('\\right)', ')');
}


String testStr = '\\left(x, y, z\\right) \\rightarrow \\left( \\frac{1}{2} - \\frac{\\sqrt{2}}{4}, \\  \\frac{\\sqrt{2}}{4} + \\frac{1}{2}, \\  \\frac{1}{2}\\right), \\left( \\frac{\\sqrt{2}}{4} + \\frac{1}{2}, \\  \\frac{1}{2} - \\frac{\\sqrt{2}}{4}, \\  \\frac{1}{2}\\right), \\left( - \\frac{\\sqrt{2}}{8} + \\frac{\\sqrt{- 12 \\left(\\frac{\\sqrt{2}}{4} + \\frac{1}{2}\\right)^{2} + 3 \\sqrt{2} + 5}}{4} + \\frac{1}{2}, \\  - \\frac{\\sqrt{- 12 \\left(\\frac{\\sqrt{2}}{4} + \\frac{1}{2}\\right)^{2} + 3 \\sqrt{2} + 5}}{4} - \\frac{\\sqrt{2}}{8} + \\frac{1}{2}, \\  \\frac{\\sqrt{2}}{4} + \\frac{1}{2}\\right), \\left( - \\frac{\\sqrt{- 3 \\sqrt{2} - 12 \\left(\\frac{1}{2} - \\frac{\\sqrt{2}}{4}\\right)^{2} + 5}}{4} + \\frac{\\sqrt{2}}{8} + \\frac{1}{2}, \\  \\frac{\\sqrt{- 3 \\sqrt{2} - 12 \\left(\\frac{1}{2} - \\frac{\\sqrt{2}}{4}\\right)^{2} + 5}}{4} + \\frac{\\sqrt{2}}{8} + \\frac{1}{2}, \\ ';
String test2 = ' + ';