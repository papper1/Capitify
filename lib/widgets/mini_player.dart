import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capytify/viewmodels/mini_player_provider.dart';
import 'package:capytify/views/screens/song_player/song_player_screen.dart';  // Import nội dung NowPlaying

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MiniPlayerProvider>(
      builder: (context, miniPlayer, child) {
        if (miniPlayer.currentSong == null) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
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
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Container(
            color: Colors.grey[900],
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Hero( // 🌟 Bọc Hero cho ảnh
                  tag: 'nowplaying-image',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      miniPlayer.currentSong!.imageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.music_note, size: 40, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        miniPlayer.currentSong!.title,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        miniPlayer.currentSong!.artist,
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: miniPlayer.togglePlayPause,
                  icon: Icon(
                    miniPlayer.isPlaying ? Icons.pause : Icons.play_arrow,
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
