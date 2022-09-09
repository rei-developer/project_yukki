import 'package:flutter/cupertino.dart';
import 'package:project_yukki/components/common/custom_button.dart';
import 'package:project_yukki/config/ui_config.dart';
import 'package:project_yukki/models/scene/scene_command_package_model.dart';
import 'package:project_yukki/utils/max_lines_text_input_formatter.dart';
import 'package:project_yukki/utils/render/render_widget_list.dart';

class EditDescriptionPackage {
  EditDescriptionPackage(this.package);

  final SceneCommandPackageModel package;

  Widget? get render {
    if (!package.hasKey('description')) {
      return null;
    }
    final description = ValueNotifier(package.data['description'] ?? '');
    final controller = TextEditingController(text: description.value);
    final focusNode = FocusNode(
      onKey: (node, event) {
        if ((event.isControlPressed || event.isMetaPressed) && event.logicalKey.keyLabel == 'Enter') {
          node.unfocus();
          package.data['description'] = description.value;
          package.onChanged?.call(package.content);
        }
        return KeyEventResult.ignored;
      },
    );
    return ValueListenableBuilder(
      builder: (context, value, _) => Column(
        children: renderWidgetList(
          [
            CupertinoTextField.borderless(
              inputFormatters: [MaxLinesTextInputFormatter(4)],
              focusNode: focusNode,
              controller: controller,
              decoration: BoxDecoration(color: package.color.withOpacity(0.1)),
              style: primaryTextStyle.copyWith(color: package.color),
              cursorColor: package.color,
              maxLines: 4,
              maxLength: 500,
              autofocus: true,
              onChanged: (text) => description.value = text,
            ),
            if (value != package.data['description'])
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomButton(
                        '저장',
                        color: package.color,
                        icon: CupertinoIcons.archivebox_fill,
                        onSubmitted: () {
                          focusNode.unfocus();
                          package.data['description'] = description.value;
                          package.onChanged?.call(package.content);
                        },
                      ),
                      const SizedBox(width: 10),
                      Text('(Ctrl + Enter)', style: primaryTextStyle.copyWith(color: package.color)),
                    ],
                  ),
                  Text('${description.value.length} / 500', style: primaryTextStyle.copyWith(color: package.color)),
                ],
              ),
          ],
        ),
      ),
      valueListenable: description,
    );
  }
}
