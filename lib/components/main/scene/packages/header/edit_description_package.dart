import 'package:flutter/cupertino.dart';
import 'package:mana_studio/models/scene/scene_command_package_model.dart';
import 'package:mana_studio/utils/render/render_modal_popup.dart';

class EditDescriptionPackage {
  EditDescriptionPackage(this.package);

  final SceneCommandPackageModel package;

  Widget? get render {
    if (!package.hasKey('description')) {
      return null;
    }
    // return Text(package.data['description']);
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Text('변수'),
      onPressed: () => renderModalPopup(
        package.context,
        Text('안녕하세요?'),
        // barrierDismissible: false,
      ),
    );
  }
}
