import 'package:mana_studio/models/scene/scene_model.dart';

class ScenesModel {
  ScenesModel(this.defaultScenes, this.localScenes);

  factory ScenesModel.initial({
    List<SceneModel>? defaultScenes,
    List<SceneModel>? localScenes,
  }) =>
      ScenesModel(
        defaultScenes ?? [],
        localScenes ?? [],
      );

  ScenesModel copyWith({
    List<SceneModel>? defaultScenes,
    List<SceneModel>? localScenes,
  }) =>
      ScenesModel(
        defaultScenes ?? this.defaultScenes,
        localScenes ?? this.localScenes,
      );

  final List<SceneModel> defaultScenes;
  final List<SceneModel> localScenes;
}
