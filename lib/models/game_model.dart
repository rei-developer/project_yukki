class GameModel {
  GameModel(this.scene);

  factory GameModel.initial({
    dynamic scene,
  }) =>
      GameModel(
        scene ?? [],
      );

  GameModel copyWith({
    dynamic scene,
  }) =>
      GameModel(
        scene ?? this.scene,
      );

  final dynamic scene;
}
