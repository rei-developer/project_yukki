import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/models/game_model.dart';
import 'package:project_yukki/models/project_model.dart';
import 'package:project_yukki/providers/game_provider.dart';
import 'package:project_yukki/providers/project_provider.dart';

class GameContainer extends ConsumerStatefulWidget {
  const GameContainer({Key? key}) : super(key: key);

  @override
  ConsumerState<GameContainer> createState() => _GameContainerState();
}

class _GameContainerState extends ConsumerState<GameContainer> {
  @override
  void initState() {
    super.initState();
    _projectProvider.run();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton.filled(
          child: const Text('다음'),
          onPressed: () => _gameProvider.nextSceneContent(),
        ),
      ],
    );
  }

  List<dynamic> get _sceneData => _gameState.contents;

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);

  ProjectModel get _projectState => ref.watch(projectProvider);

  GameProvider get _gameProvider => ref.read(gameProvider.notifier);

  GameModel get _gameState => ref.watch(gameProvider);
}
