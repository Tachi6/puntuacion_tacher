
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:puntuacion_tacher/models/models.dart';

class MultipleTasteProvider extends ChangeNotifier {

  // String _multipleName = '';
  // String? _description;
  // String? _password;
  // bool _hidden = false;
  // DateTime? _dateLimit;

  Multiple multipleTaste = Multiple(
    name: '',
    hidden: false,
    dateLimit: '',
    wines: {},
    averageRatings: AverageRatings(
      boca: -1,
      nariz: -1,
      puntos: -1,
      vista: -1
    ),
  );

  int _winesHiddenNumber = 0;
  bool _hideNames = false;
  List<Wines> winesMultipleTaste = [];
  List<WineTaste> winesTaste = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
    text: 'Sin limite',
  );

  final storage = const FlutterSecureStorage();

  // Multiple get multipleTaste => _multipleTaste;

  // set multipleTaste(Multiple multiple) {
  //   _multipleTaste = multiple;
  //   notifyListeners();
  // }

  // final Map<String, List<bool>> isValidMultiple = {
  //   'vista':[],
  //   'nariz':[],
  //   'boca':[],
  //   'puntos':[],
  // };

  // Map<String, Multiple> beginMultipleTaste = {};

  // void addMultipleTaste(Map<String, Multiple> multipleTaste) {
  //   beginMultipleTaste = multipleTaste;
  //   notifyListeners();
  // }

  // void clearMultipleTaste() {
  //   beginMultipleTaste.clear();
  //   notifyListeners();
  // }

  // final Map<String, List<dynamic>> multipleTasteValues = {
  //   'user': [],
  //   'ratingVista': [],
  //   'ratingNariz': [],
  //   'ratingBoca': [],
  //   'ratingPuntos': [],
  //   'notasVista': [],
  //   'notasNariz': [],
  //   'notasBoca': [],
  //   'comentarios': [],
  //   'puntosFinal': [],
  // };

  Future<void> initMultipleTaste() async {
    final user = await storage.read(key: 'email');

    List<WineTaste> tempWinesTaste = [];

    for (var i = 0; i < winesMultipleTaste.length; i++) {
      final WineTaste tempWineTaste = WineTaste(
        user: user!,
        id: winesMultipleTaste[i].id ?? 'Vino a ciegas $i',
        nombre: winesMultipleTaste[i].nombre,
        comentarios: '',
        fecha: 'Taste date $i',
        ratingVista: -1,
        ratingNariz: -1,
        ratingBoca: -1,
        ratingPuntos: -1,
        puntosFinal: -1,
        notasBoca: '',
        notasNariz: '',
        notasVista: '',
      );
      tempWinesTaste.add(tempWineTaste);
    }

    winesTaste = tempWinesTaste;

    notifyListeners();
  }

  void clearwinesTaste() {
    winesTaste.clear();
    notifyListeners();
  }

  // void createMultipleValues() async {
  //   for (var i = 0; i < winesMultipleTaste.length; i++) {
  //     final user = await storage.read(key: 'email');


  //     multipleTasteValues['user']!.add(user);
  //     multipleTasteValues['ratingVista']!.add(-1.0);
  //     multipleTasteValues['ratingNariz']!.add(-1.0);
  //     multipleTasteValues['ratingBoca']!.add(-1.0);
  //     multipleTasteValues['ratingPuntos']!.add(-1.0);
  //     multipleTasteValues['notasVista']!.add('');
  //     multipleTasteValues['notasNariz']!.add('');
  //     multipleTasteValues['notasBoca']!.add('');
  //     multipleTasteValues['comentarios']!.add('');
  //     multipleTasteValues['puntosFinal']!.add(-1.0);
  //   }
  //   notifyListeners();
  // }

  // void editMultipleValues(int index, String type, dynamic value) {
  //   multipleTasteValues[type]![index] = value;
  //   print(multipleTasteValues);
  //   notifyListeners();
  // }

  // void createMultipleValidation() {
  //   for (var i = 0; i < winesMultipleTaste.length; i++) {
  //     isValidMultiple.forEach((key, value) {
  //       value.add(false);
  //     },);
  //   }
  //   notifyListeners();
  // }

  // void editMultipleValidation(int index, String rating) {
  //   isValidMultiple[rating]![index] = true;
  //   notifyListeners();
  // }

  bool isValidRating() {
    final validation = [];
    for (var wineTaste in winesTaste) {
      validation.add(wineTaste.ratingVista != -1);
      validation.add(wineTaste.ratingNariz != -1);
      validation.add(wineTaste.ratingBoca != -1);
      validation.add(wineTaste.ratingPuntos != -1);
    }
    return !validation.contains(false);
  }

  void addWine(Wines wine) {
    winesMultipleTaste = [...winesMultipleTaste, wine];
    notifyListeners();
  }

  void addVisibleWines(List<Wines> wines) {
    winesMultipleTaste = wines;
    notifyListeners();
  }

  void addHiddenWines() {
    List<Wines> tempHiddenWines = [];
    for (var i = 1; i <= _winesHiddenNumber; i++) {
      final Wines hiddenWine = Wines(
        id: '',
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
      );

      tempHiddenWines.add(hiddenWine);
    }
    winesMultipleTaste = tempHiddenWines;
    notifyListeners();
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
      winesMultipleTaste[index].nombre = 'Vino a catar a ciegas ${index + 1}';
    }
    notifyListeners();
  }

  void hideAllWines() {
    if (_hideNames) {
      for (var i = 0; i < winesMultipleTaste.length; i++) {
        if (!winesMultipleTaste[i].nombre.contains('Vino a catar a ciegas')) {
          winesMultipleTaste[i].nombre = 'Vino a catar a ciegas ${i + 1}';
        }
      }
    }
    else {
      for (var i = 0; i < winesMultipleTaste.length; i++) {
        if (winesMultipleTaste[i].nombre.contains('Vino a catar a ciegas')) {
          winesMultipleTaste[i].nombre = '${winesMultipleTaste[i].vino} ${winesMultipleTaste[i].anada.toString()}';
        }
      }
    }
    notifyListeners();
  }

  void editMultipleTaste(Function changeFunction) {
    changeFunction();
    notifyListeners();
  }

  // String get multipleName => _multipleName;

  // set name(String name) {
  //   multipleTaste.name = name;
  //   notifyListeners();
  // }

  // bool get hidden => _hidden;

  // set hidden(bool value) {
  //   multipleTaste.hidden = value;
  //   notifyListeners();
  // }

  bool get hideNames => _hideNames;

  set hideNames(bool value) {
    _hideNames = value;
    notifyListeners();
  }

  // String? get password =>_password;

  // set password(String? value) {
  //   multipleTaste.password = value;
  //   notifyListeners();
  // }

  // String? get description => _description;

  // set description(String? value) {
  //   multipleTaste.description = value;
  //   notifyListeners();
  // }

  // String get dateLimit => _dateLimit;

  // set dateLimit(String value) {
  //   multipleTaste.dateLimit = value;
  //   notifyListeners();
  // }

  // set wines(Map<String, Map<String, WineTaste>> value) {
  //   multipleTaste.wines = value;
  //   notifyListeners();
  // }

  int get winesHiddenNumber => _winesHiddenNumber;

  set winesHiddenNumber(int value) {
    _winesHiddenNumber = value;
    notifyListeners();
  }

  void resetSettings() { // TODO ver donde y como utilizo el resetsettings
    // multipleTaste.name = ''; // TODO al hacer back dejar nombre o no???
    multipleTaste.description = null;
    multipleTaste.password = null;
    multipleTaste.hidden = false;
    multipleTaste.dateLimit = '';
    multipleTaste.wines = {};
    multipleTaste.averageRatings = AverageRatings(boca: -1, nariz: -1, puntos: -1, vista: -1);
    winesHiddenNumber = 0;
    winesMultipleTaste.clear();
    notifyListeners();
  }
}