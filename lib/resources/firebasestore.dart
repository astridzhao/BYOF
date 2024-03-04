import 'package:astridzhao_s_food_app/resources/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

final FirebaseStorage _firebasestorage_realtime = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

/// Enum indicating the usage status of the user.
enum UsageStatus {
  Success,
  LimitReached,
  BetaSurveyNeeded,
  DocDNE,
  Error,
}

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
        _firebasestorage_realtime.ref().child(childname).child(userId);
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
      String expireDate = DateTime.utc(2030, 1, 1).toString();
      String productId = "default";
      String startDate = DateTime.now().toString();
      final accessStatus = false;
      final renewStatus = true;
      final subscriptionId = Purchases.appUserID; // If available

      print("[createUserDocument] user profile image: $imageUrl");
      await userProfileDoc.set({
        'name': name,
        'image': imageUrl,
        'productId': productId,
        'startDate': startDate,
        'expireDate': expireDate,
        'accessStatus': accessStatus.toString(),
        'renewStatus': renewStatus.toString(),
        'subscriptionId': subscriptionId.toString(),
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
          customerInfo.entitlements.all[entitlementId]?.productIdentifier ??
              "Basic Plan";
      final startDate =
          customerInfo.entitlements.all[entitlementId]?.latestPurchaseDate ??
              DateTime.now();
      final expireDate =
          customerInfo.entitlements.all[entitlementId]?.expirationDate ??
              DateTime.utc(2030, 1, 1);
      final accessStatus =
          customerInfo.entitlements.all[entitlementId]?.isActive ?? false;
      final renewStatus =
          customerInfo.entitlements.all[entitlementId]?.willRenew ?? false;
      // FIXME(yuchen): is this correct?
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
        'accessStatus': accessStatus.toString(),
        'renewStatus': renewStatus.toString(),
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
    // try {
    // Fetch the document from Firestore
    DocumentSnapshot documentSnapshot = await userProfileDoc.get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      print("[getSubscriptionInfo]: " + data.toString());

      String? productId = data['productId'];

      // default: planName = Basic Plan
      String planName = "Basic Plan";

      if (productId == "default") {
        planName = "Basic Plan";
      } else if (productId == "ricebucket01") {
        planName = "Premium Basic";
      } else if (productId == "ricebucket02") {
        planName = "Premium Plus";
      } else {
        throw Exception("Invalid product id ${productId}} encountered.");
      }

      String expirationDate = data['expireDate'];
      String accessStatus = data['accessStatus'];
      String generationLimit = data['generationLimit'];
      String renewStatus = data['renewStatus'];

      print("[getSubscriptionInfo-PLAN]: " + planName);
      print("[getSubscriptionInfo-EXPIRE]: " + expirationDate);
      print("[getSubscriptionInfo-RENEWAL]: " + renewStatus);
      print("[getSubscriptionInfo-GENERATION]: " + generationLimit);
      // Return the relevant information
      return {
        'plan': planName,
        'expirationDate': expirationDate,
        'accessStatus': accessStatus,
        'renewStatus': renewStatus,
        'generationLimit': generationLimit,
      };
    } else {
      throw Exception("Document does not exist.");
    }
    // }

    // catch (e) {
    //   print("Error retrieving subscription info: $e");
    //   throw Exception("Error retrieving subscription info.");
    // }
  }

  /// Indicates whether the user has filled the beta testing survey.
  Future<bool> betaSurveyFilled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("filledBetaSurvey00") ?? false;
  }

  /// Sets the to beta survey filled status.
  Future<void> setBetaSurveyFilled({required bool filled}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("filledBetaSurvey00", filled);
  }

  Future<UsageStatus> decrementGenerationLimit() async {
    try {
      // Fetch current generation limit from Firestore
      DocumentSnapshot documentSnapshot = await userProfileDoc.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        int currentLimit = int.parse(data['generationLimit']);

        if (currentLimit <= 0) {
          print("Generation limit reached. No more generations allowed.");

          // Indicate that the generation limit has been reached
          return UsageStatus.LimitReached;
        } else {
          // --- BETA ONLY SECTION BEGIN ---
          const basicPlanLimit = 10;
          final timeUsed = basicPlanLimit - currentLimit;
          if (timeUsed == 2) {
            final surveyFilled = await betaSurveyFilled();
            if (!surveyFilled) {
              return UsageStatus.BetaSurveyNeeded;
            }
          }
          // --- BETA ONLY SECTION END   ---

          // Decrement the generation limit and update Firestore
          int newLimit = currentLimit - 1;
          await userProfileDoc.update({'generationLimit': newLimit.toString()});
          print("Generation limit decremented. New limit: $newLimit");

          // Indicate successful decrement
          return UsageStatus.Success;
        }
      } else {
        print("Document does not exist.");

        // Handle the case where the document doesn't exist
        return UsageStatus.DocDNE;
      }
    } catch (e) {
      print("Error decrementing generation limit: $e");

      // Handle exceptions
      return UsageStatus.Error;
    }
  }

  Future<void> renewPlanGenerationLimit() async {
    try {
      // Fetch current generation limit from Firestore
      DocumentSnapshot documentSnapshot = await userProfileDoc.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        int newLimit = 10;

        if (data['plan'] == 'Basic Plan') {
          newLimit = 10;
        } else if (data['plan'] == 'Premium Basic') {
          newLimit = 50;
        } else if (data['plan'] == 'Premium Plus') {
          newLimit = 300;
        } else {
          // Handle unexpected plan types
          throw Exception("Invalid plan type encountered.");
        }

        if (DateTime.now().isAtSameMomentAs(data['expirationDate'])) {
          await userProfileDoc.update({'generationLimit': newLimit.toString()});
          print(
              "Generation limit renewed. New limit: $newLimit"); // Indicate successful update
        }
      } else {
        print(
            "Document does not exist."); // Handle the case where the document doesn't exist
      }
    } catch (e) {
      print("Error decrementing generation limit: $e"); // Handle exceptions
    }
  }
}
