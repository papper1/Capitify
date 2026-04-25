import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:capytify/features/auth/presentation/state/auth_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;
    final displayName = _displayNameForUser(user?.displayName, user?.email);
    final subtitle = user?.email ?? 'Chua dang nhap';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.orange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUserAvatar(user?.photoURL, displayName),
                  const SizedBox(height: 8),
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Chinh sua',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: const [
                  Text(
                    'Danh sach phat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    leading: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 40,
                    ),
                    title: Text(
                      'Danh sach phat cua toi #1',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '0 luot luu',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _displayNameForUser(String? displayName, String? email) {
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }
    if (email != null && email.trim().isNotEmpty) {
      return email.split('@').first;
    }
    return 'Nguoi dung';
  }

  Widget _buildUserAvatar(String? photoUrl, String label) {
    final firstChar =
        label.isNotEmpty ? label.substring(0, 1).toUpperCase() : 'U';

    if (photoUrl != null && photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: CachedNetworkImageProvider(photoUrl),
      );
    }

    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white24,
      child: Text(
        firstChar,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
