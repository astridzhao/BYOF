import 'package:astridzhao_s_food_app/Interface/user_profile/firebasestore.dart';
import 'package:astridzhao_s_food_app/Interface/user_profile/subscription/appdata.dart';
import 'package:astridzhao_s_food_app/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
                height: 70.0,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.black),
                child: const Center(child: Text('RiceBucket'))),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                child: Text('PREMIUM SUBSCRIPTION'),
                width: double.infinity,
              ),
            ),
            ListView.builder(
              itemCount: widget.offering.availablePackages.length,
              itemBuilder: (BuildContext context, int index) {
                var myProductList = widget.offering.availablePackages;
                return Card(
                  color: Colors.black,
                  child: ListTile(
                    onTap: () async {
                      try {
                        CustomerInfo customerInfo =
                            await Purchases.purchasePackage(
                                myProductList[index]);
                        // Update subscription data in Firestore using userId
                        await updateUserSubscription(userId, customerInfo);

                        // // Trigger UI update based on new subscription status
                        // context.read<SubscriptionStatusProvider>().updateStatus(
                        //     customerInfo); // Assuming Provider for subscription status
                      } catch (e) {
                        print(e);
                      }

                      setState(() {});
                      Navigator.pop(context);
                    },
                    title: Text(
                      myProductList[index].storeProduct.title,
                    ),
                    subtitle: Text(
                      myProductList[index].storeProduct.description,
                    ),
                    trailing: Text(
                      myProductList[index].storeProduct.priceString,
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
