import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_yukki/config/debugger_config.dart';
import 'package:project_yukki/models/debugger_model.dart';
import 'package:project_yukki/providers/audio_player_provider.dart';

class DebuggerProvider extends StateNotifier<List<DebuggerModel>> {
  DebuggerProvider(this.ref) : super([]);

  final Ref ref;

  void addDebug(String description, [String type = defaultDebug, bool isPlaySound = true]) {
    if (isPlaySound) {
      _audioProvider.setSE('se8.wav');
    }
    state = [
      ...state,
      DebuggerModel.initial(
        type: type,
        color: getDebugColor(type),
        description: description,
      ),
    ];
  }

  void clear() => state = [];

  AudioPlayerProvider get _audioProvider => ref.read(audioPlayerProvider.notifier);
}

final debuggerProvider = StateNotifierProvider<DebuggerProvider, List<DebuggerModel>>((ref) => DebuggerProvider(ref));
