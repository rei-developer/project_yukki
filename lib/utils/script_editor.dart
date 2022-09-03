import 'package:flutter/cupertino.dart';
import 'package:highlight/highlight.dart';

class ScriptEditor extends StatefulWidget {
  ScriptEditor(
    this.controller, {
    this.language,
    this.theme = const {},
    int tabSize = 8,
    Key? key,
  })  : initialSource = controller.text.replaceAll('\t', ' ' * tabSize),
        super(key: key);

  final TextEditingController controller;
  final String initialSource;
  final String? language;
  final Map<String, TextStyle> theme;

  static const _rootKey = 'root';

  @override
  State<ScriptEditor> createState() => _ScriptEditorState();
}

class _ScriptEditorState extends State<ScriptEditor> {
  String source = '';

  final ScrollController _previewController = ScrollController();
  final ScrollController _textFieldScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    source = widget.controller.text;
    _textFieldScrollController.addListener(
      () {
        if (_previewController.hasClients && _textFieldScrollController.hasClients) {
          _previewController.jumpTo(_textFieldScrollController.position.pixels);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _previewController.dispose();
    _textFieldScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: widget.theme[ScriptEditor._rootKey]?.backgroundColor,
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _previewController,
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(
                            source.split('\n').length,
                            (index) => Text('${index + 1}', style: _textStyle),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: RichText(text: TextSpan(style: _textStyle, children: _convert(_nodes)))),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                controller: _textFieldScrollController,
                child: CupertinoTextField(
                  controller: widget.controller,
                  padding: const EdgeInsets.only(left: 50),
                  maxLines: null,
                  expands: true,
                  decoration: const BoxDecoration(color: Color(0x00000000)),
                  style: _textStyle.copyWith(color: const Color(0x00000000)),
                  onChanged: (text) => setState(() => source = text),
                ),
              ),
            ],
          ),
        ),
      );

  List<TextSpan> _convert(List<Node> nodes) {
    List<TextSpan> spans = [];
    List<TextSpan> currentSpans = spans;
    List<List<TextSpan>> stack = [];
    _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(
          node.className == null
              ? TextSpan(text: node.value)
              : TextSpan(text: node.value, style: widget.theme[node.className!]),
        );
      } else if (node.children != null) {
        List<TextSpan> temp = [];
        currentSpans.add(TextSpan(children: temp, style: widget.theme[node.className!]));
        stack.add(currentSpans);
        currentSpans = temp;
        for (final n in node.children!) {
          _traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        }
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }
    return spans;
  }

  TextStyle get _textStyle => TextStyle(
        color: widget.theme[ScriptEditor._rootKey]?.color,
        height: 1.4,
        letterSpacing: 0.4,
        fontSize: 14,
        fontFamily: 'D2Coding',
      );

  List<Node> get _nodes => highlight.parse(source, language: widget.language).nodes!;
}
