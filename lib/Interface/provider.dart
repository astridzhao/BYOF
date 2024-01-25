import 'package:flutter/foundation.dart';

class SavingsModel extends ChangeNotifier {
  int _savingCo2 = 0;
  int _savingDollar = 0;

  int get savingCo2 => _savingCo2;
  int get savingDollar => _savingDollar;

  set savingCo2(int value) {
    _savingCo2 = value;
    notifyListeners();
  }

  set savingDollar(int value) {
    _savingDollar = value;
    notifyListeners();
  }
}
