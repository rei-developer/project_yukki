import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/models/project_model.dart';
import 'package:mana_studio/providers/project_provider.dart';
import 'package:mana_studio/utils/managers/alert_manager.dart';
import 'package:mana_studio/utils/managers/url_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class MainContainer extends ConsumerStatefulWidget {
  const MainContainer({Key? key}) : super(key: key);

  @override
  ConsumerState<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends ConsumerState<MainContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton.filled(
          child: const Text('새 프로젝트 생성'),
          onPressed: () => _projectProvider.generateProject(),
        ),
        CupertinoButton.filled(
          child: const Text('스크립트 실행'),
          onPressed: () => _projectProvider.runScript(),
        ),
        CupertinoButton.filled(
          child: const Text('테스트'),
          onPressed: () => AlertManager.show('안녕하세요'),
        ),
        CupertinoButton.filled(
          child: const Text('테스트2'),
          onPressed: () async {
            await UrlManager('https://pub.dev/packages/url_launcher').run();
          },
        ),
      ],
    );
  }

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);

  ProjectModel get _projectState => ref.watch(projectProvider);
}
