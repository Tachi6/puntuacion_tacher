
import 'package:flutter/material.dart';
import 'package:puntuacion_tacher/models/wines.dart';

class MultipleTasteProvider extends ChangeNotifier {

  String _multipleName = '';
  bool _hidden = false;
  int _winesHiddenNumber = 0;
  final List<Wines> winesMultipleTaste = [];
  DateTime? _dateLimit;
  String? _description;
  String? _password;

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
    text: 'Sin limite',
  );

  void addWine(Wines wine) {
    winesMultipleTaste.add(wine);
    notifyListeners();
  }

  void addHiddenWines() {
    for (var i = 1; i <= _winesHiddenNumber; i++) {
      winesMultipleTaste.add(
        Wines(
          id: '-1', 
          anada: -1, 
          bodega: '', 
          comentarios: [], 
          descripcion: '', 
          fechas: [], 
          graduacion: '', 
          nombre: 'Vino a catar a ciegas $i', 
          notaBoca: '', 
          notaNariz: '', 
          notaVista: '', 
          notasBoca: [], 
          notasNariz: [], 
          notasVista: [], 
          puntuacionBoca: -1, 
          puntuacionFinal: -1, 
          puntuacionNariz: -1, 
          puntuacionVista: -1, 
          puntuaciones: [], 
          puntuacionesBoca: [], 
          puntuacionesNariz: [], 
          puntuacionesVista: [], 
          region: '', 
          tipo: '', 
          usuarios: [], 
          variedades: '', 
          vino: '',
        )
      );
    }
  }

  void removeWine(Wines wine) {
    winesMultipleTaste.remove(wine);
    notifyListeners();
  }

  void clearWines() {
    winesMultipleTaste.clear();
    notifyListeners();
  }

  void hideWine(int index) {
    if (winesMultipleTaste[index].nombre.contains('Vino a catar a ciegas')) {
      winesMultipleTaste[index].nombre = '${winesMultipleTaste[index].vino} ${winesMultipleTaste[index].anada.toString()}';
    }
    else {
      winesMultipleTaste[index].nombre = 'Vino a catar a ciegas $index';
    }
    notifyListeners();
  }

  String get multipleName => _multipleName;

  set multiplename(String name) {
    _multipleName = name;
    notifyListeners();
  }
  
  bool get hidden {
    return _hidden;
  }

  set hidden(bool value) {
    _hidden = value;
    notifyListeners();
  }

  String? get password {
    return _password;
  }

  set password(String? value) {
    _password = value;
    notifyListeners();
  }

  String? get decription {
    return _description;
  }

  set decription(String? value) {
    _description = value;
    notifyListeners();
  }

  DateTime? get dateLimit {
    return _dateLimit;
  }

  set dateLimit(DateTime? value) {
    _dateLimit = value;
    notifyListeners();
  }

  int get winesHiddenNumber {
    return _winesHiddenNumber;
  }

  set winesHiddenNumber(int value) {
    _winesHiddenNumber = value;
    notifyListeners();
  }

  void resetSettings() {
    // multiplename = ''; // TODO al hacer back dejar nombre o no???
    hidden = false;
    winesHiddenNumber = 0;
    winesMultipleTaste.clear();
    notifyListeners();
  }


}