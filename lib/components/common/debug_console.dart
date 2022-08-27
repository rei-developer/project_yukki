import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/components/common/custom_section.dart';
import 'package:mana_studio/config/debugger_config.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/i18n/strings.g.dart';
import 'package:mana_studio/models/debugger_model.dart';
import 'package:mana_studio/providers/debugger_provider.dart';
import 'package:mana_studio/utils/func.dart';

class DebugConsole extends ConsumerStatefulWidget {
  const DebugConsole(this.height, {Key? key}) : super(key: key);

  final double height;

  @override
  ConsumerState<DebugConsole> createState() => _DebugConsoleState();
}

class _DebugConsoleState extends ConsumerState<DebugConsole> {
  @override
  Widget build(BuildContext context) => CustomSection(
        t.debug.header,
        ListView(
          controller: ScrollController(),
          children: [
            ..._renderDebugConsole,
          ].superJoin(const SizedBox(height: 5)).toList(),
        ),
        height: widget.height,
      );

  List<Widget> get _renderDebugConsole => _logs
      .map(
        (e) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderLabelBox(e.type, e.color),
            const SizedBox(width: 5),
            _renderLabelBox(e.time, dateTimeDebugColor),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                ': ${e.description}',
                style: lightTextStyle,
              ),
            ),
          ],
        ),
      )
      .toList();

  Widget _renderLabelBox(String label, Color color) => Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(3)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            label,
            style: darkTextBoldStyle,
          ),
        ),
      );

  DebuggerProvider get _debuggerProvider => ref.read(debuggerProvider.notifier);

  List<DebuggerModel> get _logs => ref.watch(debuggerProvider);
}
