import 'package:flutter/cupertino.dart';

class SceneCommandPackageModel {
  SceneCommandPackageModel(
    this.content,
    this.color, [
    this.onChanged,
  ]);

  final dynamic content;
  final Color color;
  final Function(dynamic next)? onChanged;

  bool hasKey(String key) => !(data.isEmpty || !data.containsKey(key));

  String get uuid => content['uuid'];

  String get type => content['type'];

  Map<String, dynamic> get data => content['data'] ?? {};
}
