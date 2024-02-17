import 'package:astridzhao_s_food_app/resources/constant.dart';
import 'package:astridzhao_s_food_app/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final FirebaseStorage _firebasestorage_realtime = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class Storedata {
  final String userId;
  late DocumentReference userProfileDoc;
  // final userId = Storedata(userId);
  Storedata(this.userId) {
    print("prepare to save into firestore");
    userProfileDoc = firestore.collection('userProfile').doc(userId);
  }

  Future<String> uploadProfileImage(String childname, Uint8List image) async {
    Reference _ref =
        _firebasestorage_realtime.ref().child(childname).child('id');
    UploadTask uploadTask = _ref.putData(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadurl = await taskSnapshot.ref.getDownloadURL();
    print("[uploadProfileImage] user profile image: $downloadurl");
    return downloadurl;
  }

  Future<String> createUserDocument(
      {required String name, required Uint8List image}) async {
    try {
      String imageUrl = await uploadProfileImage("profileImage", image);
      print("[createUserDocument] user profile image: $imageUrl");
      await userProfileDoc.set({
        'name': name,
        'image': imageUrl,
      });
      print("[firestore]Profile created successfully");
      return "Profile created successfully";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<void> updateUserDocument(UserModel user, String productId) async {
    final data = UserModel(
      email: user.email,
      photoUrl: user.photoUrl,
      emailVerified: user.emailVerified,
      id: user.id,
      // subscriptionId: appUserID,
      productId: productId,
      status: "inActive",
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      renewalStatus: true,
    ).toJson();

    // await firestore.collection('userProfile').doc(user.id).update(data);
    await userProfileDoc.update(data);
  }

  Future<void> updateUserSubscription(CustomerInfo customerInfo) async {
    // Retrieve updated user information based on customerInfo

    try {
      // Extract relevant subscription information
      final productId =
          customerInfo.entitlements.all[entitlementId]?.productIdentifier ?? "";
      final startDate =
          customerInfo.entitlements.all[entitlementId]?.latestPurchaseDate ??
              DateTime.now();
      final expireDate =
          customerInfo.entitlements.all[entitlementId]?.expirationDate;
      final renewalStatus =
          customerInfo.entitlements.all[entitlementId]?.isActive ?? false;

      final subscriptionId = Purchases.appUserID; // If available
      // Build update data with only necessary fields
      final updatedData = await {
        'productId': productId,
        'expireDate': expireDate,
        'startDate': startDate,
        'renewalStatus': renewalStatus,
        'subscriptionId': subscriptionId,
      };

      // Update user document in Firestore
      // await firestore.collection('userProfile').doc(userId).update(updatedData);
      await userProfileDoc.update(updatedData);
    } on FirebaseException catch (e) {
      // Handle Firebase errors appropriately (e.g., logging, user feedback)
      print(e.message);
      print("An error occurred updating your subscription.");
    }
  }
}
