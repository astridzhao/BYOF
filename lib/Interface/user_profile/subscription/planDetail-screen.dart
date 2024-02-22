import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/resources/firebasestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';

class PlanDetailPage extends StatefulWidget {
  const PlanDetailPage({Key? key}) : super(key: key);

  PlanDetailPageState createState() => PlanDetailPageState();
}

class PlanDetailPageState extends State<PlanDetailPage> {
  User? user = FirebaseAuth.instance.currentUser;
  late Storedata storedata;
  String displayPlan = "Basic Plan";
  String displayStatus = "Checking...";
  dynamic displayExpirationDate = null;

  // Initialize the TapGestureRecognizer
  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer()
    ..onTap = () {
      // TODO: Handle the tap event for "click here"
      print('Clicked "click here"');
    };

  @override
  void initState() {
    super.initState();
    storedata = Storedata(user!.uid);
    _fetchSubscriptionStatus();
  }

  Future<void> _fetchSubscriptionStatus() async {
    try {
      Map<String, dynamic> subscriptionInfo =
          await storedata.getSubscriptionInfo();
      String plan = subscriptionInfo['plan'];
      dynamic date = subscriptionInfo['expirationDate'];
      bool? renewalStatus = subscriptionInfo['renewalStatus'];
      log("plan: $plan");
      debugPrint("plan: $plan");
      log("expirationDate: $date");
      log("renewalStatus: $renewalStatus");

      String status = "Inactive";

      if (plan == "Basic Plan") {
        date = DateTime.utc(2030, 1, 1);
        status = "Active";
      } else if (renewalStatus == true &&
          date != null &&
          date.isAfter(DateTime.now())) {
        status = "Active";
      }

      setState(() {
        displayPlan = plan;
        displayStatus = status;
        displayExpirationDate = date;
      });
      print("status: $displayStatus");
    } catch (e) {
      print("Error fetching subscription status: $e");
      setState(() {
        displayPlan = "Error";
        displayStatus = "Error";
        displayExpirationDate = null;
      });
    }
  }

  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      title: Text(
        "Plan Detail",
        style: TextStyle(
          color: Colors.black,
          // fontSize: 20,
          fontFamily: 'Outfit',
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          // color:
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget eachSection(
      BuildContext context, String title, IconData icon, dynamic subtitle) {
    return ListTile(
      leading: Icon(
        icon,
        color: appTheme.green_primary,
      ),
      title: Text(
        title,
        style: TextStyle(
            fontFamily: "Outfit",
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.normal),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            fontFamily: "Outfit",
            color: Colors.black87,
            fontWeight: FontWeight.normal),
      ),
      onTap: () {
        if (title == "Cancel Subscription") {
          Fluttertoast.showToast(
              msg:
                  "You can cancel your subscription from the Apple settings page.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: appTheme.green_primary,
              textColor: Colors.white,
              fontSize: 14.fSize);
        }
      },
    );
  }

  Widget sectionHeader(BuildContext context, String title) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: screenWidth * 0.03,
        ),
        Text(
          title,
          style: TextStyle(
              fontFamily: "Outfit",
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget deleteAccount(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          // Base text style
          fontFamily: "Outfit",
          color: Colors.black54,
          fontSize: 12,
        ),
        children: <TextSpan>[
          TextSpan(
            text:
                "To close your account yourself and delete your data permanently, ",
          ),
          TextSpan(
            text: "click here",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: _tapGestureRecognizer,
          ),
          TextSpan(
            text: ".",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: screenHeight * 0.02,
            ),
            eachSection(context, "My Plan", Icons.pages, displayPlan),
            sectionHeader(context, "Billing Information"),
            eachSection(context, "Next Billing Date", Icons.calendar_today,
                displayExpirationDate.toString()),
            eachSection(
                context, "Renewable Status", Icons.check_circle, displayStatus),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            sectionHeader(context, "My Subscription"),
            eachSection(context, "Cancel Subscription", Icons.description,
                "cancel today :("),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            deleteAccount(context),
          ],
        ),
      ),
    );
  }
}
