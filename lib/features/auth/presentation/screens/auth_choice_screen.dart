import 'package:capytify/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'login_screen.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final canPop = navigator.canPop();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: canPop ? Colors.white : Colors.transparent,
                        ),
                        onPressed: canPop ? () => navigator.pop() : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
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
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.ease,
                              ),
                            ),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildIconButton(
                  "Continue with Google",
                  FontAwesomeIcons.google,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                _buildIconButton(
                  "Continue with Facebook",
                  FontAwesomeIcons.facebookF,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                _buildIconButton(
                  "Continue with Apple",
                  FontAwesomeIcons.apple,
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
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
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.ease,
                              ),
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
              ],
            ),
          ),
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
