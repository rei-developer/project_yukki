import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/config/asset_config.dart';
import 'package:mana_studio/config/storage_config.dart';
import 'package:mana_studio/models/project_model.dart';
import 'package:mana_studio/models/script_model.dart';
import 'package:mana_studio/models/scripts_model.dart';
import 'package:mana_studio/utils/loaders/script_loader.dart';
import 'package:mana_studio/utils/managers/storage_manager.dart';
import 'package:mana_studio/utils/script_runner.dart';

class ProjectProvider extends StateNotifier<ProjectModel> {
  ProjectProvider(this.ref) : super(ProjectModel.initial());

  final Ref ref;

  Future<void> run() async {
    await loadScripts();
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

  Future<void> loadScripts() async {
    final scriptLoader = ScriptLoader();
    final scripts = await scriptLoader.load();
    setScripts(scripts);
  }

  Future<void> generateProject() async {
    await generateLocalScripts();
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

  void setScripts(ScriptsModel value) => state = state.copyWith(scripts: value);
}

final projectProvider = StateNotifierProvider<ProjectProvider, ProjectModel>(
  (ref) => ProjectProvider(ref),
);
