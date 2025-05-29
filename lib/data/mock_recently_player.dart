class RecentlyPlayed {
  final String imageUrl;
  final String playlistName;
  final String artistName;

  RecentlyPlayed({
    required this.imageUrl,
    required this.playlistName,
    required this.artistName,
  });
}

final List<RecentlyPlayed> mockRecentlyPlayed = [
  RecentlyPlayed(
    imageUrl: 'assets/images/Shiki.jpg',
    playlistName: 'Lặng',
    artistName: 'Shiki',
  ),
  RecentlyPlayed(
    imageUrl: 'assets/images/Muahenamdo.jpg',
    playlistName: 'Mùa hè năm đó',
    artistName: 'The Underdogs',
  ),
  RecentlyPlayed(
    imageUrl: 'assets/images/wn.jpg',
    playlistName: 'W/N',
    artistName: '',
  ),
  RecentlyPlayed(
    imageUrl: 'assets/images/vu.jpg',
    playlistName: 'Vũ',
    artistName: 'Love Singers',
  ),
  RecentlyPlayed(
    imageUrl: 'assets/images/jack_j97.jpg',
    playlistName: 'JACK - J97',
    artistName: '',
  ),
];
