import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecuritySetting extends StatefulWidget {
  @override
  _SecuritySettingState createState() => _SecuritySettingState();
}

class _SecuritySettingState extends State<SecuritySetting> {
  bool showPassword = false;
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with current user's name, if available
    final user = FirebaseAuth.instance.currentUser;
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text('Security Setting'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !showPassword,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: !showPassword,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.2, vertical: 30),
                      backgroundColor: appTheme.green_primary,
                    ),
                    child: Text(
                      'Save Password',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        )));
  }
}
