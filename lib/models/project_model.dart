import 'dart:convert';

import 'package:mana_studio/models/scene_item_model.dart';
import 'package:mana_studio/models/scenes_model.dart';
import 'package:mana_studio/models/scripts_model.dart';
import 'package:mana_studio/utils/func.dart';

class ProjectModel {
  ProjectModel(
    this.scenes,
    this.scripts,
    this.sceneName,
  );

  factory ProjectModel.initial({
    ScenesModel? scenes,
    ScriptsModel? scripts,
    String? sceneName,
  }) =>
      ProjectModel(
        scenes ?? ScenesModel.initial(),
        scripts ?? ScriptsModel.initial(),
        sceneName ?? 'main_scene',
      );

  ProjectModel copyWith({
    ScenesModel? scenes,
    ScriptsModel? scripts,
    String? sceneName,
  }) =>
      ProjectModel(
        scenes ?? this.scenes,
        scripts ?? this.scripts,
        sceneName ?? this.sceneName,
      );

  List<SceneItemModel> get sceneData {
    final localScene = scenes.localScenes.where(
      (e) => e.fileName == sceneName,
    );
    if (localScene.isEmpty) {
      return [];
    }
    final jsonData = localScene.last.fromJson;
    if (jsonData.isEmpty) {
      return [];
    }
    return _mapSceneItems(jsonData);
  }

  List<SceneItemModel> _mapSceneItems(
    List<dynamic> jsonData, [
    List<int>? indexes,
  ]) =>
      mapIndexed(
        jsonData,
        (index, item) => _generateSceneItem(
          item,
          [...indexes ?? [], index + 1],
        ),
      ).toList();

  SceneItemModel _generateSceneItem(dynamic data, List<int> indexes) =>
      SceneItemModel.initial(
        indexes,
        data['type'],
        data['data'],
        tag: data['tag'],
        remarks: data['remarks'],
        children: _mapSceneItems(data['children'] ?? [], indexes),
      );

  List<String> get _sceneItemTypesChildrenAllowed => ['if', 'switch'];

  final ScenesModel scenes;
  final ScriptsModel scripts;
  final String sceneName;
}
