import 'package:capytify/features/music/data/models/artist.dart';
import 'package:capytify/features/music/data/models/song.dart';

class HomeRecentCollectionItem {
  const HomeRecentCollectionItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.isCircular = false,
    this.song,
    this.artist,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isCircular;
  final Song? song;
  final Artist? artist;
}
