import 'package:flutter/material.dart';

import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/data/services/local_cache_service.dart';
import 'package:capytify/features/music/data/services/music_library_service.dart';

class SongLibraryViewModel extends ChangeNotifier {
  SongLibraryViewModel({
    MusicLibraryService? musicLibraryService,
    required LocalCacheService localCacheService,
  })  : _musicLibraryService = musicLibraryService ?? MusicLibraryService(),
        _localCacheService = localCacheService {
    _songs = _localCacheService.loadSongs();
    _isLoading = _songs.isEmpty;
    loadSongs(showLoading: _songs.isEmpty);
  }

  final MusicLibraryService _musicLibraryService;
  final LocalCacheService _localCacheService;

  List<Song> _songs = const [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadSongs({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      _songs = await _musicLibraryService.fetchSongs();
      await _localCacheService.saveSongs(_songs);
    } catch (e) {
      if (_songs.isEmpty) {
        _songs = const [];
        _errorMessage = 'Khong the tai danh sach nhac tu Firestore.';
      }
      debugPrint('Loi tai nhac tu Firestore: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
