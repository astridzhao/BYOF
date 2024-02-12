import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage-container.dart';
import 'package:astridzhao_s_food_app/Interface/user_profile/choosesubscription-screen.dart';
import 'package:astridzhao_s_food_app/Interface/user_profile/profile-screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_email_screen.dart';
import 'package:astridzhao_s_food_app/bloc/authentication_bloc.dart';
import 'package:astridzhao_s_food_app/theme/theme_helper.dart';
import 'package:astridzhao_s_food_app/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void navigation_screen(BuildContext context, Widget screen) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }

    // Widget userName() {
    //   return FutureBuilder<UserModel?>(
    //     future: getCurrentUserModel(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         String name = snapshot.data?.name ?? "";
    //         print("name: $name");
    //         return Text("${name}",
    //             style: TextStyle(
    //                 fontFamily: "Outfit",
    //                 color: Colors.black87,
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.w500));
    //       } else {
    //         return Text("no name");
    //       }
    //     },
    //   );
    // }
    Widget userName() {
      // Use Provider to listen to changes in UserInformationProvider
      return Consumer<UserInformationProvider>(
        builder: (context, userInfoProvider, child) {
          // You can call fetchCurrentUserModel if the userModel is null or whenever you want to refresh the data.
          if (userInfoProvider.userModel == null) {
            userInfoProvider
                .fetchCurrentUserModel(); // This will only fetch if data is null, adjust logic as needed.
            return CircularProgressIndicator(); // Show loading indicator while data is being fetched
          } else {
            String name = userInfoProvider.userModel?.name ?? "no name";
            print("name: $name");
            return Text("$name",
                style: TextStyle(
                    fontFamily: "Outfit",
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.w500));
          }
        },
      );
    }

    Widget userEmail() {
      return FutureBuilder<UserModel?>(
        future: getCurrentUserModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            String email = snapshot.data?.email ?? "";
            print("name: $email");
            return Text("${email}",
                style: TextStyle(
                    fontFamily: "Outfit",
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w200));
          } else {
            return Text("no name");
          }
        },
      );
    }

    Widget sectionHeader(String title) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Icon(
          //   icon,
          //   color: appTheme.green_primary,
          // ),
          SizedBox(
            width: screenWidth * 0.03,
          ),
          Text(
            title,
            style: TextStyle(
                fontFamily: "Outfit",
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )
        ],
      );
    }

    Widget eachSection(
        BuildContext context, String title, IconData icon, Widget screen) {
      return ListTile(
        leading: Icon(
          icon,
          color: appTheme.green_primary,
        ),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
      );
    }

    Widget signOutButton() {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is SignOutSuccessState) {
            // Assuming you have a state like this
            // Navigate back to the sign-in screen or another appropriate screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SignInTwoScreen()), // Adjust with your actual sign-in screen
              (Route<dynamic> route) => false,
            );
          } else if (state is SignOutFailureState) {
            // Handle sign-out failure
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Failed to sign out. Please try again.'),
                );
              },
            );
          }
        },
        builder: (context, state) {
          if (state is SignOutLoadingState) {
            print('Signing out...');
            // Show loading indicator
            return CircularProgressIndicator();
          }
          // Return the sign-out button or any other relevant widget
          return ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(SignOut());
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(appTheme.yellow_primary),
              fixedSize: MaterialStateProperty.all<Size>(
                  Size(screenWidth * 0.3, screenHeight * 0.05)),
            ),
            child: const Text('Log Out',
                style: TextStyle(fontSize: 12, color: Colors.black)),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(children: <Widget>[
        UserAccountsDrawerHeader(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          accountName: userName(),
          accountEmail: userEmail(),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/img_avatar.png'), // Replace with actual image path
          ),
          currentAccountPictureSize: Size.square(screenWidth * 0.15),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                  "assets/images/favoritescreen_background.png"), // Replace with your image path
              opacity: 0.2,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Color.fromARGB(255, 233, 240, 228),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(children: <Widget>[
              SizedBox(height: screenHeight * 0.02),
              sectionHeader("Account"),
              eachSection(context, 'Edit profile',
                  Icons.account_circle_outlined, EditProfilePage()),
              eachSection(context, 'Security', Icons.lock, EditProfilePage()),
              eachSection(
                  context, 'Privacy', Icons.privacy_tip, EditProfilePage()),
              SizedBox(height: screenHeight * 0.02),
              sectionHeader("Support & About"),
              eachSection(context, 'My Subscription',
                  Icons.subscriptions_outlined, SubscriptionPage_choosePlan()),
              eachSection(context, 'Help and Support',
                  Icons.question_mark_outlined, EditProfilePage()),
              SizedBox(height: screenHeight * 0.1),
              signOutButton(),
              SizedBox(height: screenHeight * 0.02),
            ])),
      ]),
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
