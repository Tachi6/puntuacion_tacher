import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/infrastructure/datasources/multiple_firebase_datasource.dart';
import 'package:puntuacion_tacher/infrastructure/repositories/multiple_repository_impl.dart';

class MultipleListProvider extends ChangeNotifier {

  List<MultipleNew> _multipleList = [];
  MultipleNew? _selectedMultiple;

  final MultipleRepositoryImpl multipleRepositoryImpl = MultipleRepositoryImpl(MultipleFirebaseDatasource());
  
  List<MultipleNew> get multipleList => _multipleList;
  MultipleNew? get selectedMultiple => _selectedMultiple;

  set selectedMultiple(MultipleNew? multiple) {
    _selectedMultiple = multiple;
    notifyListeners();
  }  

  Future<void> loadMultiple() async {
    _multipleList = await multipleRepositoryImpl.loadAllMultipleTaste();
    notifyListeners();
  }

  void addMultipleToList(MultipleNew multiple) {
    _multipleList = [..._multipleList, multiple]; // TODO: no se si pasarlo por referencia o no...
    notifyListeners();
  }



}