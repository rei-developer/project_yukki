import 'dart:convert';

class SceneModel {
  SceneModel(this.type, this.fileName, this.content);

  factory SceneModel.initial() => SceneModel('', '', '');

  SceneModel copyWith({
    String? type,
    String? fileName,
    String? content,
  }) =>
      SceneModel(
        type ?? this.type,
        fileName ?? this.fileName,
        content ?? this.content,
      );

  dynamic get fromJson => json.decode(content);

  final String type;
  final String fileName;
  final String content;
}
