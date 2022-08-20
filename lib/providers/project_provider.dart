import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/config/asset_config.dart';
import 'package:mana_studio/config/project_config.dart';
import 'package:mana_studio/config/storage_config.dart';
import 'package:mana_studio/models/project_model.dart';
import 'package:mana_studio/models/scenes/scene_content_model.dart';
import 'package:mana_studio/models/scenes/scene_model.dart';
import 'package:mana_studio/models/scenes/scenes_model.dart';
import 'package:mana_studio/models/script_model.dart';
import 'package:mana_studio/models/scripts_model.dart';
import 'package:mana_studio/providers/game_provider.dart';
import 'package:mana_studio/utils/loaders/scene_loader.dart';
import 'package:mana_studio/utils/loaders/script_loader.dart';
import 'package:mana_studio/utils/managers/storage_manager.dart';
import 'package:mana_studio/utils/script_runner.dart';

class ProjectProvider extends StateNotifier<ProjectModel> {
  ProjectProvider(this.ref) : super(ProjectModel.initial());

  final Ref ref;

  Future<void> run() async {
    await runScript();
    await runScene();
  }

  Future<void> runScene() async {
    final sceneLoader = SceneLoader();
    final localScenes = await sceneLoader.loadLocalScenes();
    setScenes(state.scenes.copyWith(localScenes: localScenes));
    _gameProvider.run(setSceneName());
  }

  Future<void> runScript([String? code]) async {
    if (code == null) {
      final scriptLoader = ScriptLoader();
      final localScripts = await scriptLoader.loadLocalScripts();
      setScripts(state.scripts.copyWith(localScripts: localScripts));
    }
    final runner = ScriptRunner(code ?? state.scripts.code);
    await runner.run();
  }

  Future<void> loadProject() async {
    await loadScenes();
    await loadScripts();
  }

  Future<void> loadScenes() async {
    final sceneLoader = SceneLoader();
    final scenes = await sceneLoader.load();
    setScenes(scenes);
  }

  Future<void> loadScripts() async {
    final scriptLoader = ScriptLoader();
    final scripts = await scriptLoader.load();
    setScripts(scripts);
  }

  Future<void> generateProject() async {
    await generateLocalScenes();
    await generateLocalScripts();
  }

  Future<void> generateLocalScenes() async {
    List<SceneModel> localScenes = [];
    for (final defaultScene in state.scenes.defaultScenes) {
      final fileName = defaultScene.fileName;
      final path = '$scenesPath/$fileName$jsonExt';
      final content = defaultScene.content;
      await StorageManager(path).write(content);
      localScenes.add(SceneModel(localSceneType, fileName, content));
    }
    if (localScenes.isEmpty) {
      return;
    }
    setScenes(state.scenes.copyWith(localScenes: localScenes));
  }

  Future<void> generateLocalScripts() async {
    List<ScriptModel> localScripts = [];
    for (final defaultScript in state.scripts.defaultScripts) {
      final fileName = defaultScript.fileName;
      final path = '$scriptsPath/$fileName$jsExt';
      final script = defaultScript.code;
      await StorageManager(path).write(script);
      localScripts.add(ScriptModel(localScriptType, fileName, script));
    }
    if (localScripts.isEmpty) {
      return;
    }
    setScripts(state.scripts.copyWith(localScripts: localScripts));
  }

  List<SceneContentModel> setSceneName([String sceneName = firstSceneName]) {
    state = state.copyWith(sceneName: sceneName);
    return state.sceneContents;
  }

  void setScenes(ScenesModel scenes) => state = state.copyWith(scenes: scenes);

  void setScripts(ScriptsModel scripts) =>
      state = state.copyWith(scripts: scripts);

  GameProvider get _gameProvider => ref.read(gameProvider.notifier);
}

final projectProvider = StateNotifierProvider<ProjectProvider, ProjectModel>(
  (ref) => ProjectProvider(ref),
);
