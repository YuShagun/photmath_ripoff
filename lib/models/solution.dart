
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
}