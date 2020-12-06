import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:photomath_ripoff/data/database_provider.dart';
import 'package:photomath_ripoff/models/solution.dart';


class DisplaySolution extends StatefulWidget {
  final String imgPath;
  final Solution solution;

  DisplaySolution({Key key, this.imgPath, this.solution}): super(key: key);

  @override
  _DisplaySolutionState createState() => _DisplaySolutionState();
}

class _DisplaySolutionState extends State<DisplaySolution> {
  Future<Solution> futureSolution;

  @override
  void initState() {
    super.initState();
    if(widget.imgPath != null) {
      futureSolution = Solution.fetch(widget.imgPath);
    }
  }

  _display(Solution solution, Size size) {
    TeXViewStyle texStyle = TeXViewStyle.fromCSS(
      'padding: 10px 15px; text-align: left; font-size: 20px; line-height: 2.4; overflow: scroll'
    );

    print(solution.value);

    return Container(
      child: TeXView(
        renderingEngine: TeXViewRenderingEngine.katex(),
        child: TeXViewColumn(
          children: [
            if(solution.type != 'error') TeXViewDocument(
              '\\(\\textsf{\\large \\textup{' + solution.type[0].toUpperCase() + solution.type.substring(1) + '}}\\)',
              style: TeXViewStyle(
                margin: TeXViewMargin.only(top: 15, left: 10),
                fontStyle: TeXViewFontStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TeXViewGroup(
              children: [solution.view()],
              onTap: null,
              normalItemStyle: TeXViewStyle(
                padding: Solution.padding,
                margin: Solution.margin,
              ),
            ),
            TeXViewDocument(
              '\\(\\big\\downarrow\\:\\,\\textsf{\\tiny Evaluate}\\)',
              style: TeXViewStyle(
                margin: TeXViewMargin.only(top: 10, bottom: 10, left: 50),
                fontStyle: TeXViewFontStyle(
                  fontSize: 40,
                ),
              ),
            ),
            TeXViewDocument(
              solution.type != 'error'
                  ? '\\(${solution.value}\\)'
                  : '\\(\\textsf{\\textup{${solution.value}}}\\)',
              style: texStyle,
            ),
          ],
        ),
        style: TeXViewStyle(
          padding: TeXViewPadding.only(left: 5, right: 5),
        ),
        loadingWidgetBuilder: (context) => Center(child: CircularProgressIndicator(),),
      ),
      width: size.width,
      height: size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Solution'),
      ),
      body: Center(
        child: widget.imgPath != null ? FutureBuilder<Solution>(
          future: futureSolution,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data.text);
              print(snapshot.data.value);
              DatabaseProvider().openSolutionDatabase().then((_) {
                DatabaseProvider().saveSolution(snapshot.data);
              });
              return _display(snapshot.data, _screenSize);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ) : _display(widget.solution, _screenSize),
      ),
    );
  }
}