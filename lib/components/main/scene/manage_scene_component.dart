import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/components/common/custom_autocomplete.dart';
import 'package:mana_studio/components/common/custom_divider.dart';
import 'package:mana_studio/components/common/custom_icon_button.dart';
import 'package:mana_studio/components/common/section.dart';
import 'package:mana_studio/components/common/section_header_button.dart';
import 'package:mana_studio/managers/scene/scene_command_package_manager.dart';
import 'package:mana_studio/config/debugger_config.dart';
import 'package:mana_studio/config/scene_command_config.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/i18n/strings.g.dart';
import 'package:mana_studio/models/project_model.dart';
import 'package:mana_studio/models/scene/scene_command_package_model.dart';
import 'package:mana_studio/providers/debugger_provider.dart';
import 'package:mana_studio/providers/project_provider.dart';
import 'package:mana_studio/utils/func.dart';
import 'package:mana_studio/managers/alert_manager.dart';
import 'package:mana_studio/utils/masker.dart';

class ManageSceneComponent extends ConsumerStatefulWidget {
  const ManageSceneComponent({Key? key}) : super(key: key);

  @override
  ConsumerState<ManageSceneComponent> createState() => _ManageSceneComponentState();
}

class _ManageSceneComponentState extends ConsumerState<ManageSceneComponent> {
  final controller = ScrollController();
  MouseCursor cursor = SystemMouseCursors.basic;
  dynamic selectedContent;
  bool isDragging = false;
  bool isLocked = false;

  @override
  Widget build(BuildContext context) => Section(
        t.headers.scene(sceneName: _sceneName),
        MouseRegion(
          cursor: cursor,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 34),
                child: ListView(
                  controller: controller,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    ..._generateSceneContents(_sceneContents, true),
                    SizedBox(height: MediaQuery.of(context).size.height / 2),
                  ],
                ),
              ),
              Row(
                children: [
                  CustomAutocomplete(
                    _autocompletedWords,
                    _addSceneCommand,
                    placeholder: '명령어를 검색하세요...',
                    searchLabel: '삽입',
                  ),
                  const SizedBox(width: 10),
                  _renderSelectedCommandItems,
                ],
              ),
            ],
          ),
        ),
        icon: CupertinoIcons.book,
        headerButtons: [
          SectionHeaderButton(
            icon: isLocked ? CupertinoIcons.lock_fill : CupertinoIcons.lock_open,
            tooltip: isLocked ? t.common.unlock : t.common.lock,
            callback: (_) => _toggleLock(),
          ),
          SectionHeaderButton(
            icon: CupertinoIcons.fullscreen,
            tooltip: t.common.unfold,
            callback: (_) => _toggleFoldAll(),
          ),
          SectionHeaderButton(
            icon: CupertinoIcons.fullscreen_exit,
            tooltip: t.common.fold,
            callback: (_) => _toggleFoldAll(true),
          ),
          SectionHeaderButton(
            icon: CupertinoIcons.arrow_up,
            tooltip: t.common.up,
            callback: (_) => _upperScrollTo(-(_scrollHeight / 4)),
          ),
          SectionHeaderButton(
            icon: CupertinoIcons.arrow_up_to_line,
            tooltip: t.common.upToLine,
            callback: (_) => _animateTo(0),
          ),
          SectionHeaderButton(
            icon: CupertinoIcons.arrow_down,
            tooltip: t.common.down,
            callback: (_) => _upperScrollTo(_scrollHeight / 4),
          ),
          SectionHeaderButton(
            icon: CupertinoIcons.arrow_down_to_line,
            tooltip: t.common.downToLine,
            callback: (_) => _animateTo(),
          ),
          SectionHeaderButton(
            icon: isLocked ? CupertinoIcons.trash_slash : CupertinoIcons.trash_fill,
            audioPath: 'se5.wav',
            tooltip: t.common.clear,
            isPlaySoundAfterPong: true,
            callback: (pong) => _clearSceneContent(pong),
          ),
        ],
      );

  List<Widget> _generateSceneContents(List<dynamic> contents, [bool isRoot = false]) => [
        ...contents.map((content) => _renderSceneContent(content, isRoot)).toList(),
        if (!isLocked && isRoot) _renderAdditionalArea(contents, isRoot),
      ].superJoin(CustomDivider(color: (isRoot ? darkColor : pitchBlackColor).withOpacity(0.2))).toList();

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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  childrenLength > 0 ? '$typeName 및 $childrenLength개의 ${t.scene.children}...' : typeName,
                  style: primaryTextStyle.copyWith(color: color),
                ),
                const SizedBox(width: 5),
                _renderUUID(content['uuid'], color),
              ],
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
    final render = SceneCommandPackageManager(
      SceneCommandPackageModel(
        content,
        color,
        (next) => _projectProvider.setSceneContent(next),
      ),
    ).render;
    final children = content['children'] as List<dynamic>?;
    final isSelected = uuid == _selectedUUID;
    final isFolded = content['isFolded'] ?? false;
    final hasChildren = children != null && children.isNotEmpty;
    return Opacity(
      opacity: isSelected && isDragging ? 0.1 : 1,
      child: GestureDetector(
        onTap: () => _setSelectedContent(content),
        child: Container(
          decoration: BoxDecoration(
            color: isRoot ? color.withOpacity(isSelected ? 0.25 : 0.1) : null,
            border: Border(left: BorderSide(color: isSelected ? color : color.withOpacity(0.1), width: 10)),
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
                      final result = await AlertManager.show('정말로 옮길 거니?', noLabel: '아니오');
                      if (result != CustomButton.positiveButton) {
                        return;
                      }
                    }
                    _setSelectedContent();
                    _projectProvider.swipeSceneContent(data, content);
                  },
                  builder: (context, _, __) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Draggable(
                        axis: Axis.vertical,
                        data: content,
                        onDragStarted: () {
                          _setCursor(SystemMouseCursors.grabbing);
                          _setSelectedContent(content);
                          _setIsDragging(true);
                        },
                        onDragEnd: (_) {
                          _setCursor();
                          _setIsDragging();
                        },
                        feedback: _renderSceneContentFeedback(content),
                        childWhenDragging: Container(height: 14),
                        child: GestureDetector(
                          onDoubleTap: () => _setContentIsFolded(content, !isFolded),
                          child: Row(
                            children: <Widget>[
                              if (!isPossibleHasChildren(type) && render == null)
                                SizedBox(width: 10, child: Icon(CupertinoIcons.circle_fill, size: 6, color: color))
                              else
                                MouseRegion(
                                  cursor: cursor,
                                  onHover: (_) => _setCursor(SystemMouseCursors.click),
                                  onExit: (_) => _setCursor(),
                                  child: SizedBox(
                                    width: 10,
                                    child: CustomIconButton(
                                      isFolded ? CupertinoIcons.chevron_right : CupertinoIcons.chevron_down,
                                      color: color,
                                      callback: () => _setContentIsFolded(content, !isFolded),
                                    ),
                                  ),
                                ),
                              SizedBox(
                                width: 160,
                                child: Text(label, style: primaryTextBoldStyle.copyWith(color: color)),
                              ),
                              Expanded(child: Text('$isFolded', style: TextStyle(color: color))),
                              _renderUUID(uuid, color),
                              Row(
                                children: <Widget>[
                                  if (hasChildren) _renderClearButton(uuid, color, true),
                                  _renderClearButton(uuid, color),
                                ].superJoin(const SizedBox(width: 3)).toList(),
                              ),
                            ].superJoin(const SizedBox(width: 10)).toList(),
                          ),
                        ),
                      ),
                      if (render != null && !isFolded) render,
                    ].superJoin(const SizedBox(height: 10)).toList(),
                  ),
                ),
                if (!isFolded && isPossibleHasChildren(type))
                  Column(
                    children: [
                      if (hasChildren)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            decoration: BoxDecoration(color: darkColor, border: Border.all(color: primaryLightColor)),
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

  Widget _renderAdditionalArea([dynamic content, bool isRoot = false]) => DragTarget(
        onAccept: (dynamic data) => _addSceneContent(data, content, isRoot),
        builder: (context, _, __) => Padding(
          padding: EdgeInsets.only(top: isRoot ? 0 : 10),
          child: Container(
            height: isRoot ? 50 : 30,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(color: primaryColor.withOpacity(0.1)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(CupertinoIcons.drop, size: isRoot ? 18 : 14, color: primaryColor),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      t.scene.add,
                      style: isRoot ? primaryTextStyle.copyWith(fontSize: 14) : primaryTextStyle,
                    ),
                  ),
                  _renderUUID(isRoot ? 'root' : content['uuid']),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _renderUUID(String uuid, [Color color = primaryColor]) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(2))),
        child: Text(Masker(uuid).mask, style: darkTextBoldStyle.copyWith(fontSize: 11)),
      );

  Widget _renderClearButton(String uuid, Color color, [bool isClearChildrenOnly = false]) => Container(
        width: 14,
        height: 14,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(color: darkColor, border: Border.all(color: color)),
        child: CustomIconButton(
          isClearChildrenOnly ? CupertinoIcons.refresh_bold : CupertinoIcons.xmark,
          size: 10,
          color: color,
          callback: () async {
            final result = await AlertManager.show(
              isClearChildrenOnly ? '정말로 모든 자식을 비울 거니?' : '정말로 삭제할 거니?',
              noLabel: '아니오',
            );
            if (result != CustomButton.positiveButton) {
              return;
            }
            _projectProvider.removeSceneContent(uuid, isClearChildrenOnly);
          },
        ),
      );

  void _animateTo([double? value]) {
    if (!controller.hasClients) {
      return;
    }
    controller.animateTo(
      value ?? (_scrollHeight + 100),
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

  void _addSceneContent(data, content, isRoot, [bool isRemove = true]) {
    if (isLocked) {
      return;
    }
    _projectProvider.addSceneContent(data, content, isRoot);
    final uuid = data['uuid'];
    if (uuid == null || !isRemove) {
      return;
    }
    _projectProvider.removeSceneContent(uuid);
  }

  void _setCursor([MouseCursor nextCursor = SystemMouseCursors.basic]) => setState(() => cursor = nextCursor);

  void _setSelectedContent([dynamic content]) => setState(() => selectedContent = content);

  void _setIsDragging([bool flag = false]) => setState(() => isDragging = flag);

  void _setContentIsFolded(dynamic content, bool isFolded) {
    _setSelectedContent(content);
    content['isFolded'] = isFolded;
    _projectProvider.setSceneContent(content);
  }

  void _toggleLock() => setState(() => isLocked = !isLocked);

  void _toggleFoldAll([bool isAllFolded = false]) {
    _animateTo(0);
    _projectProvider.setAllSceneContent('isFolded', isAllFolded);
  }

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

  void _addSceneCommand(String text, [bool isSaveSearchedCommand = true]) {
    final findIndex = commandItems.indexWhere((e) => e['localized'] == text);
    if (findIndex < 0) {
      return;
    }
    final item = commandItems[findIndex];
    if (isSaveSearchedCommand) {
      _projectProvider.addSearchedSceneCommand(item);
    }
    final isRoot = selectedContent == null;
    _addSceneContent(item, isRoot ? _sceneContents : selectedContent, isRoot, false);
  }

  Widget get _renderSelectedCommandItems => Expanded(
        child: SizedBox(
          height: 25,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              ..._projectState.searchedSceneCommands
                  .map(
                    (dynamic command) {
                      final color = getCommandColor(command['type']);
                      final localized = command['localized'];
                      return CupertinoButton(
                        minSize: 0,
                        padding: EdgeInsets.zero,
                        child: Container(
                          decoration: BoxDecoration(color: color.withOpacity(0.2)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Text(localized, style: primaryTextStyle.copyWith(color: color)),
                          ),
                        ),
                        onPressed: () => _addSceneCommand(localized, false),
                      );
                    },
                  )
                  .toList()
                  .reversed,
            ].superJoin(const SizedBox(width: 10)).toList(),
          ),
        ),
      );

  String get _sceneName => _projectState.sceneName;

  List<dynamic> get _sceneContents => _projectState.sceneContents ?? [];

  String get _selectedUUID => selectedContent == null ? '' : selectedContent['uuid'];

  List<String> get _autocompletedWords => commandItems.map((e) => e['localized'] as String).toList();

  double get _scrollHeight => controller.position.maxScrollExtent;

  bool get _isLocked {
    if (isLocked && _debuggerProvider.mounted) {
      _debuggerProvider.addDebug('씬이 잠긴 상태입니다.', warningDebug);
      return true;
    }
    return false;
  }

  DebuggerProvider get _debuggerProvider => ref.read(debuggerProvider.notifier);

  ProjectProvider get _projectProvider => ref.read(projectProvider.notifier);

  ProjectModel get _projectState => ref.watch(projectProvider);
}
