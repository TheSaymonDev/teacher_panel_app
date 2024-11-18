import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as developer;

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// User Sign In with Email & Password
  Future<User?> signIn(String email, String password) async {
    try {
      developer.log("SignIn Attempt: Email => $email, Password => [HIDDEN]");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      developer.log("SignIn Success: User ID => ${userCredential.user?.uid}, "
          "Email => ${userCredential.user?.email}");
      return userCredential.user;
    } catch (e) {
      print("SignIn Error: $e");
      return null;
    }
  }

  /// Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("SignOut Error: $e");
    }
  }
}
