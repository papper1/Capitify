import 'package:capytify/features/music/data/models/artist.dart';
import 'package:capytify/features/music/data/models/song.dart';

class HomeQuickAccessItem {
  const HomeQuickAccessItem({
    required this.title,
    required this.imageUrl,
    this.song,
    this.artist,
  });

  factory HomeQuickAccessItem.song({
    required String title,
    required String imageUrl,
    required Song song,
  }) {
    return HomeQuickAccessItem(title: title, imageUrl: imageUrl, song: song);
  }

  factory HomeQuickAccessItem.artist({
    required String title,
    required String imageUrl,
    required Artist artist,
  }) {
    return HomeQuickAccessItem(
      title: title,
      imageUrl: imageUrl,
      artist: artist,
    );
  }

  final String title;
  final String imageUrl;
  final Song? song;
  final Artist? artist;
}
