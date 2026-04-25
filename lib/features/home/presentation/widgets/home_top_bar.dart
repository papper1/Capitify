import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.photoUrl,
    required this.label,
    required this.onAvatarTap,
    required this.onSettingsTap,
  });

  final String? photoUrl;
  final String label;
  final VoidCallback onAvatarTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(onTap: onAvatarTap, child: _buildUserAvatar()),
        const Spacer(),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 14),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.history, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 14),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: onSettingsTap,
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    final firstChar =
        label.isNotEmpty ? label.substring(0, 1).toUpperCase() : 'U';

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundImage: CachedNetworkImageProvider(photoUrl!),
      );
    }

    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFF1A7D8E),
      child: Text(
        firstChar,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
