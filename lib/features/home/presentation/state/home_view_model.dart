import 'package:capytify/features/music/data/models/artist.dart';
import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/home/data/models/home_quick_access_item.dart';
import 'package:capytify/features/home/data/models/home_recent_collection_item.dart';
import 'package:capytify/features/home/data/models/home_shelf_card_data.dart';

class HomeViewModel {
  const HomeViewModel({
    required this.avatarLabel,
    required this.primaryFilters,
    required this.contentFilters,
    required this.quickAccessItems,
    required this.recentlyItems,
    required this.radioItems,
    required this.discoverItems,
    required this.basedOnRecentItems,
    required this.artists,
    required this.songs,
    required this.recentSongs,
    required this.isLoading,
    required this.errorMessage,
  });

  final String avatarLabel;
  final List<String> primaryFilters;
  final List<String> contentFilters;
  final List<HomeQuickAccessItem> quickAccessItems;
  final List<HomeRecentCollectionItem> recentlyItems;
  final List<HomeShelfCardData> radioItems;
  final List<HomeShelfCardData> discoverItems;
  final List<HomeShelfCardData> basedOnRecentItems;
  final List<Artist> artists;
  final List<Song> songs;
  final List<Song> recentSongs;
  final bool isLoading;
  final String? errorMessage;
}
