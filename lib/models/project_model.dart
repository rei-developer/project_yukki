import 'package:mana_studio/models/scripts_model.dart';

class ProjectModel {
  ProjectModel(this.scripts);

  factory ProjectModel.initial({
    ScriptsModel? scripts,
  }) =>
      ProjectModel(
        scripts ?? ScriptsModel.initial(),
      );

  ProjectModel copyWith({
    ScriptsModel? scripts,
  }) =>
      ProjectModel(
        scripts ?? this.scripts,
      );

  final ScriptsModel scripts;
}
