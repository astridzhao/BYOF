import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? name;
  final String? email;
  final String? photoUrl;
  final bool? emailVerified;
  final String id;

  UserModel({
    this.name,
    required this.email,
    this.photoUrl,
    this.emailVerified,
    required this.id,
  });
}

Future<UserModel?> getCurrentUserModel() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Assume fetching additional details asynchronously, for example:
    // var userDetails = await Firestore.instance.collection('users').doc(user.uid).get();
    return UserModel(
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      id: user.uid,
    );
  }
  return null;
}
