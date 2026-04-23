import 'package:capytify/features/home/presentation/widgets/home_filter_chip_pill.dart';
import 'package:flutter/material.dart';

class HomePrimaryFilters extends StatelessWidget {
  const HomePrimaryFilters({super.key, required this.filters});

  final List<String> filters;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (index) {
          final label = filters[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index == filters.length - 1 ? 0 : 12,
            ),
            child: HomeFilterChipPill(label: label, isSelected: index == 0),
          );
        }),
      ),
    );
  }
}
