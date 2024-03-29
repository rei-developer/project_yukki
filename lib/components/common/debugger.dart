import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/components/common/section.dart';
import 'package:project_yukki/components/common/section_header_button.dart';
import 'package:project_yukki/config/debugger_config.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/i18n/strings.g.dart';
import 'package:project_yukki/models/debugger_model.dart';
import 'package:project_yukki/providers/debugger_provider.dart';
import 'package:project_yukki/utils/func.dart';
import 'package:project_yukki/utils/render/render_widget_list.dart';

class Debugger extends ConsumerStatefulWidget {
  const Debugger({Key? key}) : super(key: key);

  @override
  ConsumerState<Debugger> createState() => _DebugConsoleState();
}

class _DebugConsoleState extends ConsumerState<Debugger> {
  final ScrollController controller = ScrollController();
  bool isPined = false;

  @override
  Widget build(BuildContext context) {
    _listenDebugger();
    return Section(
      Text(t.headers.debugger, style: darkTextBoldStyle),
      ListView(
        controller: controller,
        physics: const ClampingScrollPhysics(),
        children: renderWidgetList(_renderDebugConsole, padding: 5),
      ),
      icon: CupertinoIcons.captions_bubble,
      headerChildren: [
        SectionHeaderButton(
          icon: isPined ? CupertinoIcons.pin_fill : CupertinoIcons.pin_slash,
          tooltip: isPined ? t.common.unpin : t.common.pin,
          callback: (_) => setState(() => isPined = !isPined),
        ),
        SectionHeaderButton(
          icon: CupertinoIcons.arrow_up,
          tooltip: t.common.up,
          callback: (_) => _upperScrollTo(-100),
        ),
        SectionHeaderButton(
          icon: CupertinoIcons.arrow_up_to_line,
          tooltip: t.common.upToLine,
          callback: (_) => _animateTo(0),
        ),
        SectionHeaderButton(
          icon: CupertinoIcons.arrow_down,
          tooltip: t.common.down,
          callback: (_) => _upperScrollTo(100),
        ),
        SectionHeaderButton(
          icon: CupertinoIcons.arrow_down_to_line,
          tooltip: t.common.downToLine,
          callback: (_) => _animateTo(),
        ),
        SectionHeaderButton(
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
        decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(3))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(label, style: darkTextBoldStyle),
        ),
      );

  List<Widget> get _renderDebugConsole => _logs
      .map(
        (e) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: renderWidgetList(
            [
              _renderLabelBox(e.type, e.color),
              _renderLabelBox(e.time, dateTimeDebugColor),
              Expanded(child: Text(': ${e.description}', style: lightTextStyle)),
            ],
            padding: 5,
            isVertical: false,
          ),
        ),
      )
      .toList();

  DebuggerProvider get _debuggerProvider => ref.read(debuggerProvider.notifier);

  List<DebuggerModel> get _logs => ref.watch(debuggerProvider);
}
