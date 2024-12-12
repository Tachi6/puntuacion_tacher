import 'package:flutter/material.dart';

class ScreenElementsSizeProvider extends ChangeNotifier {

  double _bottomElementHeight = 0;

  double get bottomElementHeight => _bottomElementHeight;

  set bottomElementHeight(double value) {
    _bottomElementHeight = value;
    notifyListeners();
  }
}