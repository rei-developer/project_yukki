import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/components/common/custom_section.dart';
import 'package:mana_studio/components/common/custom_tooltip.dart';
import 'package:mana_studio/config/scene_command_config.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/i18n/strings.g.dart';
import 'package:mana_studio/utils/func.dart';
import 'package:uuid/uuid.dart';

class SceneCommandComponent extends ConsumerStatefulWidget {
  const SceneCommandComponent({Key? key}) : super(key: key);

  @override
  ConsumerState<SceneCommandComponent> createState() =>
      _SceneCommandComponentState();
}

class _SceneCommandComponentState extends ConsumerState<SceneCommandComponent> {
  String commandType = basicCommandType;
  MouseCursor cursor = SystemMouseCursors.grab;

  @override
  void initState() {
    super.initState();
    _setCurrentData();
  }

  @override
  Widget build(BuildContext context) => CustomSection(
        '${t.headers.commands} - ${_getCommandsLabel()}',
        ListView(
          controller: ScrollController(),
          children: [
            Wrap(
              children: [
                ..._renderCommands,
              ].superJoin(const SizedBox(width: 5)).toList(),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                ..._renderSelectedCommands,
              ].superJoin(const SizedBox(height: 10)).toList(),
            ),
          ],
        ),
        icon: CupertinoIcons.command,
      );

  void _setCurrentData([String type = basicCommandType]) =>
      setState(() => commandType = type);

  Widget _renderCommandBox(
    IconData icon,
    IconData activatedIcon,
    Color color,
    bool isActivated,
  ) =>
      Container(
        decoration: BoxDecoration(
          color: color.withOpacity(isActivated ? 0.3 : 0.1),
          border: Border.all(color: color),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Icon(
            isActivated ? activatedIcon : icon,
            size: 16,
            color: color,
          ),
        ),
      );

  Widget _renderSelectedCommandBox(dynamic command, Color color) =>
      CustomTooltip(
        Container(
          decoration: BoxDecoration(color: color.withOpacity(0.2)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: Text(
              _getSelectedCommandLabel(command['type']),
              style: primaryTextStyle.copyWith(color: color),
            ),
          ),
        ),
        tooltip: _getSelectedCommandTooltip(command['type']),
      );

  List<Widget> _renderSelectedCommandItems(List<dynamic> commands) =>
      commands.map(
        (command) {
          command['uuid'] = const Uuid().v4();
          final widget = _renderSelectedCommandBox(command, _color);
          return MouseRegion(
            cursor: cursor,
            child: Draggable(
              feedback: widget,
              data: command,
              onDragStarted: () => setState(
                () => cursor = SystemMouseCursors.grabbing,
              ),
              onDragEnd: (_) => setState(
                () => cursor = SystemMouseCursors.grab,
              ),
              child: widget,
            ),
          );
        },
      ).toList();

  String _getCommandsLabel([String? key]) =>
      t['scene.commandType.${key ?? commandType}.label'];

  String _getSelectedCommandsLabel([String? key]) =>
      t['scene.commandType.$commandType.commands.$key'];

  String _getSelectedCommandLabel([String? key]) =>
      t['scene.command.$key.label'];

  String _getSelectedCommandTooltip([String? key]) =>
      t['scene.command.$key.tooltip'];

  List<Widget> get _renderCommands => commands.entries
      .map(
        (entry) => CustomTooltip(
          CupertinoButton(
            minSize: 0,
            padding: EdgeInsets.zero,
            child: _renderCommandBox(
              entry.value['icon'],
              entry.value['activatedIcon'],
              entry.value['color'],
              entry.key == commandType,
            ),
            onPressed: () => _setCurrentData(entry.key),
          ),
          tooltip: _getCommandsLabel(entry.key),
        ),
      )
      .toList();

  List<Widget> get _renderSelectedCommands => _commands.entries
      .map(
        (entry) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _getSelectedCommandsLabel(entry.key),
              style: primaryTextBoldStyle.copyWith(
                color: _color,
                fontStyle: FontStyle.italic,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: DottedLine(dashColor: _color),
            ),
            Wrap(
              children: [
                ..._renderSelectedCommandItems(entry.value),
              ].superJoin(const SizedBox(width: 5)).toList(),
            ),
          ],
        ),
      )
      .toList();

  Color get _color => commands[commandType]['color'];

  Map<String, dynamic> get _commands => commands[commandType]['commands'];
}
