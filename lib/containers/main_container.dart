import 'package:flutter/cupertino.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/models/game_model.dart';
import 'package:mana_studio/models/project_model.dart';
import 'package:mana_studio/providers/game_provider.dart';
import 'package:mana_studio/providers/project_provider.dart';
import 'package:mana_studio/utils/managers/alert_manager.dart';
import 'package:mana_studio/utils/managers/url_manager.dart';
import 'package:mana_studio/utils/script_editor.dart';

class MainContainer extends ConsumerStatefulWidget {
  const MainContainer({Key? key}) : super(key: key);

  @override
  ConsumerState<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends ConsumerState<MainContainer> {
  String source = '''function main() {
    console.log("Hello, World!");
}
    ''';

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: source,
    );
    // controller.selection = TextSelection.fromPosition(
    //   TextPosition(offset: source.length),
    // );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ..._sceneData.map((e) => Text(e['data']['description'])),
        CupertinoButton.filled(
          child: const Text('새 프로젝트 생성'),
          onPressed: () => _projectProvider.generateProject(),
        ),
        CupertinoButton.filled(
          child: const Text('게임 실행'),
          onPressed: () => _projectProvider.run(),
        ),
        CupertinoButton.filled(
          child: const Text('다음 메시지로'),
          onPressed: () => _gameProvider.nextSceneContent(),
        ),
        CupertinoButton.filled(
          child: const Text('테스트'),
          onPressed: () => AlertManager.show('안녕하세요'),
        ),
        CupertinoButton.filled(
          child: const Text('테스트2'),
          onPressed: () async {
            print(controller.text);
            // await UrlManager('https://pub.dev/packages/url_launcher').run();
          },
        ),
        SizedBox(
          width: double.infinity,
          height: 220,
          child: ScriptEditor(
            controller,
            language: 'javascript',
            theme: atomOneDarkTheme,
            padding: const EdgeInsets.all(12),
          ),
        )
      ],
    );
  }

  List<dynamic> get _sceneData => _gameState.contents;

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);

  ProjectModel get _projectState => ref.watch(projectProvider);

  GameProvider get _gameProvider => ref.read(gameProvider.notifier);

  GameModel get _gameState => ref.watch(gameProvider);
}
