import 'package:flutter/material.dart';
import 'package:capytify/views/screens/auth/auth_choice_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền
          SizedBox.expand(
            child: Opacity(
              opacity: 0.8, // 👈 độ mờ từ 0.0 (trong suốt) đến 1.0 (rõ nét)
              child: Image.asset(
                'assets/images/intro.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),


          // Lớp phủ tối nhẹ để chữ nổi bật hơn
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // Nội dung chính
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                Column(
                  children: [


                  ],
                ),

                // Dòng giới thiệu
                Column(
                  children: const [
                    Text(
                      "Enjoy Listening To Music",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Discover millions of free songs and podcasts, anytime, anywhere with Capytify.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                // Nút Get Started
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child:ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 230),
                          pageBuilder: (_, animation, __) => const AuthChoiceScreen(),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ED760),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
