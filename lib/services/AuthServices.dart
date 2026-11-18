import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get firebase => _auth;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authState => _auth.authStateChanges();

  //====================================================
  // Email
  //====================================================

  Future<UserCredential> signInEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerEmail({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //====================================================
  // Google
  //====================================================

  Future<UserCredential?> signInGoogle() async {
    final GoogleSignInAccount account = await GoogleSignIn.instance
        .authenticate();

    final auth = account.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: auth.idToken,
      idToken: auth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  //====================================================
  // Facebook
  //====================================================

  Future<UserCredential?> signInFacebook() async {
    final result = await FacebookAuth.instance.login();

    if (result.status != LoginStatus.success) {
      return null;
    }

    final credential = FacebookAuthProvider.credential(
      result.accessToken!.tokenString,
    );

    return _auth.signInWithCredential(credential);
  }

  //====================================================
  // Apple
  //====================================================

  Future<UserCredential?> signInApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final provider = OAuthProvider("apple.com");

    final credential = provider.credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return _auth.signInWithCredential(credential);
  }

  //====================================================
  // Logout
  //====================================================

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }
}
