import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';

class MultipleTasteProvider extends ChangeNotifier {
  MultipleTasteProvider(){
    obtainUser();
  }

  Multiple multipleTaste = Multiple(
    name: '',
    hidden: false,
    wines: {},
    averageRatings: {}
  );

  GlobalKey<FormState> formNameKey = GlobalKey<FormState>();
  
  late final String userDisplayName;
  AutovalidateMode _autovalidateName = AutovalidateMode.disabled;
  bool _isNameUsed = false;
  int _winesHiddenNumber = 0;
  bool _hideNames = false;
  List<int> hideIndex = [];
  List<Wines> winesMultipleTaste = [];
  List<WineTaste> userMultipleTaste = [];
  String _userView = '';

  int pageIndex = 0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
    text: 'Sin limite',
  );

  Future<void> obtainUser() async {
    const storage = FlutterSecureStorage();
    userDisplayName = await storage.read(key: 'displayName') ?? '';
    userView = userDisplayName;
    notifyListeners();
  }

  bool isValidForm() {
    return formNameKey.currentState?.validate() ?? false;
  }

  Multiple initMultiple() {
    // Creo nueva lista con solo el id del vino
    final List<String> winesIndex = List.from(winesMultipleTaste.map((e) {
      return e.id;
    }));
    // Creo mapa vacio
    Map<String, Map<String, WineTaste>> wines = {};
    Map<String, AverageRatings> averageRatings = {};
    // Mapeo la lista como un mapa, con el primer valor como 'No iniciada' solo en el WineTaste
    for (var wineId in winesIndex) {
      final Map<String, Map<String, WineTaste>> winesEntry = {
        wineId: {
          'notStarted': WineTaste(
            fecha: '',
            user: 'not', 
            nombre: '',
            id: wineId,
            ratingVista: -1, 
            ratingNariz: -1, 
            ratingBoca: -1, 
            ratingPuntos: -1, 
            puntosFinal: -1,
            puntosVista: -1, 
            puntosNariz: -1, 
            puntosBoca: -1, 
          ),
        }
      };
      final Map<String, AverageRatings> averageRatingsEntry = {
        wineId: AverageRatings(
          vista: -1,
          nariz: -1, 
          boca: -1, 
          puntos: -1, 
        ),
      };
      // Añado entrada al mapa
      wines = {...wines, ...winesEntry};
      averageRatings = {...averageRatings, ...averageRatingsEntry};
    }
    // Añado vinos a cata multiple
    multipleTaste.wines = wines;
    multipleTaste.averageRatings = averageRatings;
    notifyListeners();

    return multipleTaste;
  }

  Future<void> initUserTaste(bool isTasted) async {
    
    List<WineTaste> tempUserMultipleTaste = [];

    if (isTasted) {
      multipleTaste.wines.forEach((key, value) {
        value.forEach((key, value) {
          if (value.user.contains(userDisplayName)) {
            tempUserMultipleTaste.add(value);
          }
        },);
      },);
    }
    else {
      for (var i = 0; i < winesMultipleTaste.length; i++) {
        final WineTaste tempUserTaste = WineTaste(
          user: userDisplayName,
          id: winesMultipleTaste[i].id ?? 'Vino a ciegas $i',
          nombre: winesMultipleTaste[i].nombre,
          comentarios: '',
          fecha: 'Taste date $i', // Se crea al subirlo al server
          ratingVista: -1,
          ratingNariz: -1,
          ratingBoca: -1,
          ratingPuntos: -1,
          puntosVista: -1,
          puntosNariz: -1,
          puntosBoca: -1,
          puntosFinal: -1,
          notasBoca: '',
          notasNariz: '',
          notasVista: '',
        );
        tempUserMultipleTaste.add(tempUserTaste);
      }
    }

    userMultipleTaste = tempUserMultipleTaste;

    notifyListeners();
  }

  void updateMultipleTaste(Multiple updatedMultipleTaste) {
    multipleTaste = updatedMultipleTaste.copy();
    notifyListeners();
  }

  void updateWineTaste(Function editWineTaste) {
    editWineTaste();
    notifyListeners();
  }

  void calculateValoration() {
    final Formulas formulas = Formulas();

    for (var wineTaste in userMultipleTaste) {
      wineTaste = formulas.calculateWineTaste(wineTaste);
    }

    notifyListeners();
  }

  void calculateAverageRatings() {
    final Formulas formulas = Formulas();

    Map<String, AverageRatings> puntuaciones = {};
    print(multipleTaste.wines.length);
    multipleTaste.wines.forEach((key, value) {

      List <double> tempPuntosVistaList = [];
      List <double> tempPuntosNarizList = [];
      List <double> tempPuntosBocaList = [];
      List <int> tempPuntuacionesList = [];

      for (var element in userMultipleTaste) {
        if (element.id == key) {
          tempPuntosVistaList.add(element.puntosVista);
          tempPuntosNarizList.add(element.puntosNariz);
          tempPuntosBocaList.add(element.puntosBoca);
          tempPuntuacionesList.add(element.puntosFinal);
        }
      }

      value.forEach((key, value) {
        if (value.puntosVista != -1) tempPuntosVistaList.add(value.puntosVista);
        if (value.puntosNariz != -1) tempPuntosNarizList.add(value.puntosNariz);
        if (value.puntosBoca != -1) tempPuntosBocaList.add(value.puntosBoca);
        if (value.puntosFinal != -1) tempPuntuacionesList.add(value.puntosFinal);
      },);

        print(tempPuntosVistaList);
        print(tempPuntosNarizList);
        print(tempPuntosBocaList);
        print(tempPuntuacionesList);
      puntuaciones[key] = AverageRatings(
        vista: formulas.puntuacionCategoria(tempPuntosVistaList),
        nariz: formulas.puntuacionCategoria(tempPuntosNarizList), 
        boca: formulas.puntuacionCategoria(tempPuntosBocaList),
        puntos: formulas.puntuacionFinal(tempPuntuacionesList), 
      );
    },);
    multipleTaste.averageRatings = puntuaciones;

    notifyListeners();
  }

  void clearwinesTaste() {
    userMultipleTaste.clear();
    notifyListeners();
  }

  List<String> otherUsersTaste() {
    Map<String, Map<String, WineTaste>> othersUsersTaste = {...multipleTaste.wines};

    othersUsersTaste.forEach((key, value) {
      value.removeWhere((key, value) => value.puntosFinal == -1);
    },);

    List<String> otherUsers = [];
    if (userMultipleTaste.isNotEmpty && userMultipleTaste.first.puntosFinal != -1) otherUsers.add(userDisplayName);

    othersUsersTaste.forEach((key, value) {
      value.forEach((key, value) {
        if (value.user == userDisplayName) {
          otherUsers[0] = userDisplayName;
        }
        else {
          otherUsers.add(value.user);
        }
      },);
    },);
    // If is a direct create + MultipleTaste to load user. But when close i need to not load this

    return otherUsers.toSet().toList();
  }

  List<WineTaste> anotherUserMultipleTaste(String user) {
    Map<String, Map<String, WineTaste>> multipleTasteWinesCopy = {...multipleTaste.wines};

    List<WineTaste> wineTasteList = [];
      
    multipleTasteWinesCopy.forEach((key, value) {
      value.forEach((key, value) {
        if (value.user == user && value.puntosFinal != -1) {
          wineTasteList.add(value);
        }
      },);      
    },);

    if (wineTasteList.isEmpty) return userMultipleTaste;

    return wineTasteList;
  }

  bool isValidRating() {
    final validation = [];
    for (var wineTaste in userMultipleTaste) {
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
        id: 'Vino a catar a ciegas $i',
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
    hideIndex.contains(index) 
      ? hideIndex.remove(index)
      : hideIndex.add(index);
    
    hideIndex.sort((a, b) => a.compareTo(b));
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

  AutovalidateMode get autovalidateMode => _autovalidateName;

  set autovalidateMode(AutovalidateMode mode) {
    _autovalidateName = mode;
    notifyListeners();
  }

  bool get hideNames => _hideNames;

  set hideNames(bool value) {
    _hideNames = value;
    notifyListeners();
  }

  String get userView => _userView;

  set userView(String value) {
    _userView = value;
    notifyListeners();
  }

  bool get isNameUsed => _isNameUsed;

  set isNameUsed(bool value) {
    _isNameUsed = value;
    notifyListeners();
  }

  int get winesHiddenNumber => _winesHiddenNumber;

  set winesHiddenNumber(int value) {
    _winesHiddenNumber = value;
    notifyListeners();
  }

  void resetSettings() { // TODO ver donde y como utilizo el resetsettings
    multipleTaste.name = ''; // TODO al hacer back dejar nombre o no???
    multipleTaste.description = null;
    multipleTaste.password = null;
    multipleTaste.hidden = false;
    multipleTaste.dateLimit = null;
    multipleTaste.wines = {};
    multipleTaste.averageRatings = {};
    winesHiddenNumber = 0;
    hideNames = false;
    
    winesMultipleTaste.clear();
    userMultipleTaste.clear();
    hideIndex.clear();
    
    notifyListeners();
  }
}