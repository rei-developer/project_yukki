import 'package:flutter_js/flutter_js.dart';
import 'package:mana_studio/models/script_channel_model.dart';

const _runCommand = 'main();';

class ScriptRunner {
  ScriptRunner(this.code);

  final String code;

  Future<void> run() async {
    try {
      final runtime = _javascriptRuntime;
      for (final message in _messages) {
        runtime.onMessage(message.channelName, message.callback);
      }
      runtime.evaluateAsync('$code\n$_runCommand');
    } catch (e) {
      print('error => $e');
    }
  }

  List<ScriptChannelModel> get _messages => [
        ScriptChannelModel(
          'debug',
          (dynamic text) => print(text['text']),
        ),
      ];

  JavascriptRuntime get _javascriptRuntime => getJavascriptRuntime();
}
