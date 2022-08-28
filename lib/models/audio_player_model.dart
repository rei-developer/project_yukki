import 'package:just_audio/just_audio.dart';

class AudioPlayerModel {
  AudioPlayerModel(
    this.bgm,
    this.bgs,
  );

  factory AudioPlayerModel.initial({
    AudioPlayer? bgm,
    AudioPlayer? bgs,
  }) =>
      AudioPlayerModel(
        bgm ?? AudioPlayer(),
        bgs ?? AudioPlayer(),
      );

  AudioPlayerModel copyWith({
    AudioPlayer? bgm,
    AudioPlayer? bgs,
  }) =>
      AudioPlayerModel(
        bgm ?? this.bgm,
        bgs ?? this.bgs,
      );

  final AudioPlayer bgm;
  final AudioPlayer bgs;
}
