import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';

class OtherTasteProvider extends ChangeNotifier {

  WineTaste? _selectedWineTaste;
  bool _isChangingSelectedWineTaste = false;

  WineTaste? get selectedWineTaste => _selectedWineTaste;

  set selectedWineTaste(WineTaste? newWineTaste) {
    _selectedWineTaste = newWineTaste;
    notifyListeners();
  }

  bool get isChangingSelectedWineTaste => _isChangingSelectedWineTaste;

  set isChangingSelectedWineTaste(bool value) {
    _isChangingSelectedWineTaste = value;
    notifyListeners();
  }
}