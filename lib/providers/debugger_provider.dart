import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mana_studio/config/debugger_config.dart';
import 'package:mana_studio/models/debugger_model.dart';

class DebuggerProvider extends StateNotifier<List<DebuggerModel>> {
  DebuggerProvider(this.ref) : super([]);

  final Ref ref;

  void addDebug(
    String description, [
    String type = defaultDebug,
  ]) =>
      state = [
        ...state,
        DebuggerModel.initial(
          type: type,
          color: getDebugColor(type),
          description: description,
        ),
      ];
}

final debuggerProvider =
    StateNotifierProvider<DebuggerProvider, List<DebuggerModel>>(
  (ref) => DebuggerProvider(ref),
);
