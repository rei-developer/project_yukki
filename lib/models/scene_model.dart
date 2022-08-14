import 'dart:convert';

class SceneModel {
  SceneModel(this.type, this.fileName, this.content);

  factory SceneModel.initial() => SceneModel('', '', '');

  dynamic get fromJson => json.decode(content);

  final String type;
  final String fileName;
  final String content;
}
