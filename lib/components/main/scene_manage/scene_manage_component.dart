import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/components/common/custom_divider.dart';
import 'package:mana_studio/components/common/custom_section.dart';
import 'package:mana_studio/config/scene_command_config.dart';
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
        icon: CupertinoIcons.book,
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
      ]
          .superJoin(
            CustomDivider(
              color: (isRoot ? darkColor : pitchBlackColor).withOpacity(0.2),
            ),
          )
          .toList();

  Widget _renderSceneContentFeedback(dynamic content) {
    final typeName = t['scene.command.${content["type"]}.label'];
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

  Widget _renderSceneContent(dynamic content, [bool isRoot = false]) {
    final label = t['scene.command.${content['type']}.label'];
    final uuid = content['uuid'];
    final type = content['type'];
    final color = getCommandColor(type);
    final children = content['children'] as List<dynamic>?;
    final isFolded = content['isFolded'] ?? false;
    final hasChildren = children != null && children.isNotEmpty;
    return Container(
      decoration: isRoot ? BoxDecoration(color: color.withOpacity(0.1)) : null,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DragTarget(
              onAccept: (dynamic data) async {
                if (data['uuid'] == uuid) {
                  return;
                }
                final dataChildren = data['children'];
                if (dataChildren != null && dataChildren.length > 0) {
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
                  if (!isPossibleHasChildren(type))
                    const SizedBox(width: 10)
                  else
                    MouseRegion(
                      cursor: cursor,
                      onHover: (_) => setState(
                        () => cursor = SystemMouseCursors.click,
                      ),
                      onExit: (_) => setState(
                        () => cursor = SystemMouseCursors.grab,
                      ),
                      child: SizedBox(
                        width: 10,
                        child: CupertinoButton(
                          minSize: 0,
                          padding: EdgeInsets.zero,
                          child: Icon(
                            isFolded
                                ? CupertinoIcons.chevron_right
                                : CupertinoIcons.chevron_down,
                            size: 14,
                          ),
                          onPressed: () {
                            content['isFolded'] = !isFolded;
                            _projectProvider.setSceneContent(uuid, content);
                          },
                        ),
                      ),
                    ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 160,
                    child: Text(
                      label,
                      style: primaryTextBoldStyle.copyWith(color: color),
                    ),
                  ),
                  Text('테스트입니다', style: TextStyle(color: color)),
                ],
              ),
            ),
            if (!isFolded && isPossibleHasChildren(type))
              Column(
                children: [
                  if (hasChildren)
                    Container(
                      decoration: BoxDecoration(
                        color: darkColor,
                        border: Border.all(
                          color: primaryLightColor,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _generateSceneContents(children),
                      ),
                    ),
                  _renderAdditionalArea(content),
                ].superJoin(const SizedBox(height: 10)).toList(),
              ),
          ].superJoin(const SizedBox(height: 10)).toList(),
        ),
      ),
    );
  }

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

  String get _sceneName => _projectState.sceneName;

  List<dynamic> get _sceneContents => _projectState.sceneContents ?? [];

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);

  ProjectModel get _projectState => ref.watch(projectProvider);
}
