class Song {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.audioUrl,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      artist: (map['artist'] ?? '').toString(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
      audioUrl: (map['audioUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };
  }
}
