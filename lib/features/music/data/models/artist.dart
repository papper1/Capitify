class Artist {
  final String name;
  final String imageUrl;

  Artist({required this.name, required this.imageUrl});

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      name: (map['name'] ?? '').toString(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
