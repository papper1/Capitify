import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool receiveNews = false;
  bool shareData = false;

  String? selectedGender;

  void nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() => _currentPage++);
    } else {
      // TODO: Gửi dữ liệu đăng ký
      print("Email: ${emailController.text}");
      print("Password: ${passwordController.text}");
      print("Gender: $selectedGender");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStepEmail(),
          _buildStepPassword(),
          _buildStepGender(),
          _buildStepName()
        ],
      ),
    );
  }

  Widget _buildStepEmail() {
    return _buildStep(
      title: "What's your email?",
      hint: "Enter your email",
      controller: emailController,
      subtitle: "You'll need to confirm this email.",
      onNext: nextPage,
    );
  }

  Widget _buildStepPassword() {
    return _buildStep(
      title: "Create a password",
      hint: "Enter your password",
      controller: passwordController,
      subtitle: "Use at least 6 characters.",
      obscureText: true,
      onNext: nextPage,
    );
  }
  Widget _buildStepName() {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            const Text("What's your name?", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.check, color: Colors.white),
                hintText: "Your display name",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 8),
            const Text("This appears on your Spotify profile", style: TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 24),
            Divider(color: Colors.grey[700]),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 12),
                children: [
                  TextSpan(text: "By tapping on “Create account”, you agree to the Spotify "),
                  TextSpan(text: "Terms of Use\n", style: TextStyle(color: Color(0xFF1ED760))),
                  TextSpan(text: "To learn more about how Spotify collects and uses your data, please see the "),
                  TextSpan(text: "Privacy Policy\n", style: TextStyle(color: Color(0xFF1ED760))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: receiveNews,
              onChanged: (val) => setState(() => receiveNews = val ?? false),
              title: const Text("Please send me news and offers from Spotify.", style: TextStyle(color: Colors.white)),
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Colors.green,
              checkboxShape: CircleBorder(),
            ),
            CheckboxListTile(
              value: shareData,
              onChanged: (val) => setState(() => shareData = val ?? false),
              title: const Text("Share my registration data with Spotify’s content providers for marketing purposes.", style: TextStyle(color: Colors.white)),
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Colors.green,
              checkboxShape: CircleBorder(),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Gửi dữ liệu đăng ký
                  print("Name: ${nameController.text}");
                  print("News: $receiveNews, Share Data: $shareData");
                },
                child: const Text("Create an account"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildStepGender() {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 30),
          const Text("What's your gender?", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedGender,
            items: ['Male', 'Female', 'Other']
                .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                .toList(),
            dropdownColor: Colors.grey[900],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) => setState(() => selectedGender = value),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: nextPage,
            child: const Text("Next"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
              shape: const StadiumBorder(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStep({
    required String title,
    required String hint,
    required TextEditingController controller,
    String? subtitle,
    bool obscureText = false,
    required VoidCallback onNext,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 30),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onNext,
            child: const Text("Next"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
              shape: const StadiumBorder(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_currentPage > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                setState(() => _currentPage--);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        const Center(
          child: Text(
            "Create account",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

}

