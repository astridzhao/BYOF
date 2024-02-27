import 'dart:typed_data';

import 'package:astridzhao_s_food_app/Interface/homepage_screen/homepage-container.dart';
import 'package:astridzhao_s_food_app/Interface/user_profile/userInfo_provider.dart';
import 'package:astridzhao_s_food_app/Interface/user_profile/usersetting-screen.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/resources/firebasestore.dart';
import 'package:astridzhao_s_food_app/user.dart';
import 'package:astridzhao_s_food_app/widgets/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserInitialSetting extends StatefulWidget {
  static String id = 'signup_createuser';
  @override
  _UserInitialSettingState createState() => _UserInitialSettingState();
}

class _UserInitialSettingState extends State<UserInitialSetting> {
  TextEditingController nameController = TextEditingController();
  Uint8List? finalImage;
  String? imageURL;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  Future<void> fetchUserProfileImageUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(user.uid)
          .get();
      if (docSnapshot.exists) {
        setState(() {
          imageURL = docSnapshot.data()?['image'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.02,
              ),
              FutureBuilder<UserModel?>(
                future: getCurrentUserModel(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return displayUserInformation(context, snapshot);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUserName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(name);
        Provider.of<UserInformationProvider>(context, listen: false)
            .fetchCurrentUserModel();

        await user.reload();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to update profile. Please try again.")),
        );
      }
    }
  }

  Widget displayUserInformation(context, snapshot) {
    final user = snapshot.data;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget displayImage() {
      return const CircleAvatar(
          radius: 80,
          backgroundColor: Colors.lightGreen,
          backgroundImage: AssetImage("assets/images/chief.png"));
    }

    void saveProfile() async {
      updateUserName(nameController.text);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        print("[FirebaseAuth] userId: $userId");
        String message =
            await Storedata(userId).createUser(name: nameController.text);
        // Handle the message (success or error) appropriately
        print("from storedata: $message");
      } else {
        // Handle the case where no user is signed in
        print("No user is signed in");
      }
    }

    return Column(children: <Widget>[
      displayImage(),
      SizedBox(
        height: screenHeight * 0.05,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        alignment: Alignment.center,
        child: Column(
          children: [
            buildTextField("User Name", "${user.name ?? ''}", true),
            buildTextField("E-mail", "${user.email ?? ''}", false),
            SizedBox(
              height: screenHeight * 0.02,
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            onPressed: () async {
              saveProfile();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          HomepageContainerScreen()),
                  (route) => false);
            },
            child: Text(
              "Proceed to Home",
              style: TextStyle(
                  fontSize: 14, letterSpacing: 2.2, color: Colors.black),
            ),
          )
        ],
      ),
    ]);
  }

  Widget buildTextField(String labelText, String placeholder, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: isEditable ? nameController : null,
        readOnly: !isEditable,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a user name.';
          }
          return null;
        },
        decoration: InputDecoration(
            suffixIcon: isEditable
                ? IconButton(
                    onPressed: () {
                      if (nameController.text.trim().isNotEmpty) {
                        updateUserName(nameController.text.trim());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Name cannot be empty.")),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.black45,
            )),
      ),
    );
  }
}
