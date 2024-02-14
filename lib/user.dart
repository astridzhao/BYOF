import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? name;
  final String? email;
  final String? photoUrl;
  final bool? emailVerified;
  final String id;
  String? subscriptionId;
  String? productId;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  bool? renewalStatus;
  DateTime? nextRenewalDate;
  String? customField; //e.g. "promo_code_applied"

  UserModel(
      {this.name,
      required this.email,
      this.photoUrl,
      this.emailVerified,
      required this.id,
      this.productId = "Basic Plan",
      this.subscriptionId,
      this.status = "Active",
      this.startDate,
      this.endDate,
      this.nextRenewalDate,
      this.renewalStatus,
      this.customField});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'id': id,
      'productId': productId,
      'subscriptionId': subscriptionId,
      'status': status,
      'startDate': startDate,
      'endDate': endDate,
      'renewalStatus': renewalStatus,
      'nextRenewalDate': nextRenewalDate,
      'customField': customField
    };
  }

  // ... any other fields you want to include
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
