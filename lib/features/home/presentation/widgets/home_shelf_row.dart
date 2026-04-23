import 'package:capytify/features/home/data/models/home_shelf_card_data.dart';
import 'package:capytify/features/home/presentation/widgets/home_featured_artwork.dart';
import 'package:flutter/material.dart';

class HomeShelfRow extends StatelessWidget {
  const HomeShelfRow({
    super.key,
    required this.items,
    required this.onTap,
  });

  final List<HomeShelfCardData> items;
  final ValueChanged<HomeShelfCardData> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 276,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => onTap(item),
            child: Container(
              width: 168,
              margin: EdgeInsets.only(right: index == items.length - 1 ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeFeaturedArtwork(item: item),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
