import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/components/common/custom_divider.dart';
import 'package:mana_studio/components/common/custom_section.dart';
import 'package:mana_studio/components/common/custom_section_header_button.dart';
import 'package:mana_studio/config/debugger_config.dart';
import 'package:mana_studio/config/scene_command_config.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/i18n/strings.g.dart';
import 'package:mana_studio/models/project_model.dart';
import 'package:mana_studio/providers/debugger_provider.dart';
import 'package:mana_studio/providers/project_provider.dart';
import 'package:mana_studio/utils/func.dart';
import 'package:mana_studio/utils/managers/alert_manager.dart';
import 'package:mana_studio/utils/masker.dart';

class SceneManageComponent extends ConsumerStatefulWidget {
  const SceneManageComponent({Key? key}) : super(key: key);

  @override
  ConsumerState<SceneManageComponent> createState() =>
      _SceneManageComponentState();
}

class _SceneManageComponentState extends ConsumerState<SceneManageComponent> {
  final ScrollController controller = ScrollController();
  MouseCursor cursor = SystemMouseCursors.basic;
  String? selectedUuid;
  bool isLocked = false;

  void _toggleLock() {
    setState(() => isLocked = !isLocked);
  }

  void _toggleFoldAll([bool isAllFolded = false]) {
    _animateTo(0);
    _projectProvider.setAllSceneContent('isFolded', isAllFolded);
  }

  @override
  Widget build(BuildContext context) => CustomSection(
        t.headers.scene(sceneName: _sceneName),
        MouseRegion(
          cursor: cursor,
          child: ListView(
            controller: controller,
            physics: const ClampingScrollPhysics(),
            children: [
              ..._generateSceneContents(_sceneContents, true),
              SizedBox(height: MediaQuery.of(context).size.height / 2),
            ],
          ),
        ),
        icon: CupertinoIcons.book,
        headerButtons: [
          CustomSectionHeaderButton(
            icon:
                isLocked ? CupertinoIcons.lock_fill : CupertinoIcons.lock_open,
            tooltip: isLocked ? t.common.unlock : t.common.lock,
            callback: (_) => _toggleLock(),
          ),
          CustomSectionHeaderButton(
            icon: CupertinoIcons.fullscreen,
            tooltip: t.common.unfold,
            callback: (_) => _toggleFoldAll(),
          ),
          CustomSectionHeaderButton(
            icon: CupertinoIcons.fullscreen_exit,
            tooltip: t.common.fold,
            callback: (_) => _toggleFoldAll(true),
          ),
          CustomSectionHeaderButton(
            icon: CupertinoIcons.arrow_up,
            tooltip: t.common.up,
            callback: (_) => _upperScrollTo(-100),
          ),
          CustomSectionHeaderButton(
            icon: CupertinoIcons.arrow_up_to_line,
            tooltip: t.common.upToLine,
            callback: (_) => _animateTo(0),
          ),
          CustomSectionHeaderButton(
            icon: CupertinoIcons.arrow_down,
            tooltip: t.common.down,
            callback: (_) => _upperScrollTo(100),
          ),
          CustomSectionHeaderButton(
            icon: CupertinoIcons.arrow_down_to_line,
            tooltip: t.common.downToLine,
            callback: (_) => _animateTo(),
          ),
          CustomSectionHeaderButton(
            icon: isLocked
                ? CupertinoIcons.trash_slash
                : CupertinoIcons.trash_fill,
            audioPath: 'se5.wav',
            tooltip: t.common.clear,
            isPlaySoundAfterPong: true,
            callback: (pong) => _clearSceneContent(pong),
          ),
        ],
      );

  void _clearSceneContent(VoidCallback? pong) async {
    if (_isLocked) {
      return;
    }
    final result = await AlertManager.show('정말로 모두 삭제할 거니?', noLabel: '아니오');
    if (result != CustomButton.positiveButton) {
      return;
    }
    pong?.call();
    _animateTo(0);
    _projectProvider.clearSceneContent();
  }

  bool get _isLocked {
    if (isLocked && _debuggerProvider.mounted) {
      _debuggerProvider.addDebug('씬이 잠긴 상태입니다.', warningDebug);
      return true;
    }
    return false;
  }

  void setCursor([MouseCursor nextCursor = SystemMouseCursors.basic]) =>
      setState(() => cursor = nextCursor);

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
                childWhenDragging: _renderSceneContent(e, isRoot, !isLocked),
                onDragStarted: () => setCursor(SystemMouseCursors.grabbing),
                onDragEnd: (_) => setCursor(),
                child: _renderSceneContent(e, isRoot),
              ),
            )
            .toList(),
        if (!isLocked && isRoot) _renderAdditionalArea(contents, isRoot),
      ]
          .superJoin(
            CustomDivider(
              color: (isRoot ? darkColor : pitchBlackColor).withOpacity(0.2),
            ),
          )
          .toList();

  Widget _renderSceneContentFeedback(dynamic content) {
    if (isLocked) {
      return Container();
    }
    final type = content['type'];
    final typeName = t['scene.command.$type.label'];
    final color = getCommandColor(type);
    final childrenLength = (content['children'] as List<dynamic>?)?.length ?? 0;
    return Container(
      decoration: BoxDecoration(color: color.withOpacity(0.2)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  childrenLength > 0
                      ? '$typeName 및 $childrenLength개의 ${t.scene.children}...'
                      : typeName,
                  style: primaryTextStyle.copyWith(color: color),
                ),
                const SizedBox(width: 5),
                _renderUuid(content['uuid'], color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderSceneContent(
    dynamic content, [
    bool isRoot = false,
    bool isDragging = false,
  ]) {
    final label = t['scene.command.${content['type']}.label'];
    final uuid = content['uuid'];
    final type = content['type'];
    final color = getCommandColor(type);
    final children = content['children'] as List<dynamic>?;
    final isSelected = selectedUuid == uuid;
    final isFolded = content['isFolded'] ?? false;
    final hasChildren = children != null && children.isNotEmpty;
    return Opacity(
      opacity: isDragging ? 0.1 : 1,
      child: CupertinoButton(
        minSize: 0,
        padding: EdgeInsets.zero,
        pressedOpacity: 1,
        onPressed: () => _setSelectedUuid(uuid),
        child: Container(
          decoration: BoxDecoration(
            color: isRoot ? color.withOpacity(isSelected ? 0.25 : 0.1) : null,
            border: Border(
              left: BorderSide(
                color: isSelected ? color : color.withOpacity(0.1),
                width: 10,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DragTarget(
                  onAccept: (dynamic data) async {
                    if (isLocked || data['uuid'] == uuid) {
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
                    _setSelectedUuid();
                    _projectProvider.swipeSceneContent(data, content);
                  },
                  builder: (context, _, __) => Row(
                    children: [
                      if (!isPossibleHasChildren(type))
                        SizedBox(
                          width: 10,
                          child: Icon(
                            CupertinoIcons.circle_fill,
                            size: 6,
                            color: color,
                          ),
                        )
                      else
                        MouseRegion(
                          cursor: cursor,
                          onHover: (_) => setCursor(SystemMouseCursors.click),
                          onExit: (_) => setCursor(),
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
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 160,
                        child: Text(
                          label,
                          style: primaryTextBoldStyle.copyWith(color: color),
                        ),
                      ),
                      Expanded(
                          child:
                              Text('테스트입니다', style: TextStyle(color: color))),
                      _renderUuid(uuid, color),
                    ],
                  ),
                ),
                if (!isFolded && isPossibleHasChildren(type))
                  Column(
                    children: [
                      if (hasChildren)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
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
                        ),
                      if (!isLocked) _renderAdditionalArea(content),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderAdditionalArea([
    dynamic content,
    bool isRoot = false,
  ]) =>
      DragTarget(
        onAccept: (dynamic data) {
          if (isLocked) {
            return;
          }
          _projectProvider.addSceneContent(data, content, isRoot);
          _projectProvider.removeSceneContent(data['uuid']);
        },
        builder: (context, _, __) => Padding(
          padding: EdgeInsets.only(top: isRoot ? 0 : 10),
          child: Container(
            height: isRoot ? 50 : 30,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.drop,
                    size: isRoot ? 18 : 14,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      t.scene.add,
                      style: isRoot
                          ? primaryTextStyle.copyWith(fontSize: 14)
                          : primaryTextStyle,
                    ),
                  ),
                  _renderUuid(isRoot ? 'root' : content['uuid']),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _renderUuid(String uuid, [Color color = primaryColor]) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        child: Text(
          Masker(uuid).mask,
          style: darkTextBoldStyle.copyWith(fontSize: 11),
        ),
      );

  void _animateTo([double? value]) {
    if (!controller.hasClients) {
      return;
    }
    controller.animateTo(
      value ?? (controller.position.maxScrollExtent + 100),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _upperScrollTo(double value) {
    if (!controller.hasClients) {
      return;
    }
    _animateTo(controller.position.pixels + value);
  }

  void _setSelectedUuid([String? uuid]) => setState(() => selectedUuid = uuid);

  String get _sceneName => _projectState.sceneName;

  List<dynamic> get _sceneContents => _projectState.sceneContents ?? [];

  DebuggerProvider get _debuggerProvider => ref.read(debuggerProvider.notifier);

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);

  ProjectModel get _projectState => ref.watch(projectProvider);
}
