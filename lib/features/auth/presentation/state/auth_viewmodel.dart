import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel() {
    currentUser = _auth.currentUser;
    _auth.authStateChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;
  User? currentUser;

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (displayName.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(displayName.trim());
        await credential.user?.reload();
        currentUser = _auth.currentUser;
      }

      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email nay da duoc su dung';
          break;
        case 'invalid-email':
          errorMessage = 'Email khong hop le';
          break;
        case 'weak-password':
          errorMessage = 'Mat khau qua yeu';
          break;
        default:
          errorMessage = 'Dang ky that bai: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Dang ky that bai: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'user-not-found') {
        errorMessage = 'Khong tim thay tai khoan';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Mat khau khong dung';
      } else {
        errorMessage = 'Dang nhap that bai: ${e.message}';
      }
      notifyListeners();
      return false;
    } catch (e) {
      isLoading = false;
      errorMessage = 'Dang nhap that bai: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _auth.signOut();
    } catch (e) {
      errorMessage = 'Dang xuat that bai: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
