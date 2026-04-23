import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:capytify/features/music/data/models/artist.dart';
import 'package:capytify/features/music/data/models/song.dart';

class MusicLibraryService {
  MusicLibraryService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<Song>> fetchSongs() async {
    final snapshot = await _firestore.collection('songs').get();

    final songs = snapshot.docs
        .map((doc) => _songFromMap(doc.id, doc.data()))
        .where((song) => song.audioUrl.isNotEmpty)
        .toList();

    songs.sort((a, b) => a.title.compareTo(b.title));
    return songs;
  }

  Future<List<Song>> fetchSongsByArtist(String artistName) async {
    final snapshot = await _firestore
        .collection('songs')
        .where('artist', isEqualTo: artistName)
        .get();

    final songs = snapshot.docs
        .map((doc) => _songFromMap(doc.id, doc.data()))
        .where((song) => song.audioUrl.isNotEmpty)
        .toList();

    songs.sort((a, b) => a.title.compareTo(b.title));
    return songs;
  }

  Future<List<Artist>> fetchArtists() async {
    final snapshot = await _firestore.collection('artists').get();

    final artists = snapshot.docs
        .map((doc) {
          final data = doc.data();
          return Artist(
            name: (data['name'] ?? '').toString(),
            imageUrl: (data['imageUrl'] ?? '').toString(),
          );
        })
        .where((artist) => artist.name.isNotEmpty)
        .toList();

    artists.sort((a, b) => a.name.compareTo(b.name));
    return artists;
  }

  Song _songFromMap(String id, Map<String, dynamic> data) {
    return Song(
      id: id,
      title: (data['title'] ?? '').toString(),
      artist: (data['artist'] ?? '').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      audioUrl: (data['audioUrl'] ?? '').toString(),
    );
  }
}
