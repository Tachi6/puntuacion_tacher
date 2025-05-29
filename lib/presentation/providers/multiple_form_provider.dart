import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/infrastructure/datasources/multiple_firebase_datasource.dart';
import 'package:puntuacion_tacher/infrastructure/repositories/multiple_repository_impl.dart';
import 'package:puntuacion_tacher/models/wines.dart';
import 'package:puntuacion_tacher/screens/screens.dart';

class MultipleFormProvider extends ChangeNotifier {

  final MultipleRepositoryImpl multipleRepositoryImpl = MultipleRepositoryImpl(MultipleFirebaseDatasource());

  String _name = '';
  String _description = '';
  String? _password;
  bool _hidden = false;
  String? _dateLimit;
  String? _tasteQuiz;
  final List<String> _wineSequence = [];
  final Map<String, AverageRatings> _averageRatings = {};

  final Map<String, bool> _winesHasEmptyFields = {};
  bool _isBottomSheetOpen = false;
  String _hintName = 'Nombre de la cata';

  String get name => _name; 
  String get description => _description;
  String? get password => _password;
  bool get hidden => _hidden;
  String? get dateLimit => _dateLimit;
  String? get tasteQuiz => _tasteQuiz;
  List<String> get wineSequence => _wineSequence;
  bool get isBottomSheetOpen => _isBottomSheetOpen;
  String get hintName => _hintName;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set description(String descripction) {
    _description = descripction;
    notifyListeners();
  }

  set password(String? password) {
    _password = password;
    notifyListeners();
  }

  set dateLimit(String? dateLimit) {
    _dateLimit = dateLimit;
    notifyListeners();
  }

  set hintName(String hintName) {
    _hintName = hintName;
    notifyListeners();
  }

  Future<Multiple> createMultipleTaste() async {

    for (String wineId in _wineSequence) {
      _averageRatings[wineId] = AverageRatings(
        boca: -1,
        nariz: -1,
        puntos: -1,
        vista: -1
      );
    }
    notifyListeners();

    final newMultipleTaste = Multiple(
      name: _name,
      description: _description,
      password: _password,
      hidden: _hidden,
      dateLimit: _dateLimit,
      tasteQuiz: _tasteQuiz,
      wineSequence: _wineSequence,
      averageRatings: _averageRatings,
    );

    return await multipleRepositoryImpl.createMultipleTaste(newMultipleTaste);
  }

  bool addMultipleWine(Wines wine, BuildContext context) {
    if (_wineSequence.any((id) => id == wine.id)) return false;

    _wineSequence.add(wine.id!);
    _winesHasEmptyFields[wine.id!] = wineWithEmptyFields(wine);

    notifyListeners();
    needBottomSheet(context);

    return true;
  }

  void removeMultipleWine(String wineId, BuildContext context) {
    _wineSequence.removeWhere((id) => id == wineId);
    _winesHasEmptyFields.remove(wineId);

    notifyListeners();
    needBottomSheet(context);
  }

  void moveMultipleWine(int oldIndex, int newIndex) {
    final wineId = _wineSequence[oldIndex];
    _wineSequence.removeAt(oldIndex);
    _wineSequence.insert(newIndex, wineId);

    notifyListeners();
  }

  void clearMultipleWines(BuildContext context) {
    _wineSequence.clear();
    _winesHasEmptyFields.clear();

    notifyListeners();
    needBottomSheet(context);
  }

  void needBottomSheet(BuildContext context) {
    if (wineSequence.length > 1 && !isBottomSheetOpen) {
      Scaffold.of(context).showBottomSheet((BuildContext context) => const SafeArea(child: MultipleActionsButtons()));
      _isBottomSheetOpen = true;
      notifyListeners();
    }
    if (wineSequence.length < 2 && isBottomSheetOpen) {
      Navigator.pop(context);
      _isBottomSheetOpen = false;
      notifyListeners();
    }
  }

  void editTasteQuiz({bool? simpleQuiz, bool? advancedQuiz}) {
    if (simpleQuiz != null && simpleQuiz) {
      _tasteQuiz = 'simple';
      notifyListeners();
      return;
    }
    if (simpleQuiz != null && !simpleQuiz) {
      _tasteQuiz = null;
      notifyListeners();
      return;
    }
    if (advancedQuiz != null && advancedQuiz) {
      _tasteQuiz = 'advanced';
      notifyListeners();
      return;
    }
    if (advancedQuiz != null && !advancedQuiz) {
      _tasteQuiz = null;
      notifyListeners();
      return;
    }
  }

  void hideTasteWines() {
    _hidden = !_hidden;
    notifyListeners();
  }

  bool wineWithEmptyFields(Wines wine) {
    final List<bool> hasEmptyField = [];

    if (wine.variedades.trim() == '') hasEmptyField.add(true);
    if (wine.graduacion.trim() == '') hasEmptyField.add(true);
    if (wine.notaVista.trim() == '') hasEmptyField.add(true);
    if (wine.notaNariz.trim() == '') hasEmptyField.add(true);
    if (wine.notaBoca.trim() == '') hasEmptyField.add(true);

    return hasEmptyField.contains(true);
  }

  bool isNotReadyForQuiz() { // TODO: hacer funcionar, poder editar vino
    if (tasteQuiz == null) return false;
    return _winesHasEmptyFields.values.contains(true);
  }

  String? isValidMultiple() {
    if (description.isEmpty) return 'La descripción de la cata es obligatoria.';
    if (description.trim().length < 10) return 'La descripción de la cata es muy corta.';
    if (wineSequence.length < 2) return 'Se necesitan al menos 2 vinos para la cata.';
    if (isNotReadyForQuiz()) return 'Falta información de los vinos para el quiz';
    return null;
  }
}