import 'package:project_yukki/models/scene/scene_model.dart';

class ScenesModel {
  ScenesModel(this.defaultScenes, this.localScenes, this.historyScenes);

  factory ScenesModel.initial({
    List<SceneModel>? defaultScenes,
    List<SceneModel>? localScenes,
    List<List<SceneModel>>? historyScenes,
  }) =>
      ScenesModel(
        defaultScenes ?? [],
        localScenes ?? [],
        historyScenes ?? [],
      );

  ScenesModel copyWith({
    List<SceneModel>? defaultScenes,
    List<SceneModel>? localScenes,
    List<List<SceneModel>>? historyScenes,
  }) =>
      ScenesModel(
        defaultScenes ?? this.defaultScenes,
        localScenes ?? this.localScenes,
        historyScenes ?? this.historyScenes,
      );

  final List<SceneModel> defaultScenes;
  final List<SceneModel> localScenes;
  final List<List<SceneModel>> historyScenes;
}
