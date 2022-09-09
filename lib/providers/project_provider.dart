import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/config/asset_config.dart';
import 'package:project_yukki/config/debugger_config.dart';
import 'package:project_yukki/config/project_config.dart';
import 'package:project_yukki/config/storage_config.dart';
import 'package:project_yukki/models/project_model.dart';
import 'package:project_yukki/models/scene/scene_content_model.dart';
import 'package:project_yukki/models/scene/scene_model.dart';
import 'package:project_yukki/models/scene/scenes_model.dart';
import 'package:project_yukki/models/script/script_model.dart';
import 'package:project_yukki/models/script/scripts_model.dart';
import 'package:project_yukki/providers/audio_player_provider.dart';
import 'package:project_yukki/providers/debugger_provider.dart';
import 'package:project_yukki/providers/game_provider.dart';
import 'package:project_yukki/utils/loaders/scene_loader.dart';
import 'package:project_yukki/utils/loaders/script_loader.dart';
import 'package:project_yukki/managers/storage_manager.dart';
import 'package:project_yukki/utils/script_runner.dart';
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
    setLocalScenes(localScenes);
    setHistoryScenes([localScenes]);
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
    setLocalScenes(localScenes);
  }

  void addSceneContent(dynamic prev, dynamic next, [bool isRoot = false, bool isRemove = false]) {
    try {
      List<dynamic> contents = [...state.sceneContents];
      if (isRoot) {
        contents = _addSceneContentNewItem(contents, prev);
      } else {
        contents = _addSceneContent(contents, prev, next);
      }
      changeSceneContent(contents);
      final uuid = prev['uuid'];
      if (uuid == null || !isRemove) {
        return;
      }
      removeSceneContent(uuid, false, false);
    } on StackOverflowError catch (e) {
      _debuggerProvider.addDebug(e.toString(), errorDebug);
    }
  }

  List<dynamic> _addSceneContent(List<dynamic> contents, dynamic prev, dynamic next) => contents.map(
        (content) {
          if (content['children'] == null) {
            if (content['uuid'] == next['uuid']) {
              final temp = content['uuid'];
              content = prev;
              content['uuid'] = temp;
            }
          } else {
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
        },
      ).toList();

  List<dynamic> _addSceneContentNewItem(List<dynamic> contents, dynamic content) {
    dynamic item = json.decode(json.encode(content));
    item['uuid'] = const Uuid().v4();
    contents = [...contents, item];
    return contents;
  }

  void addSearchedSceneCommand(dynamic command) {
    List<dynamic> commands = [...state.searchedSceneCommands];
    final findIndex = commands.indexWhere((e) => e['type'] == command['type']);
    if (findIndex >= 0) {
      commands.removeAt(findIndex);
    }
    commands.add(command);
    if (commands.length > 10) {
      commands.removeAt(0);
    }
    state = state.copyWith(searchedSceneCommands: commands);
  }

  void setSceneContent(dynamic next) {
    List<dynamic> contents = [...state.sceneContents];
    contents = _setSceneContents(contents, next);
    changeSceneContent(contents, false);
  }

  List<dynamic> _setSceneContents(List<dynamic> contents, dynamic next) => contents.map(
        (content) {
          final uuid = next['uuid'];
          if (content['uuid'] == uuid) {
            content = next;
          }
          if (content['children'] != null) {
            content['children'] = _setSceneContents(content['children'], next);
          }
          return content;
        },
      ).toList();

  void setAllSceneContent(String key, dynamic value) {
    List<dynamic> contents = [...state.sceneContents];
    contents = _setAllSceneContents(contents, key, value);
    changeSceneContent(contents, false);
  }

  List<dynamic> _setAllSceneContents(List<dynamic> contents, String key, dynamic value) => contents.map(
        (content) {
          content[key] = value;
          if (content['children'] != null) {
            content['children'] = _setAllSceneContents(
              content['children'],
              key,
              value,
            );
          }
          return content;
        },
      ).toList();

  void swipeSceneContent(dynamic prev, dynamic next) {
    List<dynamic> contents = [...state.sceneContents];
    contents = _swipeSceneContents(contents, prev, next);
    changeSceneContent(contents);
  }

  List<dynamic> _swipeSceneContents(List<dynamic> contents, dynamic prev, dynamic next) => contents.map(
        (content) {
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
        },
      ).toList();

  void changeSceneContent(dynamic content, [bool isPlaySound = true, bool isPushHistory = true]) {
    if (_findLocalSceneIndex < 0) {
      return;
    }
    List<SceneModel> scenes = [...state.scenes.localScenes];
    scenes[_findLocalSceneIndex] = scenes[_findLocalSceneIndex].copyWith(content: json.encode(content));
    if (isPlaySound) {
      _audioProvider.setSE('sound12.mp3');
    }
    setLocalScenes(scenes);
    if (isPushHistory) {
      setHistoryScenes([...state.scenes.historyScenes, scenes]);
    }
  }

  void popHistoryScenes() {
    List<List<SceneModel>> historyScenes = state.scenes.historyScenes;
    if (historyScenes.length <= 1) {
      return;
    }
    historyScenes.removeLast();
    setLocalScenes(historyScenes.last);
    setHistoryScenes(historyScenes);
  }

  void removeSceneContent(String uuid, [bool isClearChildrenOnly = false, bool isPushHistory = true]) {
    List<dynamic> contents = [...state.sceneContents];
    contents = _removeSceneContent(contents, uuid, isClearChildrenOnly);
    changeSceneContent(contents, false, isPushHistory);
  }

  List<dynamic> _removeSceneContent(List<dynamic> contents, String uuid, bool isClearChildrenOnly) => contents
      .map(
        (content) {
          if (content['uuid'] == uuid && !isClearChildrenOnly) {
            return null;
          }
          if (content['children'] != null) {
            if (content['uuid'] == uuid && isClearChildrenOnly) {
              content['children'] = [];
            }
            content['children'] = _removeSceneContent(
              content['children'],
              uuid,
              isClearChildrenOnly,
            );
          }
          return content;
        },
      )
      .where((e) => e != null)
      .toList();

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

  void setLocalScenes(List<SceneModel> localScenes) => setScenes(state.scenes.copyWith(localScenes: localScenes));

  void setHistoryScenes(List<List<SceneModel>> historyScenes) =>
      setScenes(state.scenes.copyWith(historyScenes: historyScenes));

  void setScripts(ScriptsModel scripts) => state = state.copyWith(scripts: scripts);

  void clearSceneContent() => changeSceneContent([], false);

  int get _findLocalSceneIndex => state.scenes.localScenes.indexWhere((e) => e.fileName == state.sceneName);

  AudioPlayerProvider get _audioProvider => ref.read(audioPlayerProvider.notifier);

  GameProvider get _gameProvider => ref.read(gameProvider.notifier);

  DebuggerProvider get _debuggerProvider => ref.read(debuggerProvider.notifier);
}

final projectProvider = StateNotifierProvider<ProjectProvider, ProjectModel>((ref) => ProjectProvider(ref));
