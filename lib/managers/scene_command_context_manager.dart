import 'package:flutter/cupertino.dart';
import 'package:mana_studio/config/scene_command_config.dart';
import 'package:mana_studio/config/ui_config.dart';

class SceneCommandContextManager {
  SceneCommandContextManager(
    this.content,
    this.color, [
    this.onSelected,
    this.onChanged,
  ]);

  final dynamic content;
  final Color color;
  final VoidCallback? onSelected;
  final Function(dynamic next)? onChanged;

  Widget? get render {
    switch (_type) {
      case showMessageCommand:
        return _renderShowMessage;
    }
    return null;
  }

  FocusNode? focusNode;

  bool _hasKey(String key) => !(_data.isEmpty || !_data.containsKey(key));

  Widget? get _renderShowMessage {
    if (!_hasKey('description')) {
      return null;
    }
    final description = ValueNotifier(_data['description'] ?? '');
    final controller = TextEditingController(text: _data['description']);
    // controller.selection = TextSelection.fromPosition(
    //   TextPosition(offset: _data['description'].length),
    // );
    final focusNode = FocusNode(
      onKey: (node, event) {
        if (!event.isShiftPressed && event.logicalKey.keyLabel == 'Enter') {
          _data['description'] = description.value;
          onChanged?.call(content);
          node.unfocus();
        }
        return KeyEventResult.ignored;
      },
    );
    return ValueListenableBuilder(
      builder: (context, value, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 600,
            child: CupertinoTextField.borderless(
              controller: controller,
              focusNode: focusNode,
              decoration: BoxDecoration(color: color.withOpacity(0.1)),
              style: primaryTextStyle.copyWith(color: color),
              cursorColor: color,
              maxLines: 4,
              autofocus: true,
              onTap: () {
                onSelected?.call();
              },
              onChanged: (text) => description.value = text,
            ),
          ),
        ],
      ),
      valueListenable: description,
    );
  }

  String get _uuid => content['uuid'];

  String get _type => content['type'];

  Map<String, dynamic> get _data => content['data'] ?? {};
}
