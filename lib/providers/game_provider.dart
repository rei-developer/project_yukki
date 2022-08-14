import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/models/game_model.dart';

class GameProvider extends StateNotifier<GameModel> {
  GameProvider(this.ref) : super(GameModel.initial());

  final Ref ref;

  Future<void> run(dynamic scene) async {
    setSceneData(scene);
  }

  void setSceneData(dynamic value) => state = state.copyWith(scene: value);
}

final gameProvider = StateNotifierProvider<GameProvider, GameModel>(
  (ref) => GameProvider(ref),
);
