import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://i.imgur.com/your-avatar.jpg',
              ),
              radius: 16,
            ),
            const SizedBox(width: 8),
            const Text('Your Library', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // TODO: Xử lý khi nhấn nút thêm
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 🌟 Bộ nút filter: Playlists, Artists, Albums, Podcasts & shows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('Playlists'),
                _buildFilterButton('Artists'),
                _buildFilterButton('Albums'),
                _buildFilterButton('Podcasts & shows'),
              ],
            ),
            const SizedBox(height: 16),

            // 🌟 Recently Played + Grid/List toggle (tạm thời chỉ text)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Recently played',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.grid_view, color: Colors.white),
              ],
            ),
            const SizedBox(height: 16),

            // 🌟 Danh sách thư viện (ListView)
            _buildLibraryItem(
              'Liked Songs',
              'Playlist • 58 songs',
              'assets/images/liked_songs.svg',
              isSvg: true,
              centerIcon: Icons.favorite,
            ),
            _buildLibraryItem(
              'New Episodes',
              'Updated 2 days ago',
              'assets/images/new_episodes.svg',
              isSvg: true,
              centerIcon: Icons.notifications,
            ),
            _buildLibraryItem(
              'Lolo Zouaï',
              'Artist',
              'https://i.imgur.com/artist1.jpg',
            ),
            _buildLibraryItem(
              'Lana Del Rey',
              'Artist',
              'https://i.imgur.com/artist2.jpg',
            ),
            _buildLibraryItem(
              'Front Left',
              'Playlist • Spotify',
              'https://i.imgur.com/playlist2.jpg',
            ),
            _buildLibraryItem(
              'Marvin Gaye',
              'Artist',
              'https://i.imgur.com/artist3.jpg',
            ),
            _buildLibraryItem(
              'Les',
              'Song • Childish Gambino',
              'https://i.imgur.com/song-cover.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildLibraryItem(
    String title,
    String subtitle,
    String imagePath, {
    bool isSvg = false,
    IconData? centerIcon,
  }) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  isSvg
                      ? SvgPicture.asset(imagePath, width: 50, height: 50)
                      : Image.network(
                        imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
            ),
            if (centerIcon != null)
              Icon(
                centerIcon,
                color: Colors.white,
                size: 24,
              ), // 🌟 Icon chèn vào giữa
          ],
        ),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
      onTap: () {},
    );
  }
}
