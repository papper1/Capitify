import 'package:flutter/material.dart';
import 'package:capytify/shared/widgets/cached_app_image.dart';

class HomeArtwork extends StatelessWidget {
  const HomeArtwork({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  final String imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CachedAppImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF303030),
      child: const Center(child: Icon(Icons.music_note, color: Colors.white70)),
    );
  }
}
