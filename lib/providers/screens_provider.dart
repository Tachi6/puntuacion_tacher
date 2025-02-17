import 'package:flutter/material.dart';

class ScreensProvider extends ChangeNotifier {

  int _currentScreen = 0;
  int _multiplePage = 0;
  
  int get currentScreen => _currentScreen;

  set currentScreen(int screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  int get multiplePage => _multiplePage;

  set multiplePage(int screen) {
    _multiplePage = screen;
    notifyListeners();
  }
}