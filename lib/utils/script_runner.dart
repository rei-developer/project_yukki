import 'package:flutter_js/flutter_js.dart';
import 'package:project_yukki/models/script/script_channel_model.dart';
import 'package:project_yukki/managers/alert_manager.dart';

const _runCommand = 'main();';

class ScriptRunner {
  ScriptRunner(this.code);

  final String code;

  Future<void> run() async {
    try {
      final runtime = _javascriptRuntime;
      for (final message in [..._messages]) {
        runtime.onMessage(message.channelName, message.callback);
      }
      runtime.evaluateAsync('$code\n$_runCommand');
    } catch (e) {
      print('script runner error => $e');
    }
  }

  List<ScriptChannelModel> get _messages => [
        // ScriptChannelModel(
        //   'alert',
        //   (dynamic data) => AlertManager.show(
        //     data['description'],
        //     title: data['title'],
        //   ),
        // ),
      ];

  JavascriptRuntime get _javascriptRuntime => getJavascriptRuntime();
}
