import 'package:capytify/features/music/data/models/artist.dart';
import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/presentation/screens/song_list_screen.dart';
import 'package:capytify/features/music/presentation/screens/song_player_screen.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/features/music/presentation/state/song_library_viewmodel.dart';
import 'package:capytify/shared/widgets/cached_app_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  Future<void> _playSong(
    BuildContext context, {
    required Song song,
    required List<Song> queue,
  }) async {
    final startIndex = queue.indexWhere((candidate) => candidate.id == song.id);

    await context.read<MiniPlayerProvider>().setQueue(
      songs: queue,
      startIndex: startIndex >= 0 ? startIndex : 0,
    );
    if (!context.mounted) return;
    await openNowPlayingScreen(context);
  }

  Future<void> _openArtist(BuildContext context, Artist artist) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SongListScreen(artist: artist)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final library = context.watch<SongLibraryViewModel>();
    final miniPlayer = context.watch<MiniPlayerProvider>();
    final songs = library.songs;
    final recentSongs = miniPlayer.recentlyPlayed;
    final artists = _buildArtists(songs);

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
          children: [
            _buildHeader(),
            const SizedBox(height: 22),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _LibraryChip(label: 'Danh sach phat'),
                  SizedBox(width: 10),
                  _LibraryChip(label: 'Podcast'),
                  SizedBox(width: 10),
                  _LibraryChip(label: 'Nghe si'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Icon(Icons.swap_vert_rounded, color: Colors.white70, size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Gan day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.grid_view_rounded, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (library.isLoading && songs.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
              )
            else if (songs.isEmpty)
              _buildEmptyState()
            else ...[
              _buildLikedSongsTile(songCount: songs.length),
              const SizedBox(height: 10),
              ...recentSongs.take(5).map(
                (song) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _LibraryListTile(
                    title: song.title,
                    subtitle: 'Bai hat - ${song.artist}',
                    artwork: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedAppImage(
                        imageUrl: song.imageUrl,
                        width: 72,
                        height: 72,
                        placeholder: _squareFallback(),
                      ),
                    ),
                    onTap: () => _playSong(context, song: song, queue: songs),
                  ),
                ),
              ),
              ...artists.take(6).map(
                (artist) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _LibraryListTile(
                    title: artist.name,
                    subtitle: 'Nghe si',
                    artwork: ClipOval(
                      child: CachedAppImage(
                        imageUrl: artist.imageUrl,
                        width: 72,
                        height: 72,
                        placeholder: _circleFallback(),
                      ),
                    ),
                    onTap: () => _openArtist(context, artist),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF335CFF), Color(0xFF78C0FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Text(
              'C',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Thư viện',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_rounded, color: Colors.white, size: 33),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 36),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thu vien dang trong',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Khi ban nghe nhac hoac tai du lieu tu Firestore, danh sach bai hat va nghe si se hien o day.',
            style: TextStyle(color: Colors.white60, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildLikedSongsTile({required int songCount}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [Color(0xFF5127FF), Color(0xFFD7F3E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bai hat da thich',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.push_pin, color: Color(0xFF1ED760), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Danh sach phat - $songCount bai hat',
                      style: const TextStyle(color: Colors.white60, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Artist> _buildArtists(List<Song> songs) {
    final seen = <String>{};
    final artists = <Artist>[];

    for (final song in songs) {
      final normalizedName = song.artist.trim().toLowerCase();
      if (normalizedName.isEmpty || seen.contains(normalizedName)) {
        continue;
      }
      seen.add(normalizedName);
      artists.add(Artist(name: song.artist, imageUrl: song.imageUrl));
    }

    return artists;
  }

  Widget _squareFallback() {
    return Container(
      width: 72,
      height: 72,
      color: const Color(0xFF2D2D2D),
      child: const Icon(Icons.music_note, color: Colors.white70, size: 28),
    );
  }

  Widget _circleFallback() {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFF242424),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white70, size: 30),
    );
  }
}

class _LibraryChip extends StatelessWidget {
  const _LibraryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF232323),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _LibraryListTile extends StatelessWidget {
  const _LibraryListTile({
    required this.title,
    required this.subtitle,
    required this.artwork,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget artwork;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(width: 72, height: 72, child: artwork),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
