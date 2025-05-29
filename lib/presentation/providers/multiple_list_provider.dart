import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/infrastructure/datasources/multiple_firebase_datasource.dart';
import 'package:puntuacion_tacher/infrastructure/repositories/multiple_repository_impl.dart';

class MultipleListProvider extends ChangeNotifier {

  List<Multiple> _multipleList = [];
  Multiple? _selectedMultiple;

  final MultipleRepositoryImpl multipleRepositoryImpl = MultipleRepositoryImpl(MultipleFirebaseDatasource());
  
  List<Multiple> get multipleList => _multipleList;
  Multiple? get selectedMultiple => _selectedMultiple;

  set selectedMultiple(Multiple? multiple) {
    _selectedMultiple = multiple;
    notifyListeners();
  }  

  Future<void> loadMultiple() async {
    _multipleList = await multipleRepositoryImpl.loadAllMultipleTaste();
    notifyListeners();
  }

  void addMultipleToList(Multiple multiple) {
    _multipleList = [..._multipleList, multiple]; // TODO: no se si pasarlo por referencia o no...
    notifyListeners();
  }



}