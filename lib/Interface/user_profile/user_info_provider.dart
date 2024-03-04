import 'package:astridzhao_s_food_app/user.dart';
import 'package:flutter/material.dart';

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
