
import 'package:flutter/material.dart';

class ScreensProvider extends ChangeNotifier {

  int currentScreen = 0;

  currentScreenChange(int index) {
    currentScreen = index;
    notifyListeners();
  }


}