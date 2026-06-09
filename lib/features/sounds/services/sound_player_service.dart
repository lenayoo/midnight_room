import 'package:audioplayers/audioplayers.dart';

class SoundPlayerService {
  SoundPlayerService();

  AudioPlayer? _player;

  Stream<PlayerState> get onPlayerStateChanged =>
      _getOrCreatePlayer().onPlayerStateChanged;

  Future<void> playAsset(String assetPath, {required double volume}) async {
    final AudioPlayer player = _getOrCreatePlayer();
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(volume);
    await player.play(AssetSource(_assetSourcePath(assetPath)));
  }

  Future<void> pause() async {
    await _player?.pause();
  }

  Future<void> resume() async {
    await _player?.resume();
  }

  Future<void> setVolume(double volume) async {
    await _player?.setVolume(volume);
  }

  Future<void> dispose() async {
    await _player?.dispose();
  }

  AudioPlayer _getOrCreatePlayer() {
    return _player ??= AudioPlayer();
  }

  String _assetSourcePath(String assetPath) {
    const String prefix = 'assets/';
    if (assetPath.startsWith(prefix)) {
      return assetPath.substring(prefix.length);
    }
    return assetPath;
  }
}
