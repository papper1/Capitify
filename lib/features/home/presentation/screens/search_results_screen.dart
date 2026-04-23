import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/features/music/presentation/state/song_library_viewmodel.dart';
import 'package:capytify/features/music/presentation/screens/song_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultsScreen extends StatelessWidget {
  const SearchResultsScreen({
    super.key,
    required this.initialQuery,
  });

  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    final library = context.watch<SongLibraryViewModel>();
    final normalizedQuery = initialQuery.trim().toLowerCase();
    final results = library.songs.where((song) {
      final title = song.title.toLowerCase();
      final artist = song.artist.toLowerCase();
      return title.contains(normalizedQuery) || artist.contains(normalizedQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Ket qua cho "$initialQuery"',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (library.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1ED760)),
            );
          }

          if (library.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  library.errorMessage!,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (results.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Khong tim thay bai hat nao cho "$initialQuery".',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.white10),
            itemBuilder: (context, index) {
              final song = results[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _buildSongArtwork(song),
                title: Text(
                  song.title,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  song.artist,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.play_arrow, color: Colors.white),
                onTap: () async {
                  await context.read<MiniPlayerProvider>().setQueue(
                    songs: results,
                    startIndex: index,
                  );
                  if (!context.mounted) return;
                  await openNowPlayingScreen(context);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSongArtwork(Song song) {
    final isNetworkImage = song.imageUrl.startsWith('http');

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: isNetworkImage
          ? Image.network(
              song.imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            )
          : Image.asset(
              song.imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 52,
      height: 52,
      color: Colors.grey[800],
      child: const Icon(Icons.music_note, color: Colors.white),
    );
  }
}
