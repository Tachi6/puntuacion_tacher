import 'package:flutter/material.dart';

class ScreensProvider extends ChangeNotifier {

  int _currentScreen = 0;
  
  int get currentScreen => _currentScreen;

  set currentScreen(int screen) {
    _currentScreen = screen;
    notifyListeners();
  }
}