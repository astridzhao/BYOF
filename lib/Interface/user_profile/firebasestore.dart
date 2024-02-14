import 'package:astridzhao_s_food_app/constant.dart';
import 'package:astridzhao_s_food_app/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> createOrUpdateUserDocument(
    UserModel user, String productId) async {
  // final user = FirebaseAuth.instance.currentUser;
  final data = UserModel(
    email: user.email,
    photoUrl: user.photoUrl,
    emailVerified: user.emailVerified,
    id: user.id,
    productId: productId,
    status: "inActive",
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
    renewalStatus: true,
  ).toJson();

  await firestore.collection('users').doc(user.id).set(data);
}

Future<void> updateUserSubscription(
    String userId, CustomerInfo customerInfo) async {
  // Retrieve updated user information based on customerInfo

  try {
    // Extract relevant subscription data from customerInfo
    final productId =
        customerInfo.entitlements.all[entitlementId]?.productIdentifier;
    final startDate =
        customerInfo.entitlements.all[entitlementId]?.latestPurchaseDate ??
            DateTime.now();
    final expireDate =
        customerInfo.entitlements.all[entitlementId]?.expirationDate;
    final renewalStatus =
        customerInfo.entitlements.all[entitlementId]?.isActive ?? false;

    // Build update data with only necessary fields
    final updatedData = {
      'productId': productId,
      'expireDate': expireDate,
      'startDate': startDate,
      'renewalStatus': renewalStatus,
    };

    // Update user document in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update(updatedData);
  } on FirebaseException catch (e) {
    // Handle Firebase errors appropriately (e.g., logging, user feedback)
    print(e.message);
  }
}
