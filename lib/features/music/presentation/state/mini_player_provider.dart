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
    _restorePlayerState();

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
      if (!_isAudioSourceLoaded && _currentSong != null) {
        return;
      }

      final previousSecond = _position.inSeconds;
      final nextSecond = position.inSeconds;

      if (previousSecond != nextSecond || position == Duration.zero) {
        _position = position;
        _savePlayerState();
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
  bool _isAudioSourceLoaded = false;
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
    _currentIndex = startIndex.clamp(0, _queue.length - 1).toInt();
    _rebuildPlayOrder(keepCurrentSongFirst: true);
    await _playCurrent(startPosition: Duration.zero);
  }

  Future<void> playSongAt(int index) async {
    if (_queue.isEmpty || index < 0 || index >= _queue.length) {
      return;
    }

    _currentIndex = index;
    _syncPlayOrderPositionWithCurrentIndex();
    await _playCurrent(startPosition: Duration.zero);
  }

  Future<void> toggleShuffle() async {
    if (_queue.isEmpty) {
      _isShuffleEnabled = !_isShuffleEnabled;
      _savePlayerState();
      notifyListeners();
      return;
    }

    _isShuffleEnabled = !_isShuffleEnabled;
    _rebuildPlayOrder(keepCurrentSongFirst: true);
    _savePlayerState();
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
    _savePlayerState();
    notifyListeners();
  }

  Future<void> _playCurrent({required Duration startPosition}) async {
    if (_queue.isEmpty || _currentIndex < 0 || _currentIndex >= _queue.length) {
      return;
    }

    final song = _queue[_currentIndex];
    _currentSong = song;
    _position = startPosition;
    _duration = Duration.zero;
    _errorMessage = null;
    _isAudioSourceLoaded = false;
    _rememberRecentlyPlayed(song);

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(song.audioUrl);
      _isAudioSourceLoaded = true;
      if (startPosition > Duration.zero) {
        await _audioPlayer.seek(startPosition);
      }
      await _audioPlayer.play();
    } catch (e) {
      _isAudioSourceLoaded = false;
      _errorMessage = 'Khong the phat bai hat nay.';
      debugPrint('Loi phat nhac: $e');
    }

    _savePlayerState();
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
      _savePlayerState();
      return;
    }

    if (!_isAudioSourceLoaded && _currentSong != null) {
      await _playCurrent(startPosition: _position);
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> seek(Duration position) async {
    _position = position;
    if (_isAudioSourceLoaded) {
      await _audioPlayer.seek(position);
    }
    _savePlayerState();
    notifyListeners();
  }

  Future<void> nextSong() async {
    if (_queue.isEmpty) {
      return;
    }

    if (_repeatMode == RepeatModeState.one) {
      if (_isAudioSourceLoaded) {
        await seek(Duration.zero);
        await _audioPlayer.play();
      } else {
        await _playCurrent(startPosition: Duration.zero);
      }
      return;
    }

    if (_playOrderPosition < _playOrder.length - 1) {
      _playOrderPosition += 1;
      _currentIndex = _playOrder[_playOrderPosition];
      await _playCurrent(startPosition: Duration.zero);
      return;
    }

    if (_repeatMode == RepeatModeState.all && _playOrder.isNotEmpty) {
      _playOrderPosition = 0;
      _currentIndex = _playOrder[_playOrderPosition];
      await _playCurrent(startPosition: Duration.zero);
      return;
    }

    await _audioPlayer.pause();
    await seek(Duration.zero);
    _savePlayerState();
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
      if (_isAudioSourceLoaded) {
        await seek(Duration.zero);
        await _audioPlayer.play();
      } else {
        await _playCurrent(startPosition: Duration.zero);
      }
      return;
    }

    if (_playOrderPosition > 0) {
      _playOrderPosition -= 1;
      _currentIndex = _playOrder[_playOrderPosition];
      await _playCurrent(startPosition: Duration.zero);
      return;
    }

    if (_repeatMode == RepeatModeState.all && _playOrder.isNotEmpty) {
      _playOrderPosition = _playOrder.length - 1;
      _currentIndex = _playOrder[_playOrderPosition];
      await _playCurrent(startPosition: Duration.zero);
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

  void _restorePlayerState() {
    final state = _localCacheService.loadPlayerState();
    if (state == null) {
      return;
    }

    final queuePayload = state['queue'];
    if (queuePayload is List) {
      _queue =
          queuePayload
              .whereType<Map>()
              .map((item) => Song.fromMap(Map<String, dynamic>.from(item)))
              .where((song) => song.id.isNotEmpty)
              .toList();
    }

    final songPayload = state['currentSong'];
    if (songPayload is Map) {
      _currentSong = Song.fromMap(Map<String, dynamic>.from(songPayload));
    }

    if (_queue.isEmpty && _currentSong != null) {
      _queue = [_currentSong!];
    }

    if (_queue.isEmpty) {
      return;
    }

    final savedIndex = state['currentIndex'];
    _currentIndex =
        savedIndex is int ? savedIndex.clamp(0, _queue.length - 1).toInt() : 0;
    _currentSong = _queue[_currentIndex];

    final positionMs = state['positionMs'];
    if (positionMs is int && positionMs > 0) {
      _position = Duration(milliseconds: positionMs);
    }

    final shuffle = state['isShuffleEnabled'];
    if (shuffle is bool) {
      _isShuffleEnabled = shuffle;
    }

    final repeat = state['repeatMode'];
    if (repeat is String) {
      _repeatMode = RepeatModeState.values.firstWhere(
        (mode) => mode.name == repeat,
        orElse: () => RepeatModeState.off,
      );
    }

    _rebuildPlayOrder(keepCurrentSongFirst: true);
  }

  void _savePlayerState() {
    final currentSong = _currentSong;
    if (currentSong == null) {
      return;
    }

    _localCacheService.savePlayerState({
      'currentSong': currentSong.toMap(),
      'queue': _queue.map((song) => song.toMap()).toList(),
      'currentIndex': _currentIndex,
      'positionMs': _position.inMilliseconds,
      'isShuffleEnabled': _isShuffleEnabled,
      'repeatMode': _repeatMode.name,
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
