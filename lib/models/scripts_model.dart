import 'package:mana_studio/models/script_model.dart';

class ScriptsModel {
  ScriptsModel(this.coreScripts, this.defaultScripts, this.localScripts);

  final List<ScriptModel> coreScripts;
  final List<ScriptModel> defaultScripts;
  final List<ScriptModel> localScripts;

  String _merge(List<ScriptModel> scripts) =>
      scripts.map((e) => e.code).join('\n');

  String get coreScript => _merge(coreScripts);

  String get defaultScript => _merge(defaultScripts);

  String get localScript => _merge(localScripts);

  String get code => '$coreScript\n$localScript';
}
