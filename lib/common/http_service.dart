import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:photomath_ripoff/models/image_text.dart';
import 'package:photomath_ripoff/models/expression_solution.dart';

Future<ImageText> postImage(String imagePath) async {
  final bytes = await File(imagePath).readAsBytes();

  final imageEncoded = 'data:image/png;base64,${base64Encode(bytes)}';

  final response = await http.post(
    'https://api.mathpix.com/v3/text',
      headers: <String, String>{
      "content-type": "application/json",
      "app_id": "yushagun_gmail_com_a33a2a",
      "app_key": "cb6540ddca03ee79d3ac"
    },
    body: jsonEncode(<String, dynamic>{
      'src': imageEncoded,
      'formats': ["text", "data"],
      'data_options': {
        'include_latex': true
      }
    })
  );

  return ImageText.fromJson(jsonDecode(response.body));
}

Future<ExpressionSolution> postTeX(ImageText text) async {
  final response = await http.post(
    'https://course-project-backend.herokuapp.com/solve/',
    body: jsonEncode(<String, List<String>>{
      'data': text.data
    })
  );

  return ExpressionSolution.fromJson(jsonDecode(response.body));
}