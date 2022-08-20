import 'package:mana_studio/config/project_config.dart';
import 'package:mana_studio/models/scenes/scene_content_model.dart';
import 'package:mana_studio/models/scenes/scenes_model.dart';
import 'package:mana_studio/models/scripts_model.dart';
import 'package:mana_studio/utils/func.dart';

class ProjectModel {
  ProjectModel(
    this.sceneName,
    this.scenes,
    this.scripts,
  );

  factory ProjectModel.initial({
    String? sceneName,
    ScenesModel? scenes,
    ScriptsModel? scripts,
  }) =>
      ProjectModel(
        sceneName ?? firstSceneName,
        scenes ?? ScenesModel.initial(),
        scripts ?? ScriptsModel.initial(),
      );

  ProjectModel copyWith({
    String? sceneName,
    ScenesModel? scenes,
    ScriptsModel? scripts,
  }) =>
      ProjectModel(
        sceneName ?? this.sceneName,
        scenes ?? this.scenes,
        scripts ?? this.scripts,
      );

  List<SceneContentModel> get sceneContents {
    final localScene = scenes.localScenes.where((e) => e.fileName == sceneName);
    if (localScene.isEmpty) {
      return [];
    }
    final jsonData = localScene.last.fromJson;
    if (jsonData.isEmpty) {
      return [];
    }
    return _addAllChildren(_mapSceneContents(jsonData));
  }

  List<SceneContentModel> _addAllChildren(List<SceneContentModel> children) {
    List<SceneContentModel> result = [];
    if (children.isNotEmpty) {
      for (final child in children) {
        result.add(child);
        result.addAll(_addAllChildren(child.children));
      }
    }
    return result;
  }

  List<SceneContentModel> _mapSceneContents(
    List<dynamic> jsonData, [
    List<int>? indexes,
  ]) =>
      mapIndexed(
        jsonData,
        (index, item) => _generateSceneContent(
          item,
          [...indexes ?? [], index + 1],
        ),
      ).toList();

  SceneContentModel _generateSceneContent(dynamic data, List<int> indexes) =>
      SceneContentModel.initial(
        indexes,
        data['type'],
        data['data'],
        remarks: data['remarks'],
        children: _mapSceneContents(data['children'] ?? [], indexes),
      );

  final String sceneName;
  final ScenesModel scenes;
  final ScriptsModel scripts;
}
