import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream — tells you if user is logged in or not
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // null means success
    } on FirebaseAuthException catch (e) {
      return e.message; // return error message
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
