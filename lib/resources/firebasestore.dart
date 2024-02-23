import 'package:astridzhao_s_food_app/resources/constant.dart';
import 'package:astridzhao_s_food_app/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'dart:developer';

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
      int generationLimit = 10;
      print("[createUserDocument] user profile image: $imageUrl");
      await userProfileDoc.set({
        'name': name,
        'image': imageUrl,
        'generationLimit': generationLimit.toString(),
      });
      print("[firestore]Profile created successfully");
      return "Profile created successfully";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String> updateUserSubscription(CustomerInfo customerInfo) async {
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

      final generationLimit;

      if (productId == "ricebucket01") {
        generationLimit = 50;
      } else if (productId == "ricebucket02") {
        generationLimit = 300;
      } else {
        generationLimit = 10;
      }
      // Build update data with only necessary fields
      final updatedData = await {
        'productId': productId.toString(), //subscription plan name
        'expireDate': expireDate.toString(),
        'startDate': startDate.toString(),
        'renewalStatus': renewalStatus.toString(),
        'subscriptionId': subscriptionId.toString(),
        'generationLimit': generationLimit.toString(),
      };

      print("updateUserSubscription: " + updatedData.toString());

      // Update user document in Firestore
      // await firestore.collection('userProfile').doc(userId).update(updatedData);
      await userProfileDoc.update(updatedData);
    } on FirebaseException catch (e) {
      // Handle Firebase errors appropriately (e.g., logging, user feedback)
      print(e.message);
      print("An error occurred updating your subscription.");
    }
    return "Subscription updated successfully";
  }

  Future<Map<String, dynamic>> getSubscriptionInfo() async {
    try {
      // Fetch the document from Firestore
      DocumentSnapshot documentSnapshot = await userProfileDoc.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        print("[getSubscriptionInfo]: " + data.toString());
        // Extract expirationDate and renewalStatus from the document
        String? productId = data['productId'];

        String planName = "Basic Plan";
        print("[getSubscriptionInfo]: " + productId.toString());
        if (productId.toString() == "ricebucket01") {
          planName = "Premium Basic";
        }
        if (productId.toString() == "ricebucket02") {
          planName = "Premium Plus";
        }

        String expirationDate = data['expireDate'];
        String renewalStatus = data['renewalStatus'];
        String generationLimit = data['generationLimit'];

        print("[getSubscriptionInfo-PLAN]: " + planName);
        print("[getSubscriptionInfo-EXPIRE]: " + expirationDate);
        print("[getSubscriptionInfo-RENEWAL]: " + renewalStatus);
        print("[getSubscriptionInfo-GENERATION]: " + generationLimit);
        // Return the relevant information
        return {
          'plan': planName,
          'expirationDate': expirationDate,
          'renewalStatus': renewalStatus,
          'generationLimit': generationLimit,
        };
      } else {
        throw Exception("Document does not exist.");
      }
    } catch (e) {
      print("Error retrieving subscription info: $e");
      throw Exception("Error retrieving subscription info.");
    }
  }

  Future<bool> decrementGenerationLimit() async {
    try {
      // Fetch current generation limit from Firestore
      DocumentSnapshot documentSnapshot = await userProfileDoc.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        int currentLimit = int.parse(data['generationLimit']);

        if (currentLimit <= 0) {
          print("Generation limit reached. No more generations allowed.");
          return false; // Indicate that the generation limit has been reached
        } else {
          // Decrement the generation limit and update Firestore
          int newLimit = currentLimit - 1;
          await userProfileDoc.update({'generationLimit': newLimit.toString()});
          print("Generation limit decremented. New limit: $newLimit");
          return true; // Indicate successful decrement
        }
      } else {
        print("Document does not exist.");
        return false; // Handle the case where the document doesn't exist
      }
    } catch (e) {
      print("Error decrementing generation limit: $e");
      return false; // Handle exceptions
    }
  }
}
