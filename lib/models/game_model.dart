import 'package:mana_studio/models/scenes/scene_content_model.dart';

class GameModel {
  GameModel(
    this.contentIndexes,
    this.contents, [
    this.isPossibleNext = true,
  ]);

  factory GameModel.initial({
    List<int>? contentIndexes,
    List<SceneContentModel>? contents,
    bool? isPossibleNext,
  }) =>
      GameModel(
        contentIndexes ?? [1],
        contents ?? [],
        isPossibleNext ?? true,
      );

  GameModel copyWith({
    List<int>? contentIndexes,
    List<SceneContentModel>? contents,
    bool? isPossibleNext,
  }) =>
      GameModel(
        contentIndexes ?? this.contentIndexes,
        contents ?? this.contents,
        isPossibleNext ?? this.isPossibleNext,
      );

  String get contentId => contentIndexes.join('-');

  final List<int> contentIndexes;
  final List<SceneContentModel> contents;
  final bool isPossibleNext;
}
