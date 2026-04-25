import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/shared/widgets/cached_app_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> openNowPlayingScreen(BuildContext context) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: FadeTransition(
              opacity: animation,
              child: const NowPlayingContent(),
            ),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

class NowPlayingContent extends StatelessWidget {
  const NowPlayingContent({super.key});

  Widget _buildArtwork(BuildContext context, String imageUrl) {
    final size = MediaQuery.of(context).size.width * 0.8;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedAppImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        placeholder: Icon(
          Icons.music_note,
          size: size * 0.4,
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Color _repeatColor(MiniPlayerProvider miniPlayer) {
    return miniPlayer.repeatMode == RepeatModeState.off
        ? Colors.white
        : const Color(0xFF1ED760);
  }

  IconData _repeatIcon(MiniPlayerProvider miniPlayer) {
    return miniPlayer.repeatMode == RepeatModeState.one
        ? Icons.repeat_one
        : Icons.repeat;
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = context.select<MiniPlayerProvider, Song?>(
      (miniPlayer) => miniPlayer.currentSong,
    );

    if (currentSong == null) {
      return const Center(
        child: Text('No song selected.', style: TextStyle(color: Colors.white)),
      );
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF121212), Color(0xFF181818)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Text(
                  'Now Playing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Spacer(),
          Hero(
            tag: 'nowplaying-image',
            child: _buildArtwork(context, currentSong.imageUrl),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Text(
                  currentSong.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentSong.artist,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Consumer<MiniPlayerProvider>(
            builder: (context, mini, child) {
              final total = mini.duration.inMilliseconds.toDouble();
              final current = mini.position.inMilliseconds.toDouble().clamp(
                0,
                total,
              );
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Slider(
                      value: total > 0 ? current.toDouble() : 0,
                      min: 0,
                      max: total > 0 ? total.toDouble() : 1,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white24,
                      onChanged: (value) {
                        mini.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(mini.position),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatDuration(mini.duration),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Consumer<MiniPlayerProvider>(
            builder: (context, miniPlayer, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shuffle,
                      color:
                          miniPlayer.isShuffleEnabled
                              ? const Color(0xFF1ED760)
                              : Colors.white,
                      size: 28,
                    ),
                    onPressed: miniPlayer.toggleShuffle,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color:
                          miniPlayer.hasPrevious
                              ? Colors.white
                              : Colors.white38,
                      size: 36,
                    ),
                    onPressed:
                        miniPlayer.hasPrevious ? miniPlayer.previousSong : null,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      miniPlayer.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.white,
                      size: 64,
                    ),
                    onPressed: miniPlayer.togglePlayPause,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: miniPlayer.hasNext ? Colors.white : Colors.white38,
                      size: 36,
                    ),
                    onPressed: miniPlayer.hasNext ? miniPlayer.nextSong : null,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      _repeatIcon(miniPlayer),
                      color: _repeatColor(miniPlayer),
                      size: 28,
                    ),
                    onPressed: miniPlayer.cycleRepeatMode,
                  ),
                ],
              );
            },
          ),
          const Spacer(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
