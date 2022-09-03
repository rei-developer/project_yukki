import 'package:flutter/cupertino.dart';
import 'package:mana_studio/components/common/custom_button.dart';
import 'package:mana_studio/config/scene_command_config.dart';
import 'package:mana_studio/config/ui_config.dart';
import 'package:mana_studio/utils/func.dart';
import 'package:mana_studio/utils/max_lines_text_input_formatter.dart';

class SceneCommandContextManager {
  SceneCommandContextManager(
    this.content,
    this.color, [
    this.onChanged,
  ]);

  final dynamic content;
  final Color color;
  final Function(dynamic next)? onChanged;

  Widget? get render {
    switch (type) {
      case showMessageCommand:
      case commentCommand:
        return _renderEditDescription;
    }
    return null;
  }

  Widget? get _renderEditDescription {
    if (!hasKey('description')) {
      return null;
    }
    final description = ValueNotifier(data['description'] ?? '');
    final controller = TextEditingController(text: description.value);
    final focusNode = FocusNode(
      onKey: (node, event) {
        if ((event.isControlPressed || event.isMetaPressed) && event.logicalKey.keyLabel == 'Enter') {
          node.unfocus();
          data['description'] = description.value;
          onChanged?.call(content);
        }
        return KeyEventResult.ignored;
      },
    );
    return ValueListenableBuilder(
      builder: (context, value, _) => Column(
        children: [
          CupertinoTextField.borderless(
            inputFormatters: [MaxLinesTextInputFormatter(4)],
            focusNode: focusNode,
            controller: controller,
            decoration: BoxDecoration(color: color.withOpacity(0.1)),
            style: primaryTextStyle.copyWith(color: color),
            cursorColor: color,
            maxLines: 4,
            maxLength: 500,
            autofocus: true,
            onChanged: (text) => description.value = text,
          ),
          if (value != data['description'])
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomButton(
                      '저장',
                      color: color,
                      icon: CupertinoIcons.archivebox_fill,
                      onSubmitted: () {
                        focusNode.unfocus();
                        data['description'] = description.value;
                        onChanged?.call(content);
                      },
                    ),
                    const SizedBox(width: 10),
                    Text('(Ctrl + Enter)', style: primaryTextStyle.copyWith(color: color)),
                  ],
                ),
                Text('${description.value.length} / 500', style: primaryTextStyle.copyWith(color: color)),
              ],
            ),
        ].superJoin(const SizedBox(height: 10)).toList(),
      ),
      valueListenable: description,
    );
  }

  bool hasKey(String key) => !(data.isEmpty || !data.containsKey(key));

  String get uuid => content['uuid'];

  String get type => content['type'];

  Map<String, dynamic> get data => content['data'] ?? {};
}
