import 'package:firebase_auth/firebase_auth.dart';
import 'package:astridzhao_s_food_app/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserModel?> signUpUser(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        await firebaseUser.sendEmailVerification().catchError((error) {
          print("Failed to send verification email: $error");
        });
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
          code: e.code, message: e.message); // Re-throwing for simplicity
      // return Future.error(errorMessage);
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
    return null;
  }

  Future<UserModel?> signInUser(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid,
          // emailVerified: firebaseUser.emailVerified,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
    return null;
  }

  ///signOutUser
  Future<void> signOutUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
