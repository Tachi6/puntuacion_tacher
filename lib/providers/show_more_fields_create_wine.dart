import 'package:flutter/material.dart';

class ShowMoreFieldsCreateWine extends ChangeNotifier {

  bool _showMoreFieldsCreateWine = false;
  final ScrollController autocompleteScrollController = ScrollController(initialScrollOffset: 0);

  set showMoreFieldsCreateWine(bool value) {
    _showMoreFieldsCreateWine = value;
        notifyListeners();
  }

  bool get showMoreFieldsCreateWine {
    return _showMoreFieldsCreateWine;
  }

  void moceScrollToBottom() {
    autocompleteScrollController.jumpTo(0);
    notifyListeners();
  }
}