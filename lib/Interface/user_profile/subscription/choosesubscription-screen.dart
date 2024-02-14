import 'package:astridzhao_s_food_app/constant.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:astridzhao_s_food_app/Interface/user_profile/subscription/revenuecat-payment.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  SubscriptionPageState createState() => SubscriptionPageState();
}

class SubscriptionPageState extends State<SubscriptionPage> {
  bool _isLoading = false;
  void perfomMagic() async {
    setState(() {
      _isLoading = true;
    });

    CustomerInfo customerInfo = await Purchases.getCustomerInfo();

    if (customerInfo.entitlements.all[entitlementId] != null &&
        customerInfo.entitlements.all[entitlementId]?.isActive == true) {
      // appData.currentData = WeatherData.generateData();

      setState(() {
        _isLoading = false;
      });
    } else {
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        String? error = e.message;
        await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    title: Text("Error"),
                    content: Container(child: Text(error!)),
                    actions: [
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context, false), // passing false
                        child: Text('No'),
                      ),
                    ]));
      }

      setState(() {
        _isLoading = false;
      });

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
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
      }
    }
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
          'Up to 50 times Recipe Customization',
          'Preview Dishes',
          'Free Fridge Organizer',
        ],
        'price': '\$ 4.99/month',
      },
      {
        'title': 'Enjoy My Premium',
        'subtitle': 'Upgraded Premium Plan',
        'features': [
          'Advanced classroom features',
          'Additional set of tools',
          'Good quality student leads',
          'Customized dashboard',
          '24/7 chat/call assistance',
        ],
        'price': '\$ 8.99/month',
      },
      {
        'title': "Let's Save Together",
        'subtitle': 'Family Premium Plan',
        'features': [
          'Advanced classroom features',
          'Additional set of tools',
          'Good quality student leads',
          'Customized dashboard',
          '24/7 chat/call assistance',
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
            padding: const EdgeInsets.only(bottom: 30.0),
            child: TextButton(
              onPressed: () => perfomMagic(),
              child: Text(
                "Buy Subscription",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                color: appTheme.green_primary,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Choose Plan',
                style: TextStyle(fontSize: 14.0, color: Colors.black54),
              ),
              onPressed: () => (),
            ),
          ],
        ),
      ),
    );
  }
}
