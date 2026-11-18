import 'package:ahorrala/services/AuthServices.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  User? _user;

  bool _loading = false;

  String? _error;

  User? get user => _user;

  bool get loading => _loading;

  bool get isLogged => _user != null;

  String? get error => _error;

  AuthProvider() {
    _user = _service.currentUser;

    _service.authState.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  void _start() {
    _loading = true;
    _error = null;
    notifyListeners();
  }

  void _finish() {
    _loading = false;
    notifyListeners();
  }

  Future<bool> loginEmail(String email, String password) async {
    try {
      _start();

      await _service.signInEmail(email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      print("Error loginEmail: ${e.stackTrace.toString()}");
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      _start();

      await _service.registerEmail(email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      _error = e.message;
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> loginGoogle() async {
    try {
      _start();

      await _service.signInGoogle();

      return true;
    } catch (e) {
      _error = e.toString();
      print("Error loginGoogle: $_error");
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> loginFacebook() async {
    try {
      _start();

      await _service.signInFacebook();

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _finish();
    }
  }

  Future<bool> loginApple() async {
    try {
      _start();

      await _service.signInApple();

      return true;
    } catch (e) {
      _error = e.toString();
      print("Error loginApple: $_error");
      return false;
    } finally {
      _finish();
    }
  }

  Future<void> logout() async {
    await _service.signOut();
  }
}
