import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/config/asset_config.dart';
import 'package:mana_studio/config/debugger_config.dart';
import 'package:mana_studio/config/project_config.dart';
import 'package:mana_studio/config/storage_config.dart';
import 'package:mana_studio/models/project_model.dart';
import 'package:mana_studio/models/scenes/scene_content_model.dart';
import 'package:mana_studio/models/scenes/scene_model.dart';
import 'package:mana_studio/models/scenes/scenes_model.dart';
import 'package:mana_studio/models/script_model.dart';
import 'package:mana_studio/models/scripts_model.dart';
import 'package:mana_studio/providers/debugger_provider.dart';
import 'package:mana_studio/providers/game_provider.dart';
import 'package:mana_studio/utils/loaders/scene_loader.dart';
import 'package:mana_studio/utils/loaders/script_loader.dart';
import 'package:mana_studio/utils/managers/storage_manager.dart';
import 'package:mana_studio/utils/script_runner.dart';
import 'package:uuid/uuid.dart';

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

  void addSceneContent(dynamic prev, dynamic next, [bool isRoot = false]) {
    try {
      List<dynamic> contents = [...state.sceneContents];
      if (isRoot) {
        contents = _addSceneContentNewItem(contents, prev);
      } else {
        contents = _addSceneContent(contents, prev, next);
      }
      changeSceneContent(contents);
    } on StackOverflowError catch (e) {
      _debuggerProvider.addDebug(e.toString(), errorDebug);
    }
  }

  List<dynamic> _addSceneContent(
    List<dynamic> contents,
    dynamic prev,
    dynamic next,
  ) =>
      contents.map((content) {
        if (content['children'] != null) {
          if (content['uuid'] == next['uuid']) {
            content['children'] = _addSceneContentNewItem(
              content['children'],
              prev,
            );
          }
          content['children'] = _addSceneContent(
            content['children'],
            prev,
            next,
          );
        }
        return content;
      }).toList();

  List<dynamic> _addSceneContentNewItem(
    List<dynamic> contents,
    dynamic content,
  ) {
    dynamic item = json.decode(json.encode(content));
    item['uuid'] = const Uuid().v4();
    contents = [...contents, item];
    return contents;
  }

  void setSceneContent(String uuid, dynamic next) {
    List<dynamic> contents = [...state.sceneContents];
    contents = _setSceneContents(contents, uuid, next);
    changeSceneContent(contents);
  }

  List<dynamic> _setSceneContents(
    List<dynamic> contents,
    String uuid,
    dynamic next,
  ) =>
      contents.map((content) {
        if (content['uuid'] == uuid) {
          content = next;
        }
        if (content['children'] != null) {
          content['children'] = _setSceneContents(
            content['children'],
            uuid,
            next,
          );
        }
        return content;
      }).toList();

  void swipeSceneContent(dynamic prev, dynamic next) {
    List<dynamic> contents = [...state.sceneContents];
    contents = _swipeSceneContents(contents, prev, next);
    changeSceneContent(contents);
  }

  List<dynamic> _swipeSceneContents(
    List<dynamic> contents,
    dynamic prev,
    dynamic next,
  ) =>
      contents.map((content) {
        content['temp'] = content['uuid'];
        if (content['temp'] == prev['uuid']) {
          content = next;
          content['temp'] = prev['uuid'];
        }
        if (content['temp'] == next['uuid']) {
          content = prev;
          content['temp'] = next['uuid'];
        }
        if (content['children'] != null) {
          content['children'] = _swipeSceneContents(
            content['children'],
            prev,
            next,
          );
        }
        return content;
      }).toList();

  void changeSceneContent(dynamic content) {
    final findIndex = state.scenes.localScenes.indexWhere(
      (e) => e.fileName == state.sceneName,
    );
    if (findIndex < 0) {
      return;
    }
    List<SceneModel> scenes = [...state.scenes.localScenes];
    scenes[findIndex] = scenes[findIndex].copyWith(
      content: json.encode(content),
    );
    setLocalScenes(scenes);
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
    return state.sceneContentsWithChildren;
  }

  void setScenes(ScenesModel scenes) => state = state.copyWith(scenes: scenes);

  void setLocalScenes(List<SceneModel> localScenes) =>
      setScenes(state.scenes.copyWith(localScenes: localScenes));

  void setScripts(ScriptsModel scripts) =>
      state = state.copyWith(scripts: scripts);

  GameProvider get _gameProvider => ref.read(gameProvider.notifier);

  DebuggerProvider get _debuggerProvider => ref.read(debuggerProvider.notifier);
}

final projectProvider = StateNotifierProvider<ProjectProvider, ProjectModel>(
  (ref) => ProjectProvider(ref),
);
