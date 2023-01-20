import 'package:flutter/foundation.dart';

class SwitchTimer extends ChangeNotifier {
  int _remainingTime = 30;

  int getRemainingTime() {
    return _remainingTime;
  }

  void reset(){
    _remainingTime = 30;

  }
  updateRemainingTime() {
    _remainingTime--;
    notifyListeners();
  }
}
