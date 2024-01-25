import 'package:flutter/foundation.dart';

class SavingsModel extends ChangeNotifier {
  int _savingCo2 = 0;
  int _savingDollar = 0;

  int get savingCo2 => _savingCo2;
  int get savingDollar => _savingDollar;

  void incrementSavings(int co2, int dollar) {
    _savingCo2 += co2;
    _savingDollar += dollar;
    notifyListeners();
  }
}
