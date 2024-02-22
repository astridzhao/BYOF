import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/resources/firebasestore.dart';
import 'package:astridzhao_s_food_app/Interface/user_profile/subscription/appdata.dart';
import 'package:astridzhao_s_food_app/resources/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:purchases_flutter/purchases_flutter.dart';

class Paywall extends StatefulWidget {
  //offering set in revenuecat
  final Offering offering;

  const Paywall({Key? key, required this.offering}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  String userId = "";
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid; // Assuming you have a userId variable
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 16.0),
                height: MediaQuery.of(context).size.height * 0.05,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.black),
                child: const Center(
                    child: Text(
                  'RiceBucket',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.05, horizontal: screenWidth * 0.05),
              child: const SizedBox(
                child: Text(
                  'PREMIUM SUBSCRIPTION',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                width: double.infinity,
              ),
            ),
            ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    onTap: () async {
                      try {
                        //made purchase
                        CustomerInfo customerInfo =
                            await Purchases.purchasePackage(
                                myProductList[index]);

                        customerInfo.activeSubscriptions.forEach((element) {
                          log("activeSubscriptions: $element");
                          debugPrint("activeSubscriptions: $element");
                        });

                        if (customerInfo
                            .entitlements.all[entitlementId]!.isActive) {
                          // Update subscription data in Firestore using userId
                          await Storedata(userId)
                              .updateUserSubscription(customerInfo);

                          // TODO:Unlock that great "pro" content
                          // // Trigger UI update based on new subscription status
                          // context.read<SubscriptionStatusProvider>().updateStatus(
                          //     customerInfo); // Assuming Provider for subscription status
                        }
                      } on PlatformException catch (e) {
                        var errorCode = PurchasesErrorHelper.getErrorCode(e);
                        if (errorCode !=
                            PurchasesErrorCode.purchaseCancelledError) {
                          print(e);
                        }
                      }

                      setState(() {});
                      Navigator.pop(context);
                    },
                    title: Text(
                      myProductList[index].storeProduct.title,
                      style: TextStyle(
                          color: appTheme.green_primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    subtitle: Text(
                      myProductList[index].storeProduct.description,
                    ),
                    trailing: Text(
                      myProductList[index].storeProduct.priceString,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                child: Text(
                  footerText,
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
