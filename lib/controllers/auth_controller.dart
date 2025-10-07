
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class AuthController {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  fb_auth.User? get currentUser => _auth.currentUser;

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await cred.user?.updateProfile(displayName: username);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateProfile({
    String? username,
    String? email,
    String? password,
    String? photoUrl,
  }) async {
    final user = currentUser;
    if (user == null) return;

    if (username != null || photoUrl != null) {
      await user.updateProfile(displayName: username, photoURL: photoUrl);
    }
    if (email != null) {
      await user.verifyBeforeUpdateEmail(email);
    }
    if (password != null) {
      await user.updatePassword(password);
    }

    await user.reload();
  }
}
