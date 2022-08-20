class WaitCommandHandler {
  WaitCommandHandler(this.data);

  final dynamic data;

  Future<void> get wait async =>
      await Future.delayed(Duration(milliseconds: _data.duration));

  _WaitCommandModel get _data => _WaitCommandModel.fromJson(data);
}

class _WaitCommandModel {
  _WaitCommandModel(this.duration);

  _WaitCommandModel.fromJson(json) : duration = (json['duration'] ?? 0) as int;

  final int duration;
}
