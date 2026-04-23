import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/data/services/local_cache_service.dart';

enum RepeatModeState { off, all, one }

class MiniPlayerProvider extends ChangeNotifier {
  MiniPlayerProvider({required LocalCacheService localCacheService})
    : _localCacheService = localCacheService {
    _recentlyPlayed = _localCacheService.loadRecentlyPlayed();

    _audioPlayer.playerStateStream.listen((state) {
      if (_isPlaying != state.playing) {
        _isPlaying = state.playing;
        notifyListeners();
      }
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null && _duration != duration) {
        _duration = duration;
        notifyListeners();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final previousSecond = _position.inSeconds;
      final nextSecond = position.inSeconds;

      if (previousSecond != nextSecond || position == Duration.zero) {
        _position = position;
        notifyListeners();
      } else {
        _position = position;
      }
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _handleTrackCompleted();
      }
    });
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();
  final LocalCacheService _localCacheService;

  List<Song> _queue = const [];
  List<Song> _recentlyPlayed = const [];
  List<int> _playOrder = const [];
  int _playOrderPosition = -1;
  int _currentIndex = -1;
  Song? _currentSong;
  bool _isPlaying = false;
  bool _isShuffleEnabled = false;
  RepeatModeState _repeatMode = RepeatModeState.off;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _errorMessage;

  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  bool get isShuffleEnabled => _isShuffleEnabled;
  RepeatModeState get repeatMode => _repeatMode;
  Duration get duration => _duration;
  Duration get position => _position;
  List<Song> get queue => _queue;
  List<Song> get recentlyPlayed => _recentlyPlayed;
  int get currentIndex => _currentIndex;
  String? get errorMessage => _errorMessage;

  bool get hasPrevious {
    if (_queue.isEmpty) {
      return false;
    }
    if (_position.inSeconds > 3) {
      return true;
    }
    if (_repeatMode == RepeatModeState.all && _queue.length > 1) {
      return true;
    }
    return _playOrderPosition > 0;
  }

  bool get hasNext {
    if (_queue.isEmpty) {
      return false;
    }
    if (_repeatMode == RepeatModeState.one) {
      return true;
    }
    if (_repeatMode == RepeatModeState.all && _queue.length > 1) {
      return true;
    }
    return _playOrderPosition >= 0 &&
        _playOrderPosition < _playOrder.length - 1;
  }

  Future<void> setSong(Song song) async {
    await setQueue(songs: [song], startIndex: 0);
  }

  Future<void> setQueue({required List<Song> songs, int startIndex = 0}) async {
    if (songs.isEmpty) {
      return;
    }

    _queue = List<Song>.from(songs);
    _currentIndex = startIndex.clamp(0, _queue.length - 1);
    _rebuildPlayOrder(keepCurrentSongFirst: true);
    await _playCurrent();
  }

  Future<void> playSongAt(int index) async {
    if (_queue.isEmpty || index < 0 || index >= _queue.length) {
      return;
    }

    _currentIndex = index;
    _syncPlayOrderPositionWithCurrentIndex();
    await _playCurrent();
  }

  Future<void> toggleShuffle() async {
    if (_queue.isEmpty) {
      _isShuffleEnabled = !_isShuffleEnabled;
      notifyListeners();
      return;
    }

    _isShuffleEnabled = !_isShuffleEnabled;
    _rebuildPlayOrder(keepCurrentSongFirst: true);
    notifyListeners();
  }

  void cycleRepeatMode() {
    switch (_repeatMode) {
      case RepeatModeState.off:
        _repeatMode = RepeatModeState.all;
        break;
      case RepeatModeState.all:
        _repeatMode = RepeatModeState.one;
        break;
      case RepeatModeState.one:
        _repeatMode = RepeatModeState.off;
        break;
    }
    notifyListeners();
  }

  Future<void> _playCurrent() async {
    if (_queue.isEmpty || _currentIndex < 0 || _currentIndex >= _queue.length) {
      return;
    }

    final song = _queue[_currentIndex];
    _currentSong = song;
    _position = Duration.zero;
    _duration = Duration.zero;
    _errorMessage = null;
    _rememberRecentlyPlayed(song);

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(song.audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      _errorMessage = 'Khong the phat bai hat nay.';
      debugPrint('Loi phat nhac: $e');
    }

    notifyListeners();
  }

  void _rememberRecentlyPlayed(Song song) {
    final updated =
        _recentlyPlayed.where((item) => item.id != song.id).toList();
    updated.insert(0, song);
    final nextRecentlyPlayed = updated.take(20).toList();
    if (_recentlyPlayed.length != nextRecentlyPlayed.length ||
        !_recentlyPlayed.asMap().entries.every(
          (entry) => nextRecentlyPlayed[entry.key].id == entry.value.id,
        )) {
      _recentlyPlayed = nextRecentlyPlayed;
      _localCacheService.saveRecentlyPlayed(_recentlyPlayed);
    }
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

  Future<void> nextSong() async {
    if (_queue.isEmpty) {
      return;
    }

    if (_repeatMode == RepeatModeState.one) {
      await seek(Duration.zero);
      await _audioPlayer.play();
      return;
    }

    if (_playOrderPosition < _playOrder.length - 1) {
      _playOrderPosition += 1;
      _currentIndex = _playOrder[_playOrderPosition];
      await _playCurrent();
      return;
    }

    if (_repeatMode == RepeatModeState.all && _playOrder.isNotEmpty) {
      _playOrderPosition = 0;
      _currentIndex = _playOrder[_playOrderPosition];
      await _playCurrent();
      return;
    }

    await _audioPlayer.pause();
    await seek(Duration.zero);
    notifyListeners();
  }

  Future<void> previousSong() async {
    if (_queue.isEmpty) {
      return;
    }

    if (_position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    if (_repeatMode == RepeatModeState.one) {
      await seek(Duration.zero);
      await _audioPlayer.play();
      return;
    }

    if (_playOrderPosition > 0) {
      _playOrderPosition -= 1;
      _currentIndex = _playOrder[_playOrderPosition];
      await _playCurrent();
      return;
    }

    if (_repeatMode == RepeatModeState.all && _playOrder.isNotEmpty) {
      _playOrderPosition = _playOrder.length - 1;
      _currentIndex = _playOrder[_playOrderPosition];
      await _playCurrent();
      return;
    }

    await seek(Duration.zero);
  }

  Future<void> _handleTrackCompleted() async {
    await nextSong();
  }

  void _rebuildPlayOrder({required bool keepCurrentSongFirst}) {
    if (_queue.isEmpty) {
      _playOrder = const [];
      _playOrderPosition = -1;
      return;
    }

    final indices = List<int>.generate(_queue.length, (index) => index);

    if (_isShuffleEnabled) {
      indices.remove(_currentIndex);
      indices.shuffle(_random);
      if (keepCurrentSongFirst && _currentIndex >= 0) {
        indices.insert(0, _currentIndex);
      } else if (_currentIndex >= 0) {
        indices.add(_currentIndex);
      }
    }

    _playOrder = indices;
    _syncPlayOrderPositionWithCurrentIndex();
  }

  void _syncPlayOrderPositionWithCurrentIndex() {
    _playOrderPosition = _playOrder.indexOf(_currentIndex);
    if (_playOrderPosition < 0 && _currentIndex >= 0) {
      _playOrder = List<int>.generate(_queue.length, (index) => index);
      _playOrderPosition = _playOrder.indexOf(_currentIndex);
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
