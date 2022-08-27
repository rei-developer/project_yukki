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
  const SceneCommandComponent(this.height, {Key? key}) : super(key: key);

  final double height;

  @override
  ConsumerState<SceneCommandComponent> createState() =>
      _SceneCommandComponentState();
}

class _SceneCommandComponentState extends ConsumerState<SceneCommandComponent> {
  String currentType = basicCommandType;
  Color currentColor = primaryColor;
  List<Map<String, dynamic>> currentCommands = [];
  MouseCursor cursor = SystemMouseCursors.grab;

  @override
  void initState() {
    super.initState();
    _setCurrentData();
  }

  @override
  Widget build(BuildContext context) => CustomSection(
        'Scene Commands',
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              children: [
                ..._renderCommands,
              ].superJoin(const SizedBox(width: 5)).toList(),
            ),
            const SizedBox(height: 20),
            Wrap(
              children: [
                ..._renderCurrentCommands,
              ].superJoin(const SizedBox(width: 5)).toList(),
            ),
          ],
        ),
        height: widget.height,
      );

  void _setCurrentData([String currentType = basicCommandType]) => setState(
        () {
          currentType = currentType;
          currentColor = commands[currentType]['color'];
          currentCommands = commands[currentType]['commands'];
        },
      );

  Widget _renderCommandBox(
    IconData icon,
    Color color,
    bool isActivated,
  ) =>
      Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          border: Border.all(color: color),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
      );

  Widget _renderCurrentCommandBox(String label, Color color) => Container(
        decoration: BoxDecoration(color: color.withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Text(
            label,
            style: primaryTextStyle.copyWith(color: color),
          ),
        ),
      );

  List<Widget> get _renderCommands => commands.entries.map(
        (entry) {
          final label = t['scene.commandType.${entry.key}'];
          return CustomTooltip(
            label,
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              child: _renderCommandBox(
                entry.value['icon'],
                entry.value['color'],
                entry.key == currentType,
              ),
              onPressed: () => _setCurrentData(entry.key),
            ),
          );
        },
      ).toList();

  // const DottedLine(dashColor: primaryColor),

  List<Widget> get _renderCurrentCommands => currentCommands.map(
        (command) {
          command['uuid'] = const Uuid().v4();
          final label = t['scene.command.${command["type"]}'];
          return MouseRegion(
            cursor: cursor,
            child: Draggable(
              feedback: _renderCurrentCommandBox(label, currentColor),
              data: command,
              onDragStarted: () => setState(
                () => cursor = SystemMouseCursors.grabbing,
              ),
              onDragEnd: (_) => setState(
                () => cursor = SystemMouseCursors.grab,
              ),
              child: _renderCurrentCommandBox(label, currentColor),
            ),
          );
        },
      ).toList();
}
