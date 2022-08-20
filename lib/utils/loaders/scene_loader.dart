import 'package:mana_studio/config/asset_config.dart';
import 'package:mana_studio/config/storage_config.dart';
import 'package:mana_studio/models/scenes/scene_model.dart';
import 'package:mana_studio/models/scenes/scenes_model.dart';
import 'package:mana_studio/utils/managers/asset_manager.dart';
import 'package:mana_studio/utils/managers/storage_manager.dart';

class SceneLoader {
  Future<ScenesModel> load() async {
    final defaultScenes = await _loadScenesAssets(
      defaultSceneType,
      _defaultScenesSource,
      scenesAssets,
    );
    return ScenesModel.initial(
      defaultScenes: defaultScenes,
    );
  }

  Future<List<SceneModel>> loadLocalScenes() async {
    List<SceneModel> scenes = [];
    final localScenes = (await StorageManager(scenesPath).files)
        ?.where((element) => element.endsWith(jsonExt))
        .toList();
    if (localScenes == null || localScenes.isEmpty) {
      return [];
    }
    for (final localScene in localScenes) {
      final documents = await StorageManager(localScene).documents;
      final fileName = localScene
          .replaceAll('$documents/$scenesPath/', '')
          .replaceAll(jsonExt, '');
      final scene = await StorageManager(localScene, false).read();
      if (scene == null) {
        continue;
      }
      scenes.add(SceneModel(localSceneType, fileName, scene));
    }
    return scenes;
  }

  Future<List<SceneModel>> _loadScenesAssets(
    String type,
    String source,
    String assetsPath,
  ) async {
    List<SceneModel> scenes = [];
    final keys = (await _manifestMap)
        .where((key) => RegExp(source).hasMatch(key))
        .toList();
    for (final key in keys) {
      final fileName = _getFileNameByAssetPath(source, key);
      if (fileName == null) {
        continue;
      }
      scenes.add(
        SceneModel(
          type,
          fileName,
          await AssetManager(
            assetsPath,
            fileName,
            jsonExt,
          ).loadString,
        ),
      );
    }
    return scenes;
  }

  String? _getFileNameByAssetPath(String source, String assetPath) =>
      RegExp(source).firstMatch(assetPath)?.group(1);

  Future<Iterable<String>> get _manifestMap async =>
      (await AssetManager().loadAssetManifest).keys;

  String get _defaultScenesSource => r'assets\/scenes\/(.*?)\.json';
}
