import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  AudioService() {
    _player.setVolume(1.0);
    _player.setReleaseMode(ReleaseMode.release);
  }

  Future<void> playPhaseStart() async {
    if (!_isMuted) {
      await _player.stop();
      await _player.play(AssetSource('audio/phase_start.mp3'));
    }
  }

  Future<void> playPhaseEnd() async {
    if (!_isMuted) {
      await _player.stop();
      await _player.play(AssetSource('audio/phase_end.mp3'));
    }
  }

  Future<void> playCountdown() async {
    if (!_isMuted) {
      await _player.stop();
      await _player.play(AssetSource('audio/countdown.mp3'));
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  bool get isMuted => _isMuted;

  void dispose() {
    _player.dispose();
  }
}
