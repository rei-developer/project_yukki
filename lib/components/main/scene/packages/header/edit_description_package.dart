import 'package:flutter/cupertino.dart';
import 'package:mana_studio/models/scene/scene_command_package_model.dart';

class EditDescriptionPackage {
  EditDescriptionPackage(this.package);

  final SceneCommandPackageModel package;

  Widget? get render {
    if (!package.hasKey('description')) {
      return null;
    }
    return Text(package.data['description']);
  }
}
