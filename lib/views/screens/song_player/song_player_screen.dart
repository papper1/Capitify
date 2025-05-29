import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capytify/viewmodels/mini_player_provider.dart';


class NowPlayingContent extends StatelessWidget {
  const NowPlayingContent({super.key});


  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final miniPlayer = context.watch<MiniPlayerProvider>();

    if (miniPlayer.currentSong == null) {
      return const Center(
          child: Text(
            "No song selected.",
            style: TextStyle(color: Colors.white),
          ));
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
          // 🌟 Top Row: Back + Tùy chọn
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Text(
                  'Now Playing',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
                  onPressed: () {
                    // TODO: Tùy chọn mở dialog hoặc bottom sheet
                  },
                ),
              ],
            ),
          ),

          const Spacer(),

          // 🌟 Ảnh album
          Hero(
            tag: 'nowplaying-image',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                miniPlayer.currentSong!.imageUrl,
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🌟 Tên bài hát & nghệ sĩ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Text(
                  miniPlayer.currentSong!.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  miniPlayer.currentSong!.artist,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🌟 Progress bar (Seekbar)
          Consumer<MiniPlayerProvider>(
            builder: (context, mini, child) {
              final total = mini.duration.inMilliseconds.toDouble();
              final current = mini.position.inMilliseconds.toDouble().clamp(0, total);
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
                        Text(_formatDuration(mini.position),
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        Text(_formatDuration(mini.duration),
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // 🌟 Điều khiển nhạc
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.shuffle, color: Colors.white, size: 28), onPressed: () {}),
              const SizedBox(width: 20),
              IconButton(icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36), onPressed: () {}),
              const SizedBox(width: 20),
              IconButton(
                icon: Icon(
                  miniPlayer.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: Colors.white,
                  size: 64,
                ),
                onPressed: miniPlayer.togglePlayPause,
              ),
              const SizedBox(width: 20),
              IconButton(icon: const Icon(Icons.skip_next, color: Colors.white, size: 36), onPressed: () {}),
              const SizedBox(width: 20),
              IconButton(icon: const Icon(Icons.repeat, color: Colors.white, size: 28), onPressed: () {}),
            ],
          ),

          const Spacer(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
