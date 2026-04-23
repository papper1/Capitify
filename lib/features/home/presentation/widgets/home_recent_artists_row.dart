import 'package:capytify/features/home/data/models/home_recent_collection_item.dart';
import 'package:capytify/features/home/presentation/widgets/home_artwork.dart';
import 'package:flutter/material.dart';

class HomeRecentArtistsRow extends StatelessWidget {
  const HomeRecentArtistsRow({
    super.key,
    required this.items,
    required this.onTap,
  });

  final List<HomeRecentCollectionItem> items;
  final ValueChanged<HomeRecentCollectionItem> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 174,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => onTap(item),
            child: Container(
              width: 122,
              margin: EdgeInsets.only(
                right: index == items.length - 1 ? 0 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      item.isCircular ? 61 : 10,
                    ),
                    child: HomeArtwork(
                      imageUrl: item.imageUrl,
                      width: 122,
                      height: 122,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
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
