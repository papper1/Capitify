import 'package:capytify/features/music/presentation/state/artist_library_viewmodel.dart';
import 'package:capytify/features/auth/presentation/state/auth_viewmodel.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/features/music/presentation/state/song_library_viewmodel.dart';
import 'package:capytify/features/home/data/models/home_quick_access_item.dart';
import 'package:capytify/features/home/data/models/home_recent_collection_item.dart';
import 'package:capytify/features/home/data/models/home_shelf_card_data.dart';
import 'package:capytify/features/home/presentation/state/home_content_builder.dart';
import 'package:capytify/features/home/presentation/state/home_view_model.dart';
import 'package:capytify/features/home/presentation/widgets/home_content_filters.dart';
import 'package:capytify/features/home/presentation/widgets/home_error_state.dart';
import 'package:capytify/features/home/presentation/widgets/home_primary_filters.dart';
import 'package:capytify/features/home/presentation/widgets/home_quick_access_grid.dart';
import 'package:capytify/features/home/presentation/widgets/home_recent_artists_row.dart';
import 'package:capytify/features/home/presentation/widgets/home_section_title.dart';
import 'package:capytify/features/home/presentation/widgets/home_shelf_row.dart';
import 'package:capytify/features/home/presentation/widgets/home_top_bar.dart';
import 'package:capytify/features/auth/presentation/screens/profile_screen.dart';
import 'package:capytify/features/music/presentation/screens/song_list_screen.dart';
import 'package:capytify/features/music/presentation/screens/song_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final artistLibrary = context.watch<ArtistLibraryViewModel>();
    final songLibrary = context.watch<SongLibraryViewModel>();
    final miniPlayer = context.watch<MiniPlayerProvider>();

    final user = authViewModel.currentUser;
    final contentBuilder = const HomeContentBuilder();
    final HomeViewModel viewModel = contentBuilder.build(
      avatarLabel: _displayNameForUser(user?.displayName, user?.email),
      artists: artistLibrary.artists,
      songs: songLibrary.songs,
      recentSongs: miniPlayer.recentlyPlayed,
      isLoading:
          artistLibrary.isLoading &&
          artistLibrary.artists.isEmpty &&
          songLibrary.isLoading &&
          songLibrary.songs.isEmpty,
      errorMessage: songLibrary.errorMessage ?? artistLibrary.errorMessage,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF111111), Color(0xFF050505)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Builder(
            builder: (context) {
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                );
              }

              if (viewModel.errorMessage != null &&
                  viewModel.artists.isEmpty &&
                  viewModel.songs.isEmpty) {
                return HomeErrorState(
                  message: viewModel.errorMessage!,
                  onRetry: () {
                    context.read<ArtistLibraryViewModel>().loadArtists();
                    context.read<SongLibraryViewModel>().loadSongs();
                  },
                );
              }

              return RefreshIndicator(
                color: const Color(0xFF1ED760),
                backgroundColor: const Color(0xFF171717),
                onRefresh: () async {
                  final artistLibrary = context.read<ArtistLibraryViewModel>();
                  final songLibrary = context.read<SongLibraryViewModel>();

                  await artistLibrary.loadArtists(showLoading: false);
                  await songLibrary.loadSongs(showLoading: false);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                  children: [
                    HomeTopBar(
                      photoUrl: user?.photoURL,
                      label: viewModel.avatarLabel,
                      onAvatarTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        );
                      },
                      onSettingsTap:
                          () => Navigator.pushNamed(context, '/settings'),
                    ),
                    const SizedBox(height: 14),
                    HomePrimaryFilters(filters: viewModel.primaryFilters),
                    const SizedBox(height: 14),
                    HomeContentFilters(filters: viewModel.contentFilters),
                    const SizedBox(height: 18),
                    if (viewModel.quickAccessItems.isNotEmpty) ...[
                      HomeQuickAccessGrid(
                        items: viewModel.quickAccessItems,
                        onTap: (item) => _handleQuickAccessTap(context, item),
                      ),
                      const SizedBox(height: 28),
                    ],
                    if (viewModel.radioItems.isNotEmpty) ...[
                      const HomeSectionTitle(title: 'Radio pho bien'),
                      const SizedBox(height: 14),
                      HomeShelfRow(
                        items: viewModel.radioItems,
                        onTap: (item) => _playShelfItem(context, item),
                      ),
                      const SizedBox(height: 30),
                    ],
                    if (viewModel.discoverItems.isNotEmpty) ...[
                      const HomeSectionTitle(title: 'Dai phat de xuat'),
                      const SizedBox(height: 14),
                      HomeShelfRow(
                        items: viewModel.discoverItems,
                        onTap: (item) => _playShelfItem(context, item),
                      ),
                      const SizedBox(height: 30),
                    ],
                    if (viewModel.recentlyItems.isNotEmpty) ...[
                      const HomeSectionTitle(
                        title: 'Gan day',
                        trailing: 'Hien tat ca',
                      ),
                      const SizedBox(height: 14),
                      HomeRecentArtistsRow(
                        items: viewModel.recentlyItems,
                        onTap: (item) => _handleRecentItemTap(context, item),
                      ),
                      const SizedBox(height: 30),
                    ],
                    if (viewModel.basedOnRecentItems.isNotEmpty) ...[
                      const HomeSectionTitle(
                        title: 'Dua tren nhac ban nghe gan day',
                      ),
                      const SizedBox(height: 14),
                      HomeShelfRow(
                        items: viewModel.basedOnRecentItems,
                        onTap: (item) => _playShelfItem(context, item),
                      ),
                      const SizedBox(height: 30),
                    ],
                    if (viewModel.discoverItems.isNotEmpty) ...[
                      const HomeSectionTitle(title: 'Them nhac ban thich'),
                      const SizedBox(height: 14),
                      HomeShelfRow(
                        items: viewModel.discoverItems.reversed.toList(),
                        onTap: (item) => _playShelfItem(context, item),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleQuickAccessTap(
    BuildContext context,
    HomeQuickAccessItem item,
  ) async {
    if (item.song != null) {
      await context.read<MiniPlayerProvider>().setQueue(
        songs: [item.song!],
        startIndex: 0,
      );
      if (!context.mounted) return;
      await openNowPlayingScreen(context);
      return;
    }

    if (item.artist != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SongListScreen(artist: item.artist!)),
      );
    }
  }

  Future<void> _handleRecentItemTap(
    BuildContext context,
    HomeRecentCollectionItem item,
  ) async {
    if (item.artist != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SongListScreen(artist: item.artist!)),
      );
      return;
    }

    if (item.song != null) {
      await context.read<MiniPlayerProvider>().setQueue(
        songs: [item.song!],
        startIndex: 0,
      );
      if (!context.mounted) return;
      await openNowPlayingScreen(context);
    }
  }

  Future<void> _playShelfItem(
    BuildContext context,
    HomeShelfCardData item,
  ) async {
    await context.read<MiniPlayerProvider>().setQueue(
      songs: [item.song],
      startIndex: 0,
    );
    if (!context.mounted) return;
    await openNowPlayingScreen(context);
  }

  String _displayNameForUser(String? displayName, String? email) {
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }
    if (email != null && email.trim().isNotEmpty) {
      return email.split('@').first;
    }
    return 'Nguoi dung';
  }
}
