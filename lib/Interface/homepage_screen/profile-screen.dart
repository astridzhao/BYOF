import 'package:astridzhao_s_food_app/Interface/homepage_screen/usersetting-screen.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current user's name, if available
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      nameController.text = user.displayName!;
    } // Get current user details
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: appTheme.green_primary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
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
        print("User name updated successfully");

        await user.reload();
        // Access the updated user object
        final updatedUser = FirebaseAuth.instance.currentUser;
        // This should now print the updated name // Reload the user to refresh the user's profile data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully!")),
        );
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
    print("user name: " + user.name);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(children: <Widget>[
      Container(
        width: screenHeight * 0.2,
        height: screenHeight * 0.3,
        decoration: BoxDecoration(
          border: Border.all(
              width: 4, color: Theme.of(context).scaffoldBackgroundColor),
          boxShadow: [
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 10))
          ],
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/images/chief.png")),
        ),
      ),
      Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 4,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          color: appTheme.orange_primary,
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      SizedBox(
        height: screenHeight * 0.05,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        alignment: Alignment.center,
        child: Column(
          children: [
            buildTextField("User Name", "${user.name ?? 'Anonymous'}", true),
            buildTextField("E-mail", "${user.email ?? 'Anonymous'}", false),
            SizedBox(
              height: screenHeight * 0.02,
            ),
          ],
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // OutlinedButton(
          //   onPressed: () {},
          //   child: Text("CANCEL",
          //       style: TextStyle(
          //           fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
          // ),
          OutlinedButton(
            onPressed: () {
              print("what I input is " + nameController.text);
              updateUserName(nameController.text);
            },
            child: Text(
              "SAVE",
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
      child: TextField(
        controller: isEditable ? nameController : null,
        readOnly: !isEditable,
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
