import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:capytify/features/music/data/models/artist.dart';
import 'package:capytify/features/music/data/models/song.dart';

class LocalCacheService {
  LocalCacheService(this._preferences);

  static const String _songsKey = 'cached_songs';
  static const String _artistsKey = 'cached_artists';
  static const String _recentlyPlayedKey = 'cached_recently_played';
  static const String _playerStateKey = 'cached_player_state';

  final SharedPreferences _preferences;

  Future<void> saveSongs(List<Song> songs) async {
    final payload = songs.map((song) => song.toMap()).toList();
    await _preferences.setString(_songsKey, jsonEncode(payload));
  }

  List<Song> loadSongs() {
    final raw = _preferences.getString(_songsKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map>()
        .map((item) => Song.fromMap(Map<String, dynamic>.from(item)))
        .where((song) => song.id.isNotEmpty)
        .toList();
  }

  Future<void> saveArtists(List<Artist> artists) async {
    final payload = artists.map((artist) => artist.toMap()).toList();
    await _preferences.setString(_artistsKey, jsonEncode(payload));
  }

  List<Artist> loadArtists() {
    final raw = _preferences.getString(_artistsKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map>()
        .map((item) => Artist.fromMap(Map<String, dynamic>.from(item)))
        .where((artist) => artist.name.isNotEmpty)
        .toList();
  }

  Future<void> saveRecentlyPlayed(List<Song> songs) async {
    final payload = songs.map((song) => song.toMap()).toList();
    await _preferences.setString(_recentlyPlayedKey, jsonEncode(payload));
  }

  List<Song> loadRecentlyPlayed() {
    final raw = _preferences.getString(_recentlyPlayedKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map>()
        .map((item) => Song.fromMap(Map<String, dynamic>.from(item)))
        .where((song) => song.id.isNotEmpty)
        .toList();
  }

  Future<void> savePlayerState(Map<String, dynamic> state) async {
    await _preferences.setString(_playerStateKey, jsonEncode(state));
  }

  Map<String, dynamic>? loadPlayerState() {
    final raw = _preferences.getString(_playerStateKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } catch (_) {
      return null;
    }

    if (decoded is! Map) {
      return null;
    }

    return Map<String, dynamic>.from(decoded);
  }
}
