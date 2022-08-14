import 'package:mana_studio/models/scenes_model.dart';
import 'package:mana_studio/models/scripts_model.dart';

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

  List<dynamic> get sceneData {
    final scene = scenes.localScenes.where(
      (e) => e.fileName == sceneName,
    );
    if (scene.isEmpty) {
      return [];
    }
    return scene.last.fromJson ?? [];
  }

  final ScenesModel scenes;
  final ScriptsModel scripts;
  final String sceneName;
}
