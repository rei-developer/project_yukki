import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/components/common/debug_console.dart';
import 'package:mana_studio/components/main/scene_manage/scene_command_component.dart';
import 'package:mana_studio/components/main/scene_manage/scene_manage_component.dart';
import 'package:mana_studio/models/game_model.dart';
import 'package:mana_studio/models/project_model.dart';
import 'package:mana_studio/providers/game_provider.dart';
import 'package:mana_studio/providers/project_provider.dart';

class MainContainer extends ConsumerStatefulWidget {
  const MainContainer({Key? key}) : super(key: key);

  @override
  ConsumerState<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends ConsumerState<MainContainer> {
  @override
  void initState() {
    _projectProvider.run();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Container()),
          Row(
            children: [
              const Expanded(child: SceneManageComponent(480)),
              const SizedBox(width: 10),
              SizedBox(
                width: 400,
                height: 480,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Expanded(child: SceneCommandComponent(270)),
                    SizedBox(height: 10),
                    DebugConsole(200),
                  ],
                ),
              ),
            ],
          ),

          // CupertinoButton.filled(
          //   child: const Text('새 프로젝트 생성'),
          //   onPressed: () => _projectProvider.generateProject(),
          // ),
          // CupertinoButton.filled(
          //   child: const Text('게임 실행'),
          //   onPressed: () => _projectProvider.run(),
          // ),
          // CupertinoButton.filled(
          //   child: const Text('다음 메시지로'),
          //   onPressed: () => _gameProvider.nextSceneContent(),
          // ),
        ],
      );

  List<dynamic> get _sceneData => _gameState.contents;

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);

  ProjectModel get _projectState => ref.watch(projectProvider);

  GameProvider get _gameProvider => ref.read(gameProvider.notifier);

  GameModel get _gameState => ref.watch(gameProvider);
}
