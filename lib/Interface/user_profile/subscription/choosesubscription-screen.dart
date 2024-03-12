import 'dart:io';

import 'package:astridzhao_s_food_app/resources/firebasestore.dart';
import 'package:astridzhao_s_food_app/resources/constant.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:astridzhao_s_food_app/Interface/user_profile/subscription/revenuecat-payment.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  SubscriptionPageState createState() => SubscriptionPageState();
}

class SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Purchases.removeCustomerInfoUpdateListener(
        (customerInfo) async {}); // Dispose of listener
  }

  Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);
    final user = FirebaseAuth.instance.currentUser;
    //observerMode is false, so Purchases will automatically handle finishing transactions.
    PurchasesConfiguration configuration = PurchasesConfiguration(appleApiKey)
      ..appUserID = user!.uid
      ..observerMode = false;

    await Purchases.configure(configuration);

    //   //add revenuecat data into firebase
    //   //adds a listener that triggers whenever there's a change in the user's subscription information.
    //   Purchases.addCustomerInfoUpdateListener((customerInfo) async {
    //     //retrieves the latest customer information from RevenueCat
    //     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    //     print("[choosesubscriptionpage]customerInfo: $customerInfo");
    //     if ((customerInfo.entitlements.all[entitlementId] != null &&
    //         customerInfo.entitlements.all[entitlementId]!.isActive)) {
    //       Storedata(user.uid).updateUserSubscription(customerInfo);
    //     }

    //     if (mounted) {
    //       //Notify the framework that the internal state of this object has changed.
    //       setState(() {});
    //     }
    //   });
    // }
  }

  bool _isLoading = false;

  void perfomMagic() async {
    setState(() {
      _isLoading = true;
    });

    //TODO: unlock features based on subscription status
    // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    // if (customerInfo.entitlements.all[entitlementId] != null &&
    //     customerInfo.entitlements.all[entitlementId]!.isActive == true) {
    //      .....
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }

    Offerings? offerings;
    try {
      offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        const snackbar = SnackBar(content: Text("No plans available"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
      final packages = offerings.current!.availablePackages;

      await showModalBottomSheet(
        useRootNavigator: true,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Paywall(
              offering: offerings!.current!,
            );
          });
        },
      );
    } on PlatformException catch (e) {
      String? error = e.message;
      print("Error: $error");
      await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text("Error"),
                  content: Container(child: Text(error!)),
                  actions: [
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context, false), // passing false
                      child:
                          Text('OK', style: TextStyle(color: Colors.black54)),
                    ),
                  ]));
    }

    setState(() {
      _isLoading = false;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget preview() {
      return Padding(
        padding: EdgeInsets.all(
          screenWidth * 0.05,
        ),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/subscription-screen.jpeg"),
              fit: BoxFit.cover, // Ensure the image covers the whole container
            ),
            borderRadius: BorderRadius.circular(20.0), // Apply border radius
          ),
        ),
      );
    }

    // Sample data for the plans
    final List<Map<String, dynamic>> plans = [
      {
        'title': 'Giving Back',
        'subtitle': 'Basic Plan',
        'features': [
          'Up to 5 times Recipe Customization',
          'Preview Dishes',
        ],
        'price': '\ Free',
      },
      {
        'title': 'Try It Out',
        'subtitle': 'Basic Premium Plan',
        'features': [
          'Up to 50 times Recipe Customization and Preview Dishes',
          'Free Fridge Organizer',
        ],
        'price': '\$ 4.99/month',
      },
      {
        'title': 'Enjoy My Premium',
        'subtitle': 'Upgraded Premium Plan',
        'features': [
          'Unlimited times Recipe Customization and Preview Dishes',
          'Get Access to RiceBucket Meal Plan',
          'Free Fridge Organizer',
        ],
        'price': '\$ 8.99/month',
      },
      {
        'title': "Let's Save Together",
        'subtitle': 'Family Premium Plan',
        'features': [
          'Share Plan with up to 4 People',
          'Unlimited times Recipe Customization and Preview Dishes',
          'Get Access to RiceBucket Meal Plan',
          'Free Fridge Organizer',
        ],
        'price': '\$ 12.99/month',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Plan'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: preview(),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.01),
                scrollDirection: Axis.horizontal,
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  return PlanCard(plan: plans[index]);
                },
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: TextButton(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "You don't have to buy any purchase for testing.",
                        style:
                            TextStyle(fontFamily: "Outfit", fontSize: 14.fSize),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontFamily: "Outfit",
                                  fontSize: 12.fSize,
                                  color: appTheme.black900),
                            ))
                      ],
                    );
                  },
                ),
              },
              child: Text(
                "Buy Subscription",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: appTheme.green_primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  const PlanCard({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      elevation: 4.0,
      child: Container(
        width: screenWidth * 0.65,
        // Set a fixed width for each card
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan['title'],
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              plan['subtitle'],
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            Divider(height: screenHeight * 0.02),
            ...plan['features']
                .map<Widget>((feature) => Padding(
                    child: Text('✓  $feature'),
                    padding: EdgeInsets.only(bottom: 8.0)))
                .toList(),
            Spacer(),
            Text(
              plan['price'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: appTheme.orange_primary,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     padding: EdgeInsets.all(12),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //   ),
            //   child: Text(
            //     'Choose Plan',
            //     style: TextStyle(fontSize: 14.0, color: Colors.black54),
            //   ),
            //   onPressed: () => {},
            // ),
          ],
        ),
      ),
    );
  }
}
