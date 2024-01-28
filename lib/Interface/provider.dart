import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingsModel extends ChangeNotifier {
  static final String savingCo2Key = "savingCo2";
  static String savingDollarKey = "savingDollar";

  final SharedPreferences prefs;
  int _savingCo2;
  int _savingDollar;

  SavingsModel({required this.prefs}) : _savingCo2 = prefs.getInt(savingCo2Key) ?? 0, _savingDollar = prefs.getInt(savingDollarKey) ?? 0;

  int get savingCo2 => _savingCo2;
  int get savingDollar => _savingDollar;

  set savingCo2(int value) {
    _savingCo2 = value;
    () async {
      await prefs.setInt(savingCo2Key, _savingCo2);
    }();
    notifyListeners();
  }

  set savingDollar(int value) {
    _savingDollar = value;
    () async {
      await prefs.setInt(savingDollarKey, _savingDollar);
    }();
    notifyListeners();
  }
}
