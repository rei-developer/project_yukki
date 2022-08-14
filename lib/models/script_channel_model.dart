class ScriptChannelModel {
  ScriptChannelModel(this.channelName, this.callback);

  final String channelName;
  final Function(dynamic) callback;
}
