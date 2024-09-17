import 'package:flutter/material.dart';

class ScreensProvider extends ChangeNotifier {

  int currentScreen = 0;
  final PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  currentScreenChange(int index) {
    currentScreen = index;
    pageController.animateToPage(
      index, 
      duration: const Duration(milliseconds: 300), 
      curve: Curves.easeInOut
    );
    notifyListeners();
  }


}