import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:capytify/features/auth/presentation/state/auth_viewmodel.dart';

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

  @override
  void dispose() {
    _pageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (!_validateCurrentStep()) {
      return;
    }

    if (_currentPage < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() => _currentPage++);
    }
  }

  bool _validateCurrentStep() {
    switch (_currentPage) {
      case 0:
        final email = emailController.text.trim();
        if (email.isEmpty || !email.contains('@')) {
          _showMessage('Vui long nhap email hop le');
          return false;
        }
        return true;
      case 1:
        if (passwordController.text.trim().length < 6) {
          _showMessage('Mat khau can it nhat 6 ky tu');
          return false;
        }
        return true;
      case 2:
        if (selectedGender == null || selectedGender!.isEmpty) {
          _showMessage('Vui long chon gioi tinh');
          return false;
        }
        return true;
      case 3:
        if (nameController.text.trim().isEmpty) {
          _showMessage('Vui long nhap ten hien thi');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _createAccount() async {
    if (!_validateCurrentStep()) {
      return;
    }

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      displayName: nameController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    _showMessage(authViewModel.errorMessage ?? 'Dang ky that bai');
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStepEmail(),
          _buildStepPassword(),
          _buildStepGender(),
          _buildStepName(authViewModel),
        ],
      ),
    );
  }

  Widget _buildStepEmail() {
    return _buildStep(
      title: "What's your email?",
      hint: 'Enter your email',
      controller: emailController,
      subtitle: "You'll need to confirm this email.",
      onNext: nextPage,
    );
  }

  Widget _buildStepPassword() {
    return _buildStep(
      title: 'Create a password',
      hint: 'Enter your password',
      controller: passwordController,
      subtitle: 'Use at least 6 characters.',
      obscureText: true,
      onNext: nextPage,
    );
  }

  Widget _buildStepName(AuthViewModel authViewModel) {
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
            const Text(
              "What's your name?",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.check, color: Colors.white),
                hintText: 'Your display name',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This appears on your Spotify profile',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.grey[700]),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 12),
                children: [
                  TextSpan(text: 'By tapping on "Create account", you agree to the Spotify '),
                  TextSpan(
                    text: 'Terms of Use\n',
                    style: TextStyle(color: Color(0xFF1ED760)),
                  ),
                  TextSpan(
                    text: 'To learn more about how Spotify collects and uses your data, please see the ',
                  ),
                  TextSpan(
                    text: 'Privacy Policy\n',
                    style: TextStyle(color: Color(0xFF1ED760)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: receiveNews,
              onChanged: (val) => setState(() => receiveNews = val ?? false),
              title: const Text(
                'Please send me news and offers from Spotify.',
                style: TextStyle(color: Colors.white),
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Colors.green,
              checkboxShape: const CircleBorder(),
            ),
            CheckboxListTile(
              value: shareData,
              onChanged: (val) => setState(() => shareData = val ?? false),
              title: const Text(
                "Share my registration data with Spotify's content providers for marketing purposes.",
                style: TextStyle(color: Colors.white),
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Colors.green,
              checkboxShape: const CircleBorder(),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: authViewModel.isLoading ? null : _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: authViewModel.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : const Text('Create an account'),
              ),
            ),
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
          const Text(
            "What's your gender?",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) => setState(() => selectedGender = value),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
              shape: const StadiumBorder(),
            ),
            child: const Text('Next'),
          ),
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
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
              shape: const StadiumBorder(),
            ),
            child: const Text('Next'),
          ),
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
            'Create account',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
