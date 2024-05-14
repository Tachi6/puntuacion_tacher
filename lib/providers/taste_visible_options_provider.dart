
import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/widgets/widgets.dart';

class VisibleOptionsProvider extends ChangeNotifier {

  TasteOptions _taste = TasteOptions.empty;
  TasteOptionsNormal _tasteNormal = TasteOptionsNormal.empty;
  TasteOptionsMultiple _tasteMultiple = TasteOptionsMultiple.empty;
  // TODO refactorizar el aparecer/desaparecer widgets
  bool _showSecondWidget = false;
  bool _showThirdWidget = false;
  bool _showContinueButton = false;

  TasteOptions get taste {
    return _taste;
  }

  set taste(TasteOptions value) {
    _taste = value;
    _tasteNormal = TasteOptionsNormal.empty;
    _tasteMultiple = TasteOptionsMultiple.empty;
    _showSecondWidget = true;
    _showThirdWidget = false;
    _showContinueButton = false;

    notifyListeners();
  }

  TasteOptionsNormal get tasteNormal {
    return _tasteNormal;
  }

  set tasteNormal(TasteOptionsNormal value) {
    _tasteNormal = value;
    if (_showThirdWidget != true) {
      _showThirdWidget = true;
      _showContinueButton = false;
    }
    notifyListeners();
  }

  TasteOptionsMultiple get tasteMultiple {
    return _tasteMultiple;
  }

  set tasteMultiple(TasteOptionsMultiple value) {
    _tasteMultiple = value;
    if (_showThirdWidget != true) {
      _showThirdWidget = true;
    }
    notifyListeners();
  }

  bool get showThirdWidget {
    return _showThirdWidget;
  }

  set showThirdWidget(bool value) {
    _showThirdWidget = value;

    notifyListeners();
  }


  bool get showSecondWidget {
    return _showSecondWidget;
  }

  set showSecondWidget(bool value) {
    _showSecondWidget = value;

    notifyListeners();
  }

  bool get showContinueButton {
    return _showContinueButton;
  }

  set showContinueButton(bool value) {
    _showContinueButton = value;

    notifyListeners();
  }

  void clearWidgets() {
    _taste = TasteOptions.empty;
    _tasteNormal = TasteOptionsNormal.empty;
    _tasteMultiple = TasteOptionsMultiple.empty;
    _showSecondWidget = false;
    _showThirdWidget = false;
    _showContinueButton = false;

    notifyListeners();
  }

}