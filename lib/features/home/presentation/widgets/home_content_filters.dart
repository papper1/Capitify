import 'package:flutter/material.dart';

class HomeContentFilters extends StatelessWidget {
  const HomeContentFilters({super.key, required this.filters});

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
              right: index == filters.length - 1 ? 0 : 22,
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
      ),
    );
  }
}
