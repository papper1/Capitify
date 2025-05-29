import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../data/mock_songs.dart';
import '../widgets/mini_player.dart';
import '../viewmodels/mini_player_provider.dart';

class TestMiniPlayerScreen extends StatelessWidget {
  const TestMiniPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Song song = mockSongs[0]; // Chọn bài hát đầu tiên để test

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Test Mini Player'),
      ),
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
