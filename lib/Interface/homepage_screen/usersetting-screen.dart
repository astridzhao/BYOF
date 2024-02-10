import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage-container.dart';
import 'package:astridzhao_s_food_app/Interface/homepage_screen/profile-screen.dart';
import 'package:astridzhao_s_food_app/Interface/onboarding/Signin/Signup/sign_in_email_screen.dart';
import 'package:astridzhao_s_food_app/bloc/authentication_bloc.dart';
import 'package:astridzhao_s_food_app/theme/theme_helper.dart';
import 'package:astridzhao_s_food_app/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => HomepageContainerScreen()),
              (Route<dynamic> route) => false, // Remove all routes below
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: appTheme.green_primary,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
        child: ListView(
          children: [
            FutureBuilder<UserModel?>(
              future: getCurrentUserModel(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  String name = snapshot.data?.name ?? "";
                  return Text("Hi! ${name}",
                      style: TextStyle(
                          fontFamily: "Outfit",
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.bold));
                } else {
                  return Text("no name");
                }
              },
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  color: appTheme.green_primary,
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => EditProfilePage()));
                  },
                  child: Text(
                    "My Account",
                    style: TextStyle(
                        fontFamily: "Outfit",
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.012,
            ),
            buildAccountOptionRow(context, "Change password"),
            buildAccountOptionRow(context, "Content settings"),
            buildAccountOptionRow(context, "Social"),
            buildAccountOptionRow(context, "Language"),
            buildAccountOptionRow(context, "Privacy and security"),
            SizedBox(
              height: 40,
            ),
            BlocConsumer<AuthenticationBloc, AuthenticationState>(
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
                    backgroundColor: MaterialStateProperty.all<Color>(
                        appTheme.yellow_primary),
                    fixedSize: MaterialStateProperty.all<Size>(
                        Size(screenWidth * 0.3, screenHeight * 0.05)),
                  ),
                  child: const Text('Log Out',
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                );
              },
            ),
            IconButton(
                onPressed: () {
                  // deleteUser();
                },
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 30,
                ))
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete();
        print("User deleted successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User deleted successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete user. Please try again.")),
        );
      }
    }
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
