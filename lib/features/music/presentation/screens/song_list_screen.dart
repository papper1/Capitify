import 'package:capytify/features/music/data/models/artist.dart';
import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/features/music/presentation/state/song_library_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'song_player_screen.dart';

class SongListScreen extends StatelessWidget {
  const SongListScreen({super.key, required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    final songs =
        context
            .watch<SongLibraryViewModel>()
            .songs
            .where((song) => song.artist == artist.name)
            .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body:
          songs.isEmpty
              ? _buildEmptyState(context)
              : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _ArtistHeader(
                      artist: artist,
                      monthlyListeners: _monthlyListenersText(artist.name),
                      onBack: () => Navigator.of(context).pop(),
                      onPlay: () => _playSongs(context, songs, 0),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMusicTab(),
                          const SizedBox(height: 20),
                          _buildLikedSongTile(songs),
                          const SizedBox(height: 28),
                          _buildSectionTitle('Pho bien'),
                          const SizedBox(height: 12),
                          ..._buildPopularSongs(context, songs),
                          if (songs.length > 5) ...[
                            const SizedBox(height: 12),
                            Center(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white24),
                                  shape: const StadiumBorder(),
                                ),
                                onPressed: () {},
                                child: const Text('Xem them'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 28),
                          _buildSectionTitle('Lua chon cua nghe si'),
                          const SizedBox(height: 12),
                          _buildArtistPickCard(context, songs.first),
                          const SizedBox(height: 28),
                          _buildSectionHeader(
                            title: 'Ban phat hanh noi tieng',
                            actionLabel: 'Hien tat ca',
                          ),
                          const SizedBox(height: 12),
                          _buildFeaturedRelease(context, songs.first),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasNetworkImage = artist.imageUrl.startsWith('http');

    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 320,
              child:
                  hasNetworkImage
                      ? Image.network(
                        artist.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _headerFallback(),
                      )
                      : Image.asset(
                        artist.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _headerFallback(),
                      ),
            ),
            Positioned(
              top: 44,
              left: 16,
              child: _roundIconButton(
                icon: Icons.arrow_back,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Nghe si nay chua co bai hat trong Firestore.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMusicTab() {
    return const Row(
      children: [
        Text(
          'Nhac',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 20),
        SizedBox(
          width: 34,
          child: Divider(color: Color(0xFF1ED760), thickness: 2, height: 20),
        ),
      ],
    );
  }

  Widget _buildLikedSongTile(List<Song> songs) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        leading: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildArtwork(songs.first.imageUrl, width: 58, height: 58),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF1ED760),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.black,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
        title: const Text(
          'Bai hat da thich',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${songs.length} bai hat • ${artist.name}',
          style: const TextStyle(color: Colors.white60),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      ),
    );
  }

  List<Widget> _buildPopularSongs(BuildContext context, List<Song> songs) {
    final popularSongs = songs.take(5).toList();

    return List<Widget>.generate(popularSongs.length, (index) {
      final song = popularSongs[index];
      final plays = _playCountLabel(song, index);

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _playSongs(context, songs, songs.indexOf(song)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildArtwork(song.imageUrl, width: 54, height: 54),
                ),
                const SizedBox(width: 12),
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
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plays,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (index == 2)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF1ED760),
                    size: 20,
                  ),
                const SizedBox(width: 12),
                const Icon(Icons.more_vert, color: Colors.white54),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildArtistPickCard(BuildContext context, Song song) {
    return GestureDetector(
      onTap: () => _playSongs(context, [song], 0),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: _imageProviderFor(song.imageUrl),
            fit: BoxFit.cover,
            onError: (_, __) {},
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.18),
                Colors.black.withValues(alpha: 0.68),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.48),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Nguoi dang: ${artist.name}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _buildArtwork(song.imageUrl, width: 54, height: 54),
                  ),
                  const SizedBox(width: 12),
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
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          song.artist,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedRelease(BuildContext context, Song song) {
    return GestureDetector(
      onTap: () => _playSongs(context, [song], 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF8D4518),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildArtwork(song.imageUrl, width: 56, height: 56),
            ),
            const SizedBox(width: 12),
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
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.library_music_outlined, color: Colors.white),
            const SizedBox(width: 10),
            const Icon(Icons.check_circle, color: Color(0xFF1ED760)),
            const SizedBox(width: 10),
            const Icon(Icons.play_arrow, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildSectionHeader({required String title, String? actionLabel}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (actionLabel != null)
          Text(
            actionLabel,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Future<void> _playSongs(
    BuildContext context,
    List<Song> songs,
    int index,
  ) async {
    await context.read<MiniPlayerProvider>().setQueue(
      songs: songs,
      startIndex: index,
    );
    if (!context.mounted) return;
    await openNowPlayingScreen(context);
  }

  String _monthlyListenersText(String artistName) {
    switch (artistName) {
      case 'Jack - J97':
        return '1,4 tr nguoi nghe hang thang';
      case 'Bui Truong Linh':
        return '620 N nguoi nghe hang thang';
      default:
        return '613 N nguoi nghe hang thang';
    }
  }

  String _playCountLabel(Song song, int index) {
    final seed = song.title.codeUnits.fold<int>(0, (sum, code) => sum + code);
    final value = (seed * 971 + (index + 1) * 23017) % 9000000 + 120000;
    return _formatCompactNumber(value);
  }

  String _formatCompactNumber(int number) {
    final text = number.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final remaining = text.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        buffer.write('.');
      }
    }

    return buffer.toString();
  }

  Widget _roundIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.34),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildArtwork(
    String imageUrl, {
    required double width,
    required double height,
  }) {
    final isNetworkImage = imageUrl.startsWith('http');

    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _artworkPlaceholder(width, height),
      );
    }

    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _artworkPlaceholder(width, height),
    );
  }

  Widget _artworkPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[800],
      child: const Icon(Icons.music_note, color: Colors.white),
    );
  }

  Widget _headerFallback() {
    return Container(
      color: const Color(0xFF4A0F18),
      child: const Center(
        child: Icon(Icons.person, color: Colors.white, size: 72),
      ),
    );
  }

  ImageProvider _imageProviderFor(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    }
    return AssetImage(imageUrl);
  }
}

class _ArtistHeader extends StatelessWidget {
  const _ArtistHeader({
    required this.artist,
    required this.monthlyListeners,
    required this.onBack,
    required this.onPlay,
  });

  final Artist artist;
  final String monthlyListeners;
  final VoidCallback onBack;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final hasNetworkImage = artist.imageUrl.startsWith('http');

    return SizedBox(
      height: 430,
      child: Stack(
        fit: StackFit.expand,
        children: [
          hasNetworkImage
              ? Image.network(
                artist.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _headerFallback(),
              )
              : Image.asset(
                artist.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _headerFallback(),
              ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.95),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 48,
            left: 16,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.34),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  monthlyListeners,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          hasNetworkImage
                              ? Image.network(
                                artist.imageUrl,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => _miniAvatarFallback(),
                              )
                              : Image.asset(
                                artist.imageUrl,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => _miniAvatarFallback(),
                              ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Theo doi',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.more_vert, color: Colors.white70),
                    const Spacer(),
                    const Icon(Icons.shuffle, color: Colors.white70, size: 24),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: onPlay,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1ED760),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 34,
                        ),
                      ),
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

  Widget _headerFallback() {
    return Container(
      color: const Color(0xFF580D1B),
      child: const Center(
        child: Icon(Icons.person, color: Colors.white, size: 72),
      ),
    );
  }

  Widget _miniAvatarFallback() {
    return Container(
      width: 36,
      height: 36,
      color: Colors.white10,
      child: const Icon(Icons.person, color: Colors.white),
    );
  }
}
