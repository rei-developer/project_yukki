import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mana_studio/config/storage_config.dart';
import 'package:mana_studio/models/audio_player_model.dart';
import 'package:mana_studio/managers/storage_manager.dart';

class AudioPlayerProvider extends StateNotifier<AudioPlayerModel> {
  AudioPlayerProvider(this.ref) : super(AudioPlayerModel.initial());

  final Ref ref;

  Future<void> setBGM(String path, [bool isPlay = true]) async {
    final file = await StorageManager('').documents;
    final filePath = '$file/$audiosPath/BGM/$path';
    await _bgm.setFilePath(filePath);
    await _bgm.setLoopMode(LoopMode.all);
    if (isPlay) {
      await playBGM();
    }
  }

  Future<void> setBGS(String path, [bool isPlay = true]) async {
    final file = await StorageManager('').documents;
    final filePath = '$file/$audiosPath/BGS/$path';
    await _bgs.setFilePath(filePath);
    await _bgs.setLoopMode(LoopMode.all);
    if (isPlay) {
      await playBGS();
    }
  }

  Future<void> setSE(String path, [double volume = 0.8]) async {
    final file = await StorageManager('').documents;
    final filePath = '$file/$audiosPath/SE/$path';
    final player = _audioPlayer;
    await player.setFilePath(filePath);
    await player.setVolume(volume);
    await player.play();
  }

  Future<void> playBGM() async => await _bgm.play();

  Future<void> playBGS() async => await _bgs.play();

  Future<void> pauseBGM() async => await _bgm.pause();

  Future<void> pauseBGS() async => await _bgs.pause();

  Future<void> stopBGM() async => await _bgm.stop();

  Future<void> stopBGS() async => await _bgs.stop();

  AudioPlayer get _bgm => state.bgm;

  AudioPlayer get _bgs => state.bgs;

  AudioPlayer get _audioPlayer => AudioPlayer();
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerProvider, AudioPlayerModel>(
  (ref) => AudioPlayerProvider(ref),
);
