import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/components/common/custom_section.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/i18n/strings.g.dart';
import 'package:mana_studio/models/project_model.dart';
import 'package:mana_studio/providers/project_provider.dart';
import 'package:mana_studio/utils/func.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:mana_studio/utils/managers/alert_manager.dart';

class SceneManageComponent extends ConsumerStatefulWidget {
  const SceneManageComponent({Key? key}) : super(key: key);

  @override
  ConsumerState<SceneManageComponent> createState() =>
      _SceneManageComponentState();
}

class _SceneManageComponentState extends ConsumerState<SceneManageComponent> {
  MouseCursor cursor = SystemMouseCursors.grab;

  @override
  Widget build(BuildContext context) => CustomSection(
        t.headers.scene(sceneName: _sceneName),
        MouseRegion(
          cursor: cursor,
          child: ListView(
            controller: ScrollController(),
            children: _generateSceneContents(_sceneContents, true),
          ),
        ),
      );

  List<Widget> _generateSceneContents(
    List<dynamic> contents, [
    bool isRoot = false,
  ]) =>
      [
        ...contents
            .map(
              (e) => Draggable(
                feedback: _renderSceneContentFeedback(e),
                data: e,
                onDragStarted: () => setState(
                  () => cursor = SystemMouseCursors.grabbing,
                ),
                onDragEnd: (_) => setState(
                  () => cursor = SystemMouseCursors.grab,
                ),
                child: _renderSceneContent(e, isRoot),
              ),
            )
            .toList(),
        if (isRoot) _renderAdditionalArea(contents, isRoot),
      ].superJoin(const DottedLine(dashColor: primaryColor)).toList();

  Widget _renderSceneContentFeedback(dynamic content) {
    final typeName = t['scene.command.${content["type"]}'];
    final childrenLength = (content['children'] as List<dynamic>?)?.length ?? 0;
    return Container(
      height: 30,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              childrenLength > 0
                  ? '$typeName 및 $childrenLength개의 ${t.scene.children}...'
                  : typeName,
              style: darkTextBoldStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderSceneContent(dynamic content, [bool isRoot = false]) =>
      Container(
        decoration: isRoot
            ? BoxDecoration(
                color: primaryColor.withOpacity(0.1),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DragTarget(
                onAccept: (dynamic data) async {
                  if (data['uuid'] == content['uuid']) {
                    return;
                  }
                  final children = data['children'];
                  if (children != null && children.length > 0) {
                    final result = await AlertManager.show(
                      '정말로 옮길 거니?',
                      noLabel: '아니오',
                    );
                    if (result != CustomButton.positiveButton) {
                      return;
                    }
                  }
                  _projectProvider.swipeSceneContent(data, content);
                },
                builder: (context, _, __) => Row(
                  children: [
                    Text(
                      t['scene.command.${content['type']}'],
                      // '${t["scene.command."]} / ${content['data']}',
                      style: primaryTextBoldStyle,
                    ),
                  ],
                ),
              ),
              if (_isPossibleHasChildren(content['children']))
                Container(
                  decoration: BoxDecoration(
                    color: darkColor,
                    border: Border.all(
                      color: primaryLightColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _generateSceneContents(content['children']),
                  ),
                ),
              if (_isPossibleHasChildren(content['children']))
                _renderAdditionalArea(content),
            ].superJoin(const SizedBox(height: 10)).toList(),
          ),
        ),
      );

  Widget _renderAdditionalArea([
    dynamic content,
    bool isRoot = false,
  ]) =>
      DragTarget(
        onAccept: (dynamic data) =>
            _projectProvider.addSceneContent(data, content, isRoot),
        builder: (context, _, __) => Container(
          height: 30,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.drop,
                  size: 14,
                  color: primaryColor,
                ),
                const SizedBox(width: 5),
                Text(t.scene.add),
              ],
            ),
          ),
        ),
      );

  bool _isPossibleHasChildren(List<dynamic>? children) =>
      children != null && children.isNotEmpty;

  String get _sceneName => _projectState.sceneName;

  List<dynamic> get _sceneContents => _projectState.sceneContents ?? [];

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);

  ProjectModel get _projectState => ref.watch(projectProvider);
}
