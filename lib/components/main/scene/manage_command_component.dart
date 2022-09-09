import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/components/common/section.dart';
import 'package:project_yukki/components/common/custom_tooltip.dart';
import 'package:project_yukki/config/scene_command_config.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/i18n/strings.g.dart';
import 'package:project_yukki/providers/audio_player_provider.dart';
import 'package:project_yukki/utils/func.dart';
import 'package:project_yukki/utils/render/render_widget_list.dart';
import 'package:uuid/uuid.dart';

class ManageCommandComponent extends ConsumerStatefulWidget {
  const ManageCommandComponent({Key? key}) : super(key: key);

  @override
  ConsumerState<ManageCommandComponent> createState() => _ManageCommandComponentState();
}

class _ManageCommandComponentState extends ConsumerState<ManageCommandComponent> {
  String commandType = basicCommandType;
  MouseCursor cursor = SystemMouseCursors.grab;

  @override
  void initState() {
    super.initState();
    _setCurrentData();
  }

  @override
  Widget build(BuildContext context) => Section(
        Text('${t.headers.commands} - ${_getCommandsLabel()}', style: darkTextBoldStyle),
        ListView(
          controller: ScrollController(),
          children: renderWidgetList(
            [
              Wrap(children: renderWidgetList(_renderCommands, padding: 5, isVertical: false)),
              Column(children: renderWidgetList(_renderSelectedCommands)),
            ],
            padding: 20,
          ),
        ),
        icon: CupertinoIcons.command,
      );

  void _setCurrentData([String type = basicCommandType]) {
    if (type == commandType) {
      return;
    }
    _audioProvider.setSE('move.mp3');
    setState(() => commandType = type);
  }

  Widget _renderCommandBox(IconData icon, IconData activatedIcon, Color color, bool isActivated) => Container(
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

  Widget _renderSelectedCommandBox(dynamic command, Color color) => CustomTooltip(
        Container(
          decoration: BoxDecoration(color: color.withOpacity(0.2)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              _getSelectedCommandLabel(command['type']),
              style: primaryTextStyle.copyWith(color: color),
            ),
          ),
        ),
        tooltip: _getSelectedCommandTooltip(command['type']),
      );

  List<Widget> _renderSelectedCommandItems(List<dynamic> commands) => commands.map(
        (command) {
          command['uuid'] = const Uuid().v4();
          final widget = _renderSelectedCommandBox(command, _color);
          return MouseRegion(
            cursor: cursor,
            child: Draggable(
              feedback: widget,
              data: command,
              onDragStarted: () => setState(() => cursor = SystemMouseCursors.grabbing),
              onDragEnd: (_) => setState(() => cursor = SystemMouseCursors.grab),
              child: widget,
            ),
          );
        },
      ).toList();

  String _getCommandsLabel([String? key]) => t['scene.commandType.${key ?? commandType}.label'];

  String _getSelectedCommandsLabel([String? key]) => t['scene.commandType.$commandType.commands.$key'];

  String _getSelectedCommandLabel([String? key]) => t['scene.command.$key.label'];

  String _getSelectedCommandTooltip([String? key]) => t['scene.command.$key.tooltip'];

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
              style: primaryTextBoldStyle.copyWith(color: _color, fontStyle: FontStyle.italic),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: DottedLine(dashColor: _color)),
            Wrap(children: renderWidgetList(_renderSelectedCommandItems(entry.value), padding: 5, isVertical: false)),
          ],
        ),
      )
      .toList();

  Color get _color => commands[commandType]['color'];

  Map<String, dynamic> get _commands => commands[commandType]['commands'];

  AudioPlayerProvider get _audioProvider => ref.read(audioPlayerProvider.notifier);
}
