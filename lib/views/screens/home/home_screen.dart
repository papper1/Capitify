import 'package:flutter/material.dart';
import 'package:capytify/data/mock_artists.dart';
import 'package:capytify/data/mock_songs.dart';
import 'package:capytify/models/song.dart';
import 'package:provider/provider.dart';
import 'package:capytify/viewmodels/mini_player_provider.dart';
import 'package:capytify/views/screens/profile/profile_screen.dart';
import 'package:capytify/views/screens/song_player/song_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                  radius: 20,
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.notifications_none, color: Colors.white),
                  SizedBox(width: 16),
                  Icon(Icons.history, color: Colors.white),
                  SizedBox(width: 16),
                  Icon(Icons.settings, color: Colors.white),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              _buildFilterChip("Tất cả", selected: true),
              _buildFilterChip("Nhạc"),
              _buildFilterChip("Podcasts"),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            itemCount: mockArtists.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 3.5,
            ),
            itemBuilder: (context, index) {
              final artist = mockArtists[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongListScreen(artist: artist),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(artist.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          artist.name,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            "Nghe lại",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockSongs.length,
              itemBuilder: (context, index) {
                final Song item = mockSongs[index];
                return GestureDetector(
                  onTap: () {
                    context.read<MiniPlayerProvider>().setSong(item);
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Icon(Icons.music_note, size: 48, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.title,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.artist,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Đài phát Gợi ý",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/radio${index % 3 + 1}.jpg',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(color: selected ? Colors.black : Colors.white)),
        selected: selected,
        selectedColor: const Color(0xFF1ED760),
        backgroundColor: Colors.grey[800],
        onSelected: (_) {},
      ),
    );
  }
}
