import 'package:flutter/material.dart';
import 'package:capytify/models/artists.dart';

class SongListScreen extends StatelessWidget {
  final Artist artist;

  const SongListScreen({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    // Dummy data cho nghệ sĩ
    String artistName = 'Shiki';
    String artistImage = 'assets/images/shiki.jpg'; // Thay bằng ảnh của bạn
    String followers = '1,4 Tr người nghe hàng tháng';

    // Dummy data danh sách bài hát
    List<Map<String, dynamic>> songs = [
      {'title': 'Có Đôi Điều', 'views': '14.816.307', 'image': artistImage},
      {'title': '1000 Ánh Mắt', 'views': '18.422.750', 'image': artistImage},
      {'title': 'Hà Nội', 'views': '34.879.781', 'image': artistImage},
      {'title': 'Đánh Đổi', 'views': '29.639.854', 'image': artistImage},
      {'title': 'Đầu Đường Xó Chợ', 'views': '12.976.127', 'image': artistImage},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Header với ảnh nghệ sĩ
          Stack(
            children: [
              Image.asset(artistImage, width: double.infinity, height: 250, fit: BoxFit.cover),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),

          // Thông tin nghệ sĩ
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    artistName,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Icon(Icons.play_arrow),
                ),
              ],
            ),
          ),
          Text(followers, style: const TextStyle(color: Colors.white70)),

          // Tabs (âm nhạc / video)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text('Âm nhạc', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 16),
                Text('Đoạn video', style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),

          // Danh sách bài hát
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(song['image'], width: 50, height: 50, fit: BoxFit.cover),
                  ),
                  title: Text(song['title'], style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song['views'], style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  trailing: const Icon(Icons.more_vert, color: Colors.white),
                  onTap: () {
                    // TODO: Xử lý phát bài hát
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
