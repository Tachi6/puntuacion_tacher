
import 'package:flutter/material.dart';

class MultipleTasteProvider extends ChangeNotifier {

  
  bool _multiple = false;
  bool _hidden = false;
  int winesHiddenNumber = 2;
  int winesNumber = 2;

  bool get multiple {
    return _multiple;
  }

  set multiple(bool value) {
    _multiple = value;
    notifyListeners();
  }

  
  bool get hidden {
    return _hidden;
  }

  set hidden(bool value) {
    _hidden = value;
    notifyListeners();
  }

}