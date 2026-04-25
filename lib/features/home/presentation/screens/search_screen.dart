import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/features/music/presentation/state/song_library_viewmodel.dart';
import 'package:capytify/features/home/presentation/screens/search_results_screen.dart';
import 'package:capytify/features/music/presentation/screens/song_player_screen.dart';
import 'package:capytify/shared/widgets/cached_app_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(String rawQuery) {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(initialQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final library = context.watch<SongLibraryViewModel>();
    final suggestions = _buildSuggestions(library.songs, _query);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Search', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              onSubmitted: _submitSearch,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Artists, songs, or podcasts',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                suffixIcon:
                    _query.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                        : null,
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            if (_query.isNotEmpty)
              _buildSuggestionSection(context, suggestions, library)
            else ...[
              const Text(
                'Browse all',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildWrappedGenreCard(context, 'Pop', Colors.purple),
                  _buildWrappedGenreCard(context, 'Indie', Colors.green),
                  _buildWrappedGenreCard(context, 'Podcasts', Colors.blue),
                  _buildWrappedGenreCard(context, 'Made for you', Colors.pink),
                  _buildWrappedGenreCard(context, 'Charts', Colors.deepOrange),
                  _buildWrappedGenreCard(context, 'Focus', Colors.teal),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionSection(
    BuildContext context,
    List<Song> suggestions,
    SongLibraryViewModel library,
  ) {
    if (library.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 24),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF1ED760)),
        ),
      );
    }

    if (library.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Text(
          library.errorMessage!,
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (suggestions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Khong co goi y phu hop',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => _submitSearch(_query),
            child: const Text('Tim kiem'),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bai hat goi y',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(suggestions.length, (index) {
          final song = suggestions[index];
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
            trailing: const Icon(Icons.north_west, color: Colors.white54),
            onTap: () async {
              final librarySongs = library.songs;
              final queue = librarySongs.isNotEmpty ? librarySongs : suggestions;
              final queueIndex = queue.indexWhere(
                (candidate) => candidate.id == song.id,
              );

              await context.read<MiniPlayerProvider>().setQueue(
                songs: queue,
                startIndex: queueIndex >= 0 ? queueIndex : index,
              );
              if (!context.mounted) return;
              await openNowPlayingScreen(context);
            },
          );
        }),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => _submitSearch(_query),
          child: Text('Xem tat ca ket qua cho "$_query"'),
        ),
      ],
    );
  }

  List<Song> _buildSuggestions(List<Song> songs, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final results =
        songs.where((song) {
          final title = song.title.toLowerCase();
          final artist = song.artist.toLowerCase();
          return title.contains(normalizedQuery) ||
              artist.contains(normalizedQuery);
        }).toList();

    return results.take(6).toList();
  }

  Widget _buildSongArtwork(Song song) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedAppImage(
        imageUrl: song.imageUrl,
        width: 52,
        height: 52,
        placeholder: _buildArtworkPlaceholder(),
      ),
    );
  }

  Widget _buildArtworkPlaceholder() {
    return Container(
      width: 52,
      height: 52,
      color: Colors.grey[800],
      child: const Icon(Icons.music_note, color: Colors.white),
    );
  }

  Widget _buildWrappedGenreCard(
    BuildContext context,
    String title,
    Color color,
  ) {
    final cardWidth = (MediaQuery.of(context).size.width - 44) / 2;
    return SizedBox(
      width: cardWidth,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
