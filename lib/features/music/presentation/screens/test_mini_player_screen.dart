import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capytify/features/music/data/mock/mock_songs.dart';
import 'package:capytify/features/music/data/models/song.dart';
import 'package:capytify/features/music/presentation/state/mini_player_provider.dart';
import 'package:capytify/features/music/presentation/widgets/mini_player.dart';

class TestMiniPlayerScreen extends StatelessWidget {
  const TestMiniPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Song song = mockSongs[0]; // Chọn bài hát đầu tiên để test

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Test Mini Player')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Khi ấn nút, gọi Provider để set bài hát vào MiniPlayer
            context.read<MiniPlayerProvider>().setSong(song);
          },
          child: const Text("Play Song"),
        ),
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}
