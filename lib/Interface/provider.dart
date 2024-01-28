import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingsModel extends ChangeNotifier {
  static String savingCo2Key = "savingCo2";
  static String savingDollarKey = "savingDollar";

  final SharedPreferences prefs;
  double _savingCo2;
  double _savingDollar;

  SavingsModel({required this.prefs})
      : _savingCo2 = prefs.getDouble(savingCo2Key) ?? 0,
        _savingDollar = prefs.getDouble(savingDollarKey) ?? 0;

  double get savingCo2 => _savingCo2;
  double get savingDollar => _savingDollar;

  set savingCo2(double value) {
    _savingCo2 = value;
    () async {
      await prefs.setDouble(savingCo2Key, _savingCo2);
    }();
    notifyListeners();
  }

  set savingDollar(double value) {
    _savingDollar = value;
    () async {
      await prefs.setDouble(savingDollarKey, _savingDollar);
    }();
    notifyListeners();
  }
}
