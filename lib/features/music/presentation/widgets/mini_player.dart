import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/features/music/presentation/screens/song_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  Widget _buildArtwork(String imageUrl, {double size = 40}) {
    final isNetworkImage = imageUrl.startsWith('http');
    final image =
        isNetworkImage
            ? Image.network(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) =>
                      Icon(Icons.music_note, size: size, color: Colors.white),
            )
            : Image.asset(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) =>
                      Icon(Icons.music_note, size: size, color: Colors.white),
            );

    return ClipRRect(borderRadius: BorderRadius.circular(4), child: image);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MiniPlayerProvider, _MiniPlayerViewData>(
      selector:
          (_, miniPlayer) => _MiniPlayerViewData(
            currentSong: miniPlayer.currentSong,
            isPlaying: miniPlayer.isPlaying,
          ),
      builder: (context, viewData, child) {
        final currentSong = viewData.currentSong;
        if (currentSong == null) {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            openNowPlayingScreen(context);
          },
          child: Container(
            color: Colors.grey[900],
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Hero(
                  tag: 'nowplaying-image',
                  child: _buildArtwork(currentSong.imageUrl),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentSong.artist,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: context.read<MiniPlayerProvider>().togglePlayPause,
                  icon: Icon(
                    viewData.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MiniPlayerViewData {
  const _MiniPlayerViewData({
    required this.currentSong,
    required this.isPlaying,
  });

  final Song? currentSong;
  final bool isPlaying;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _MiniPlayerViewData &&
        other.currentSong?.id == currentSong?.id &&
        other.isPlaying == isPlaying;
  }

  @override
  int get hashCode => Object.hash(currentSong?.id, isPlaying);
}
