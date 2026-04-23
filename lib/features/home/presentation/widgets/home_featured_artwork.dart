import 'package:capytify/features/home/data/models/home_shelf_card_data.dart';
import 'package:capytify/features/home/presentation/widgets/home_artwork.dart';
import 'package:flutter/material.dart';

class HomeFeaturedArtwork extends StatelessWidget {
  const HomeFeaturedArtwork({
    super.key,
    required this.item,
  });

  final HomeShelfCardData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      width: 168,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: item.palette,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: HomeArtwork(
                  imageUrl: item.imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 10,
            left: 10,
            child: Icon(Icons.album_rounded, color: Colors.black87, size: 18),
          ),
          const Positioned(
            top: 10,
            right: 12,
            child: Text(
              'RADIO',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
