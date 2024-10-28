import 'package:flutter/material.dart';

class ScreensProvider extends ChangeNotifier {

  int _currentScreen = 0;
  int _multipleScreen = 0;
  
  int get currentScreen => _currentScreen;

  set currentScreen(int screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  int get multipleScreen => _multipleScreen;

  set multipleScreen(int screen) {
    _multipleScreen = screen;
    notifyListeners();
  }
}