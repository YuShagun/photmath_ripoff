import 'dart:collection';

class ImageText {
  final List<String> data;

  ImageText(this.data);

  factory ImageText.fromJson(Map<String, dynamic> json) {
    return ImageText(getLatex(json));
  }

  UnmodifiableListView<String> get text => UnmodifiableListView(data);
}

List<String> getLatex(Map<String, dynamic> json) {
  return [
    for (var map in json['data'])
      if(map['type'] == 'latex')
        map['value']
  ];
}