import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Search', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            onPressed: () {
              // TODO: Xử lý khi nhấn nút camera
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 🌟 Search box
            TextField(
              decoration: InputDecoration(
                hintText: 'Artists, songs, or podcasts',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),

            // 🌟 Your top genres
            const Text(
              'Your top genres',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildGenreCard('Pop', Colors.purple, 'https://i.imgur.com/STARP.jpg'),
                const SizedBox(width: 12),
                _buildGenreCard('Indie', Colors.green, null),
              ],
            ),
            const SizedBox(height: 24),

            // 🌟 Popular podcast categories
            const Text(
              'Popular podcast categories',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildGenreCard('News & Politics', Colors.blue, null),
                const SizedBox(width: 12),
                _buildGenreCard('Comedy', Colors.red, null),
              ],
            ),
            const SizedBox(height: 24),

            // 🌟 Browse all
            const Text(
              'Browse all',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildGenreCard('2021 Wrapped', Colors.green, null),
                _buildGenreCard('Podcasts', Colors.blue, null),
                _buildGenreCard('Made for you', Colors.pink, null),
                _buildGenreCard('Charts', Colors.deepPurple, null),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreCard(String title, Color color, String? imageUrl) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            if (imageUrl != null)
              Positioned(
                right: -20,
                bottom: -20,
                child: Transform.rotate(
                  angle: -0.3,
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
