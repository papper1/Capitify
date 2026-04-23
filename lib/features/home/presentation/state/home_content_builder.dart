import 'dart:math' as math;

import 'package:capytify/features/music/data/models/artist.dart';
import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/home/data/models/home_quick_access_item.dart';
import 'package:capytify/features/home/data/models/home_recent_collection_item.dart';
import 'package:capytify/features/home/data/models/home_shelf_card_data.dart';
import 'package:capytify/features/home/presentation/state/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeContentBuilder {
  const HomeContentBuilder();

  static const List<String> primaryFilters = ['Tat ca', 'Nhac', 'Podcasts'];
  static const List<String> contentFilters = [
    'Nghe si',
    'Dia don',
    'Danh sach phat',
    'Album',
    'Radio',
  ];

  HomeViewModel build({
    required String avatarLabel,
    required List<Artist> artists,
    required List<Song> songs,
    required List<Song> recentSongs,
    required bool isLoading,
    required String? errorMessage,
  }) {
    final quickAccessItems = buildQuickAccessItems(
      recentSongs: recentSongs,
      songs: songs,
      artists: artists,
    );
    final recentlyItems = buildRecentlyItems(
      recentSongs: recentSongs,
      songs: songs,
      artists: artists,
    );
    final radioItems = buildShelfCards(
      sourceSongs: songs,
      titleBuilder: (song, index) => radioTitle(song, index),
      subtitleBuilder: (song, index) => radioSubtitle(song, songs, artists, index),
      paletteBuilder: (_, index) => radioPalette(index + 5),
      maxItems: 8,
    );
    final discoverItems = buildShelfCards(
      sourceSongs: songs.reversed.toList(),
      titleBuilder: (song, index) => discoverTitle(song, index),
      subtitleBuilder: (song, index) => discoverSubtitle(song, songs, artists, index),
      paletteBuilder: (_, index) => radioPalette(index),
      maxItems: 8,
    );
    final basedOnRecentItems = buildShelfCards(
      sourceSongs: recentSongs.isNotEmpty ? recentSongs : songs,
      titleBuilder: (song, index) => mixTitle(song.title, artists, index),
      subtitleBuilder: (song, index) => mixSubtitle(song, songs, artists, index),
      paletteBuilder: (_, index) => playlistPalette(index),
      maxItems: 8,
    );

    return HomeViewModel(
      avatarLabel: avatarLabel,
      primaryFilters: primaryFilters,
      contentFilters: contentFilters,
      quickAccessItems: quickAccessItems,
      recentlyItems: recentlyItems,
      radioItems: radioItems,
      discoverItems: discoverItems,
      basedOnRecentItems: basedOnRecentItems,
      artists: artists,
      songs: songs,
      recentSongs: recentSongs,
      isLoading: isLoading,
      errorMessage: errorMessage,
    );
  }

  List<HomeQuickAccessItem> buildQuickAccessItems({
    required List<Song> recentSongs,
    required List<Song> songs,
    required List<Artist> artists,
  }) {
    final items = <HomeQuickAccessItem>[];

    for (final song in recentSongs.take(4)) {
      items.add(
        HomeQuickAccessItem.song(
          title: song.title,
          imageUrl: song.imageUrl,
          song: song,
        ),
      );
    }

    for (final artist in artists.take(4)) {
      if (items.any((item) => item.title.toLowerCase() == artist.name.toLowerCase())) {
        continue;
      }
      items.add(
        HomeQuickAccessItem.artist(
          title: artist.name,
          imageUrl: artist.imageUrl,
          artist: artist,
        ),
      );
    }

    for (final song in songs.take(8)) {
      if (items.length >= 8) {
        break;
      }
      if (items.any((item) => item.title.toLowerCase() == song.title.toLowerCase())) {
        continue;
      }
      items.add(
        HomeQuickAccessItem.song(
          title: song.title,
          imageUrl: song.imageUrl,
          song: song,
        ),
      );
    }

    return items.take(8).toList();
  }

  List<HomeRecentCollectionItem> buildRecentlyItems({
    required List<Song> recentSongs,
    required List<Song> songs,
    required List<Artist> artists,
  }) {
    final items = <HomeRecentCollectionItem>[];

    for (final artist in artists.take(2)) {
      items.add(
        HomeRecentCollectionItem(
          title: artist.name,
          subtitle: 'Nghe si',
          imageUrl: artist.imageUrl,
          isCircular: true,
          artist: artist,
        ),
      );
    }

    final songSources = recentSongs.isNotEmpty ? recentSongs : songs;
    for (int i = 0; i < math.min(songSources.length, 4); i++) {
      final song = songSources[i];
      items.add(
        HomeRecentCollectionItem(
          title: song.title,
          subtitle: i.isEven ? 'Dia don | Cong dong yeu thich' : 'Danh sach phat',
          imageUrl: song.imageUrl,
          song: song,
        ),
      );
    }

    return items;
  }

  List<HomeShelfCardData> buildShelfCards({
    required List<Song> sourceSongs,
    required String Function(Song song, int index) titleBuilder,
    required String Function(Song song, int index) subtitleBuilder,
    required List<Color> Function(Song song, int index) paletteBuilder,
    required int maxItems,
  }) {
    final items = <HomeShelfCardData>[];

    for (int i = 0; i < sourceSongs.length && items.length < maxItems; i++) {
      final song = sourceSongs[i];
      items.add(
        HomeShelfCardData(
          title: titleBuilder(song, i),
          subtitle: subtitleBuilder(song, i),
          imageUrl: song.imageUrl,
          song: song,
          palette: paletteBuilder(song, i),
        ),
      );
    }

    return items;
  }

  String mixTitle(String baseTitle, List<Artist> artists, int index) {
    if (artists.isEmpty) {
      return baseTitle;
    }

    if (index.isEven) {
      return '${artists[index % artists.length].name} Mix';
    }

    return 'Hot Hits ${baseTitle.split(' ').first}';
  }

  String mixSubtitle(Song song, List<Song> songs, List<Artist> artists, int index) {
    final names = <String>{song.artist};

    if (artists.isNotEmpty) {
      names.add(artists[index % artists.length].name);
    }
    if (songs.length > index + 1) {
      names.add(songs[(index + 1) % songs.length].artist);
    }
    if (songs.length > index + 2) {
      names.add(songs[(index + 2) % songs.length].artist);
    }

    return names.where((name) => name.trim().isNotEmpty).take(4).join(', ');
  }

  String discoverTitle(Song song, int index) {
    if (index.isEven) {
      return '${song.artist} Radio';
    }
    return 'This is ${song.artist}';
  }

  String discoverSubtitle(Song song, List<Song> songs, List<Artist> artists, int index) {
    final names = <String>{song.artist};

    if (songs.isNotEmpty) {
      names.add(songs[(index + 1) % songs.length].artist);
      names.add(songs[(index + 2) % songs.length].artist);
    }
    if (artists.isNotEmpty) {
      names.add(artists[index % artists.length].name);
    }

    return names.where((name) => name.trim().isNotEmpty).take(4).join(', ');
  }

  String radioTitle(Song song, int index) {
    if (index.isEven) {
      return song.artist;
    }
    return '${song.artist.split(' ').first} Radio';
  }

  String radioSubtitle(Song song, List<Song> songs, List<Artist> artists, int index) {
    final names = <String>{song.artist};

    if (songs.isNotEmpty) {
      names.add(songs[(index + 1) % songs.length].artist);
    }
    if (artists.isNotEmpty) {
      names.add(artists[(index + 1) % artists.length].name);
    }
    if (songs.length > 2) {
      names.add(songs[(index + 2) % songs.length].artist);
    }

    return names.where((name) => name.trim().isNotEmpty).take(4).join(', ');
  }

  List<Color> playlistPalette(int index) {
    const palettes = [
      [Color(0xFF7B1FA2), Color(0xFFE1BEE7)],
      [Color(0xFF8E24AA), Color(0xFF90CAF9)],
      [Color(0xFFEF6C00), Color(0xFFFFCC80)],
      [Color(0xFF00897B), Color(0xFF80CBC4)],
      [Color(0xFF3949AB), Color(0xFF9FA8DA)],
    ];
    return palettes[index % palettes.length];
  }

  List<Color> radioPalette(int index) {
    const palettes = [
      [Color(0xFFFFA580), Color(0xFFFCE38A)],
      [Color(0xFF8DEBDA), Color(0xFFA6C1FF)],
      [Color(0xFFDD9BF8), Color(0xFFF9D976)],
      [Color(0xFF9AE6B4), Color(0xFF63B3ED)],
      [Color(0xFFF6AD55), Color(0xFFF687B3)],
    ];
    return palettes[index % palettes.length];
  }
}
