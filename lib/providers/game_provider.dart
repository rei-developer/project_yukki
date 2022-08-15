import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/models/game_model.dart';
import 'package:mana_studio/models/scene_item_model.dart';

class GameProvider extends StateNotifier<GameModel> {
  GameProvider(this.ref) : super(GameModel.initial());

  final Ref ref;

  Future<void> run(dynamic scene) async {
    setSceneData(scene);
    forEach(scene);
  }

  void forEach(List<SceneItemModel> scene) {
    for (final item in scene) {
      print('${item.indexes?.join('-')} / ${item.tag}');
      if (item.children.isNotEmpty) {
        forEach(item.children);
      }
    }
  }

  void setSceneData(dynamic value) => state = state.copyWith(scene: value);
}

final gameProvider = StateNotifierProvider<GameProvider, GameModel>(
  (ref) => GameProvider(ref),
);
