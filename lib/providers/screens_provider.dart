import 'package:flutter/material.dart';

class ScreensProvider extends ChangeNotifier {

  int _currentScreen = 0;
  
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  int get currentScreen => _currentScreen;

  set currentScreen(int screen) {
    _currentScreen = screen;
    notifyListeners();
  }
}