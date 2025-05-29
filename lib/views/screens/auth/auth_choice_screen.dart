import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:capytify/views/screens/auth/register_screen.dart';
import 'login_screen.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // 👈 quay về màn Intro
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Album Image Grid Mockup (có thể dùng Stack hoặc Image sau này)
            Expanded(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/capytify.jpg',
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Spotify Logo
            const SizedBox(height: 20),

            // Title
            const Text(
              "Millions of Songs.\nFree on Capytify.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            // Sign up Free
            _buildMainButton(
              "Sign up free",
              Colors.green,
              Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 230),
                    pageBuilder: (_, animation, __) => const SignupScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(parent: animation, curve: Curves.ease),
                        ),
                        child: child,
                      );
                    },
                  ),
                );

              },
            ),

            const SizedBox(height: 10),

            // Continue with Google
            _buildIconButton(
              "Continue with Google",
              FontAwesomeIcons.google,
              onPressed: () {
                // TODO: Google login
              },
            ),

            const SizedBox(height: 10),

            // Continue with Facebook
            _buildIconButton(
              "Continue with Facebook",
              FontAwesomeIcons.facebookF,
              onPressed: () {
                // TODO: Facebook login
              },
            ),

            const SizedBox(height: 10),

            // Continue with Apple
            _buildIconButton(
              "Continue with Apple",
              FontAwesomeIcons.apple,
              onPressed: () {
                // TODO: Apple login
              },
            ),

            const SizedBox(height: 20),

            // Log in
            GestureDetector(
              onTap: () {
                // TODO: Navigate to login screen
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 230),
                    pageBuilder: (_, animation, __) => const LoginScreen(),
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(parent: animation, curve: Curves.ease),
                        ),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Text(
                "Log in",
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton(
    String text,
    Color bgColor,
    Color textColor, {
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    String text,
    IconData icon, {
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: FaIcon(icon, color: Colors.white),
          label: Text(text, style: const TextStyle(color: Colors.white)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: Colors.white24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
