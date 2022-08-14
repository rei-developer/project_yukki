import 'package:mana_studio/config/asset_config.dart';
import 'package:mana_studio/config/storage_config.dart';
import 'package:mana_studio/models/script_model.dart';
import 'package:mana_studio/models/scripts_model.dart';
import 'package:mana_studio/utils/managers/asset_manager.dart';
import 'package:mana_studio/utils/managers/storage_manager.dart';

class ScriptLoader {
  Future<ScriptsModel> load() async {
    final coreScripts = await _loadScriptsAssets(
      coreScriptType,
      _coreScriptsSource,
      coreScriptsAssets,
    );
    final defaultScripts = await _loadScriptsAssets(
      defaultScriptType,
      _defaultScriptsSource,
      defaultScriptsAssets,
    );
    return ScriptsModel.initial(
      coreScripts: coreScripts,
      defaultScripts: defaultScripts,
    );
  }

  Future<List<ScriptModel>> loadLocalScripts() async {
    List<ScriptModel> scripts = [];
    final localScripts = (await StorageManager(scriptsPath).files)
        ?.where((element) => element.endsWith(jsExt))
        .toList();
    if (localScripts == null || localScripts.isEmpty) {
      return [];
    }
    for (final localScript in localScripts) {
      final documents = await StorageManager(localScript).documents;
      final fileName = localScript
          .replaceAll('$documents/$scriptsPath/', '')
          .replaceAll(jsExt, '');
      final script = await StorageManager(localScript, false).read();
      if (script == null) {
        continue;
      }
      scripts.add(ScriptModel(localScriptType, fileName, script));
    }
    return scripts;
  }

  Future<List<ScriptModel>> _loadScriptsAssets(
    String type,
    String source,
    String assetsPath,
  ) async {
    List<ScriptModel> scripts = [];
    final keys = (await _manifestMap)
        .where((key) => RegExp(source).hasMatch(key))
        .toList();
    for (final key in keys) {
      final fileName = _getFileNameByAssetPath(source, key);
      if (fileName == null) {
        continue;
      }
      scripts.add(
        ScriptModel(
          type,
          fileName,
          await AssetManager(
            assetsPath,
            fileName,
            jsExt,
          ).loadString,
        ),
      );
    }
    return scripts;
  }

  String? _getFileNameByAssetPath(String source, String assetPath) =>
      RegExp(source).firstMatch(assetPath)?.group(1);

  Future<Iterable<String>> get _manifestMap async =>
      (await AssetManager().loadAssetManifest).keys;

  String get _coreScriptsSource => r'assets\/scripts\/core_scripts\/(.*?)\.js';

  String get _defaultScriptsSource =>
      r'assets\/scripts\/default_scripts\/(.*?)\.js';
}
