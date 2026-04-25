import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedAppImage extends StatelessWidget {
  const CachedAppImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => placeholder ?? _defaultPlaceholder(),
        errorWidget: (_, __, ___) => placeholder ?? _defaultPlaceholder(),
      );
    }

    return Image.asset(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => placeholder ?? _defaultPlaceholder(),
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF303030),
      child: const Center(child: Icon(Icons.music_note, color: Colors.white70)),
    );
  }
}
