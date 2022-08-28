import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/components/common/custom_section.dart';
import 'package:mana_studio/components/common/custom_section_header_button.dart';
import 'package:mana_studio/config/debugger_config.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/i18n/strings.g.dart';
import 'package:mana_studio/models/debugger_model.dart';
import 'package:mana_studio/providers/debugger_provider.dart';
import 'package:mana_studio/utils/func.dart';

class DebugConsole extends ConsumerStatefulWidget {
  const DebugConsole({Key? key}) : super(key: key);

  @override
  ConsumerState<DebugConsole> createState() => _DebugConsoleState();
}

class _DebugConsoleState extends ConsumerState<DebugConsole> {
  final ScrollController controller = ScrollController();
  bool isPined = false;

  @override
  Widget build(BuildContext context) {
    _listenDebugger();
    return CustomSection(
      t.headers.debugger,
      ListView(
        controller: controller,
        physics: const ClampingScrollPhysics(),
        children: [
          ..._renderDebugConsole,
        ].superJoin(const SizedBox(height: 5)).toList(),
      ),
      icon: CupertinoIcons.captions_bubble,
      headerButtons: [
        CustomSectionHeaderButton(
          icon: isPined ? CupertinoIcons.pin_fill : CupertinoIcons.pin_slash,
          tooltip: isPined ? t.common.unpin : t.common.pin,
          callback: (_) => setState(() => isPined = !isPined),
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
          icon: CupertinoIcons.trash_fill,
          audioPath: 'se5.wav',
          tooltip: t.common.clear,
          callback: (_) => _debuggerProvider.clear(),
        ),
      ],
    );
  }

  void _listenDebugger() => ref.listen(
        debuggerProvider,
        (_, __) {
          if (!isPined) {
            _animateTo();
          }
        },
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

  DebuggerProvider get _debuggerProvider => ref.read(debuggerProvider.notifier);

  List<DebuggerModel> get _logs => ref.watch(debuggerProvider);
}
