import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/config/scene_command_config.dart';
import 'package:project_yukki/models/game_model.dart';
import 'package:project_yukki/models/scene/scene_content_model.dart';
import 'package:project_yukki/utils/func.dart';
import 'package:project_yukki/handlers/scene/commands/if_command_handler.dart';
import 'package:project_yukki/handlers/scene/commands/wait_command_handler.dart';

class GameProvider extends StateNotifier<GameModel> {
  GameProvider(this.ref) : super(GameModel.initial());

  final Ref ref;

  Future<void> run(dynamic contents) async {
    setSceneContentIndexes([1]);
    setSceneContents(contents);
    showSceneContentIndex(contents);
    runSceneContent();
  }

  void showSceneContentIndex(List<SceneContentModel> contents) {
    for (final content in contents) {
      print('${content.uuid} / ${content.indexes} / ${content.contentId}');
    }
  }

  // TODO: https://asset.visualnovelmaker.com/help/index.htm#t=Basic.htm&rhsearch=duration&rhhlterm=duration&rhsyns=%20 참고
  Future<void> runSceneContent() async {
    if (_sceneContent == null) {
      print("씬 데이터가 아예 없구나");
      return;
    }
    print('state setContentIndexes value => ${state.contentIndexes}');
    final type = _sceneContent?.type;
    final data = _sceneContent?.data;
    if (type == waitCommand) {
      print("대기 시작");
      setIsPossibleNext(false);
      await WaitCommandHandler(data).wait;
      print("대기 끝");
      setIsPossibleNext();
    }
    switch (type) {
      case showMessageCommand:
        print(_sceneContent?.data);
        return;
      case ifCommand:
      case elseIfCommand:
      case elseCommand:
        nextSceneContent(
          IfCommandHandler(
            data,
            type!,
            type != ifCommand ? _getScenePrevContent() : null,
          ).isMetCondition,
        );
        return;
      default:
        if (type == commentCommand) {
          print('Comment: $data');
        }
        nextSceneContent();
        return;
    }
  }

  void nextSceneContent([bool isChild = false]) {
    if (!state.isPossibleNext) {
      print("오이쿠야.. 안됩니다 아직!");
      return;
    }
    final indexes = _getNextSceneContentIndexes(isChild);
    if (indexes == null) {
      print('no data more');
      return;
    }
    setSceneContentIndexes(indexes);
    if (_sceneContent == null) {
      print('finished');
      return;
    }
    runSceneContent();
  }

  void setSceneContentIndexes(List<int> contentIndexes) => state = state.copyWith(contentIndexes: contentIndexes);

  void setSceneContents(dynamic contents) => state = state.copyWith(contents: contents);

  void setIsPossibleNext([bool? isPossibleNext = true]) => state = state.copyWith(isPossibleNext: isPossibleNext);

  List<int>? _getSceneNextIndexes(List<int> indexes) {
    if (_hasSceneContent(indexes)) {
      return indexes;
    }
    indexes.removeLast();
    if (indexes.isEmpty) {
      return null;
    }
    indexes.add(indexes.removeLast() + 1);
    return _getSceneNextIndexes(indexes);
  }

  List<int>? _getNextSceneContentIndexes([bool isChild = false]) {
    if (isChild) {
      final childIndexes = (_sceneContent?.children.firstOrNull)?.indexes;
      if (!(childIndexes == null || childIndexes.isEmpty) && _hasSceneContent(childIndexes)) {
        return childIndexes;
      }
    }
    final currentIndexes = _sceneContent?.indexes;
    if (currentIndexes == null || currentIndexes.isEmpty) {
      return null;
    }
    final indexes = [...currentIndexes];
    return _getSceneNextIndexes([
      ...indexes,
      indexes.removeLast() + 1,
    ]);
  }

  SceneContentModel? _getScenePrevContent([List<int>? currentIndexes]) {
    final indexes = [...currentIndexes ?? state.contentIndexes];
    indexes.add(indexes.removeLast() - 1);
    return _getSceneContent(indexes);
  }

  SceneContentModel? _getSceneContent([List<int>? indexes]) =>
      state.contents.where((e) => e.contentId == (indexes ?? state.contentIndexes).join('-')).firstOrNull;

  bool _hasSceneContent(List<int> indexes) => _getSceneContent(indexes) != null;

  SceneContentModel? get _sceneContent => _getSceneContent();
}

final gameProvider = StateNotifierProvider<GameProvider, GameModel>((ref) => GameProvider(ref));
