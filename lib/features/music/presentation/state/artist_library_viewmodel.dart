import 'package:flutter/material.dart';

import 'package:capytify/features/music/data/models/artist.dart';
import 'package:capytify/features/music/data/services/local_cache_service.dart';
import 'package:capytify/features/music/data/services/music_library_service.dart';

class ArtistLibraryViewModel extends ChangeNotifier {
  ArtistLibraryViewModel({
    MusicLibraryService? musicLibraryService,
    required LocalCacheService localCacheService,
  })  : _musicLibraryService = musicLibraryService ?? MusicLibraryService(),
        _localCacheService = localCacheService {
    _artists = _localCacheService.loadArtists();
    _isLoading = _artists.isEmpty;
    loadArtists(showLoading: _artists.isEmpty);
  }

  final MusicLibraryService _musicLibraryService;
  final LocalCacheService _localCacheService;

  List<Artist> _artists = const [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Artist> get artists => _artists;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadArtists({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
    }
    _errorMessage = null;
    notifyListeners();

    try {
      _artists = await _musicLibraryService.fetchArtists();
      await _localCacheService.saveArtists(_artists);
    } catch (e) {
      if (_artists.isEmpty) {
        _artists = const [];
        _errorMessage = 'Khong the tai danh sach artist tu Firestore.';
      }
      debugPrint('Loi tai artist tu Firestore: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
