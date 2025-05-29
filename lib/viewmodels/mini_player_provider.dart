import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class MiniPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  bool _isPlaying = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;

  MiniPlayerProvider() {
    _audioPlayer.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    // Lắng nghe duration
    _audioPlayer.durationStream.listen((d) {
      if (d != null) {
        _duration = d;
        notifyListeners();
      }
    });

    // Lắng nghe position
    _audioPlayer.positionStream.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  Future<void> setSong(Song song) async {
    _currentSong = song;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Lỗi phát nhạc: $e');
    }
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
