import 'package:capytify/features/music/data/models/song.dart';
import 'package:flutter/material.dart';

class HomeShelfCardData {
  const HomeShelfCardData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.song,
    required this.palette,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final Song song;
  final List<Color> palette;
}
