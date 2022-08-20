import 'package:mana_studio/config/scene_command_config.dart';
import 'package:mana_studio/models/scenes/scene_content_model.dart';

class IfCommandHandler {
  IfCommandHandler(this.data, this.type, [this.prev]);

  final dynamic data;
  final String type;
  final SceneContentModel? prev;

  bool get isMetCondition {
    try {
      if (!_checkPrevContent) {
        return false;
      }
      if (type == elseCommand) {
        return true;
      }
      final value = _data.value;
      if (value == null) {
        return false;
      }
      switch (_data.equation) {
        case 'Equal to':
          return _variable == value;
        case 'Not Equal to':
          return _variable != value;
        case 'Greater than':
          return _variable > value;
        case 'Greater or equal to':
          return _variable >= value;
        case 'Less than':
          return _variable < value;
        case 'Less or equal to':
          return _variable <= value;
        default:
          return false;
      }
    } catch (_) {
      return false;
    }
  }

  bool get _checkPrevContent {
    if (prev == null) {
      return true;
    }
    return !((prev?.type != ifCommand && prev?.type != elseIfCommand) ||
        prev?.type == elseCommand);
  }

  dynamic get _variable => 300;

  _IfCommandModel get _data => _IfCommandModel.fromJson(data);
}

class _IfCommandModel {
  _IfCommandModel(this.type, this.variable, this.equation, this.value);

  _IfCommandModel.fromJson(json)
      : type = (json['type'] ?? '') as String,
        variable = (json['variable'] ?? 0) as int,
        equation = (json['equation'] ?? '') as String,
        value = json['value'];

  final String type;
  final int variable;
  final String equation;
  final dynamic value;
}
