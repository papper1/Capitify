import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String? errorMessage;

  Future<bool> signIn(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true;  // Thành công
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'user-not-found') {
        errorMessage = 'Không tìm thấy tài khoản';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mật khẩu không đúng';
      } else {
        errorMessage = 'Đăng nhập thất bại: ${e.message}';
      }
      notifyListeners();
      return false;
    }
  }
}
