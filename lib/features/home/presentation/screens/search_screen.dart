import 'package:capytify/features/home/presentation/screens/search_results_screen.dart';
import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/presentation/screens/song_player_screen.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/features/music/presentation/state/song_library_viewmodel.dart';
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

  Future<void> _playSong(
    BuildContext context, {
    required Song song,
    required List<Song> librarySongs,
    required List<Song> fallbackSongs,
  }) async {
    final queue = librarySongs.isNotEmpty ? librarySongs : fallbackSongs;
    final queueIndex = queue.indexWhere((candidate) => candidate.id == song.id);

    await context.read<MiniPlayerProvider>().setQueue(
      songs: queue,
      startIndex: queueIndex >= 0 ? queueIndex : 0,
    );
    if (!context.mounted) return;
    await openNowPlayingScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    final library = context.watch<SongLibraryViewModel>();
    final recentSongs = context.watch<MiniPlayerProvider>().recentlyPlayed;
    final suggestions = _buildSuggestions(library.songs, _query);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 84,
        titleSpacing: 16,
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            onSubmitted: _submitSearch,
            textInputAction: TextInputAction.search,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Artists, songs, or podcasts',
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white, size: 30),
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
              fillColor: const Color(0xFF3F3F3F),
              contentPadding: const EdgeInsets.symmetric(vertical: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 22),
          if (_query.isNotEmpty)
            _buildSuggestionSection(context, suggestions, library)
          else
            _buildDiscoverySection(context, library, recentSongs),
        ],
      ),
    );
  }

  Widget _buildDiscoverySection(
    BuildContext context,
    SongLibraryViewModel library,
    List<Song> recentSongs,
  ) {
    if (library.isLoading && library.songs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 48),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF1ED760)),
        ),
      );
    }

    final quickPicks =
        recentSongs.isNotEmpty ? recentSongs.take(8).toList() : library.songs.take(8).toList();

    if (quickPicks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bat dau tim kiem',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nhap ten bai hat hoac nghe si. Khi ban phat nhac, muc gan day se hien o day.',
              style: TextStyle(color: Colors.white60, height: 1.45),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recentSongs.isNotEmpty ? 'Gan day' : 'Co the ban muon nghe',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          recentSongs.isNotEmpty
              ? 'Mo nhanh tu lich su nghe cua ban'
              : 'Mot vai bai hat co san trong thu vien',
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(height: 14),
        ...quickPicks.map(
          (song) => _buildQuickPickTile(
            context,
            song: song,
            librarySongs: library.songs,
            fallbackSongs: quickPicks,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionSection(
    BuildContext context,
    List<Song> suggestions,
    SongLibraryViewModel library,
  ) {
    if (library.isLoading && library.songs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 24),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF1ED760)),
        ),
      );
    }

    if (library.errorMessage != null && library.songs.isEmpty) {
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
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Khong tim thay goi y phu hop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ban van co the mo trang ket qua day du de thu tim kiem rong hon.',
              style: TextStyle(color: Colors.white60, height: 1.45),
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () => _submitSearch(_query),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Xem ket qua'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ket qua nhanh',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        ...suggestions.map(
          (song) => _buildQuickPickTile(
            context,
            song: song,
            librarySongs: library.songs,
            fallbackSongs: suggestions,
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => _submitSearch(_query),
          child: Text('Xem tat ca ket qua cho "$_query"'),
        ),
      ],
    );
  }

  Widget _buildQuickPickTile(
    BuildContext context, {
    required Song song,
    required List<Song> librarySongs,
    required List<Song> fallbackSongs,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap:
            () => _playSong(
              context,
              song: song,
              librarySongs: librarySongs,
              fallbackSongs: fallbackSongs,
            ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedAppImage(
                  imageUrl: song.imageUrl,
                  width: 58,
                  height: 58,
                  placeholder: _buildArtworkPlaceholder(),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.play_arrow_rounded, color: Colors.white70, size: 28),
            ],
          ),
        ),
      ),
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

  Widget _buildArtworkPlaceholder() {
    return Container(
      width: 58,
      height: 58,
      color: const Color(0xFF2A2A2A),
      child: const Icon(Icons.music_note, color: Colors.white70),
    );
  }
}
