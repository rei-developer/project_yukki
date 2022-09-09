import 'package:flutter/cupertino.dart';
import 'package:project_yukki/components/main/scene/packages/header/edit_description_package.dart';
import 'package:project_yukki/config/scene_command_config.dart';
import 'package:project_yukki/models/scene/scene_command_package_model.dart';

class SceneCommandHeaderPackageManager {
  SceneCommandHeaderPackageManager(this.package);

  final SceneCommandPackageModel package;

  Widget? get render => _render == null
      ? null
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_render!],
        );

  Widget? get _render {
    switch (package.type) {
      case showMessageCommand:
      case commentCommand:
        return EditDescriptionPackage(package).render;
    }
    return null;
  }
}
