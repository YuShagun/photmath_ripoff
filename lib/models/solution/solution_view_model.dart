import '../image_text.dart';
import '../expression_solution.dart';
import '../../service/web_service.dart';
import 'solution.dart';


class SolutionViewModel {
  // MVVM View Model

  final Solution solution;

  SolutionViewModel(this.solution);

  String get id => solution.id.toString();

  List<String> get formattedText => solution.text.map((item) => '\\($item\\)').toList();

  String get type => solution.type;

  String get value => solution.type != 'error' ? '\\(${solution.value}\\)' : '\\(\\textsf{\\textup{${solution.value}}}\\)';

  static Future<SolutionViewModel> fetch(String imgPath) async {
    ImageText text = await WebService.postImage(imgPath);
    ExpressionSolution sol = await WebService.postTeX(text);
    print(sol.type);
    return SolutionViewModel(
      Solution(
        text: text.text,
        type: sol.type,
        value: sol.value,
      )
    );
  }


}
