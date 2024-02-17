import 'dart:typed_data';

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

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class UserInformationProvider with ChangeNotifier {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  Future<void> fetchCurrentUserModel() async {
    _userModel =
        await getCurrentUserModel(); // Your existing method to fetch user data
    notifyListeners();
  }

  void updateUserModel(UserModel newUserModel) {
    _userModel = newUserModel;
    notifyListeners();
  }
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  TextEditingController nameController = TextEditingController();
  Uint8List? finalImage;

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
      final user = FirebaseAuth.instance.currentUser;
      String imageURL;
      // Use FutureBuilder to wait for the async operation to complete
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('userProfile')
            .doc(user!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            // Data fetched successfully, get the image URL
            final data = snapshot.data!.data() as Map<String, dynamic>?;
            String? imageURL = data?['image'];
            return finalImage != null
                ? CircleAvatar(
                    radius: 80,
                    backgroundColor: appTheme.orange_primary,
                    backgroundImage: MemoryImage(finalImage!))
                : imageURL != null
                    ? CircleAvatar(
                        radius: 80,
                        backgroundColor: appTheme.orange_primary,
                        backgroundImage: NetworkImage(imageURL))
                    : const CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.lightGreen,
                        backgroundImage: AssetImage("assets/images/chief.png"));
          } else if (snapshot.hasError) {
            // Handle error state
            print("Error fetching user profile image: ${snapshot.error}");
            // Optionally, show a default avatar or an error icon
          }

          // While data is loading, show the selected image or a default image
          return finalImage != null
              ? CircleAvatar(
                  radius: 80,
                  backgroundColor: appTheme.orange_primary,
                  backgroundImage: MemoryImage(finalImage!))
              : const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.lightGreen,
                  backgroundImage: AssetImage("assets/images/chief.png"));
        },
      );
    }

    //   if (user != null) {

    //     DocumentReference userProfileDoc =
    //         firestore.collection('userProfile').doc(user.uid);
    //     userProfileDoc.get().then(
    //       (DocumentSnapshot doc) {
    //         final data = doc.data() as Map<String, dynamic>;
    //         imageURL = data['image'];
    //       },
    //       onError: (e) => print("Error getting document: $e"),
    //     );
    //   }

    //   return imageURL != null
    //       ? CircleAvatar(
    //           radius: 80,
    //           backgroundColor: appTheme.orange_primary,
    //           backgroundImage: NetworkImage(imageURL))
    //       : finalImage != null
    //           ? CircleAvatar(
    //               radius: 80,
    //               backgroundColor: appTheme.orange_primary,
    //               backgroundImage: MemoryImage(finalImage!))
    //           : const CircleAvatar(
    //               radius: 80,
    //               backgroundColor: Colors.lightGreen,
    //               backgroundImage: AssetImage("assets/images/chief.png"));
    // }

    Future<void> uploadImage() async {
      Uint8List image = await PickImage(ImageSource.gallery);
      setState(() {
        finalImage = image;
      });
    }

    Widget changeProfilePic() {
      return Container(
          height: 50,
          width: 50,
          child: IconButton(
            icon: Icon(Icons.add_a_photo),
            color: Colors.black87,
            onPressed: () => uploadImage(),
          ));
    }

    void saveProfile() async {
      updateUserName(nameController.text);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        print("[FirebaseAuth] userId: $userId");
        String message = await Storedata(userId).createUserDocument(
            name: nameController.text, image: finalImage ?? Uint8List(0));

        // // This should now print the updated name // Reload the user to refresh the user's profile data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Profile updated successfully!"),
              duration: Duration(seconds: 2)),
        );
        // Handle the message (success or error) appropriately
        print("from storedata: $message");
      } else {
        // Handle the case where no user is signed in
        print("No user is signed in");
      }
    }

    return Column(children: <Widget>[
      displayImage(),
      changeProfilePic(),
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
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                // user.updateDisplayName(nameController.text);
                saveProfile();
              }
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
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.black45,
            )),
      ),
    );
  }
}
