import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:puntuacion_tacher/helpers/helpers.dart';
import 'package:puntuacion_tacher/models/models.dart';

class MultipleTasteProvider extends ChangeNotifier {
  MultipleTasteProvider(){
    obtainUser();
  }

  String _multipleName = '';
  late final String user;
  AutovalidateMode _autovalidateName = AutovalidateMode.disabled;
  // bool _isNameUsed = false;
  int _winesHiddenNumber = 0;
  // List<int> hideIndex = [];
  List<Wines> winesMultipleTaste = [];
  List<WineTaste> userMultipleTaste = [];
  String _userView = '';
  bool _overview = false;
  Map<String, bool> tasteQuiz = {
    'simple': false,
    'advanced': false,
  };
  bool _isLoading = false;

  Multiple multipleTaste = Multiple(
    name: '',
    description: '',
    hidden: false,
    wineSequence: [],
    wines: {},
    averageRatings: {}
  );

  int pageIndex = 0;

  GlobalKey<FormState> formNameKey = GlobalKey<FormState>();

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  Future<void> obtainUser() async {
    const storage = FlutterSecureStorage();
    user = await storage.read(key: 'localId') ?? '';
    userView = user;
    notifyListeners();
  }

  bool isValidForm() {
    return formNameKey.currentState?.validate() ?? false;
  }

  bool isNotReadyForQuiz() { // TODO: hacer funcionar, poder editar vino
    List<bool> isEmptyField = [];
    
    for (Wines wine in winesMultipleTaste) {
      if (wine.variedades == '') isEmptyField.add(true);
      if (wine.graduacion == '') isEmptyField.add(true);
      if (wine.notaVista == '') isEmptyField.add(true);
      if (wine.notaNariz == '') isEmptyField.add(true);
      if (wine.notaBoca == '') isEmptyField.add(true);      
    }

    return isEmptyField.contains(true);
  }


  List<Wines> wineListShuffled() {
    final List<Wines> newWineList = [...winesMultipleTaste];
    newWineList.shuffle();
    return newWineList;
  }

  void isSimpleQuiz(bool? quizType) {
    if (quizType == null) return;

    if (quizType) {
      multipleTaste.tasteQuiz = 'simple';
      tasteQuiz['simple'] = true;
      tasteQuiz['advanced'] = false;
      notifyListeners();
    }
    else {
      multipleTaste.tasteQuiz = null;
      tasteQuiz['simple'] = false;
      notifyListeners();
    }
  }

  void isAdvancedQuiz(bool? quizType) {
    if (quizType == null) return;

    if (quizType) {
      multipleTaste.tasteQuiz = 'advanced';
      tasteQuiz['advanced'] = true;
      tasteQuiz['simple'] = false;
      notifyListeners();
    }
    else {
      multipleTaste.tasteQuiz = null;
      tasteQuiz['advanced'] = false;
      notifyListeners();
    }
  }

  Multiple initMultiple() {
    // Creo nueva lista con solo el id del vino
    final List<String> winesIndex = winesMultipleTaste.map((e) {
      return e.id!;
    }).toList();
    // Creo mapa vacio de Wines, AverageRatings y wineSequence
    Map<String, Map<String, WineTaste>> wines = {};
    Map<String, AverageRatings> averageRatings = {};
    List<String> wineSequence = [];
    // Mapeo la lista como un mapa, con el primer valor como 'No iniciada' solo en el WineTaste
    for (int i = 0; i < winesIndex.length; i++) {
      final String wineId = winesIndex[i];

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
      wineSequence.add(wineId);
    }
    // for (var wineId in winesIndex) {
    //   final Map<String, Map<String, WineTaste>> winesEntry = {
    //     wineId: {
    //       'notStarted': WineTaste(
    //         fecha: '',
    //         user: 'not', 
    //         nombre: '',
    //         id: wineId,
    //         ratingVista: -1, 
    //         ratingNariz: -1, 
    //         ratingBoca: -1, 
    //         ratingPuntos: -1, 
    //         puntosFinal: -1,
    //         puntosVista: -1, 
    //         puntosNariz: -1, 
    //         puntosBoca: -1, 
    //       ),
    //     }
    //   };
    //   final Map<String, AverageRatings> averageRatingsEntry = {
    //     wineId: AverageRatings(
    //       vista: -1,
    //       nariz: -1, 
    //       boca: -1, 
    //       puntos: -1, 
    //     ),
    //   };
    //   // Añado entrada al mapa
    //   wines = {...wines, ...winesEntry};
    //   averageRatings = {...averageRatings, ...averageRatingsEntry};
    // }
    // Añado vinos a cata multiple
    multipleTaste.wines = wines;
    multipleTaste.averageRatings = averageRatings;
    multipleTaste.wineSequence = wineSequence;
    notifyListeners();

    return multipleTaste;
  }

  Future<void> initUserTaste(bool isTasted) async {
    
    List<WineTaste> tempUserMultipleTaste = [];

    if (isTasted) {
      multipleTaste.wines.forEach((key, value) {
        value.forEach((key, value) {
          if (value.user == user) {
            tempUserMultipleTaste.add(value);
          }
        },);
      },);
    }
    else {
      for (var i = 0; i < winesMultipleTaste.length; i++) {
        final WineTaste tempUserTaste = WineTaste(
          user: user,
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

  void updateWineTaste(Function editWineTaste) {
    editWineTaste();
    notifyListeners();
  }

  void calculateValoration() {
    for (var wineTaste in userMultipleTaste) {
      final Formulas formulas = Formulas(
        ratingVista: wineTaste.ratingVista,
        ratingNariz: wineTaste.ratingNariz,
        ratingBoca: wineTaste.ratingBoca,
        ratingPuntos: wineTaste.ratingPuntos
      );

      wineTaste.puntosVista = formulas.puntosVista;
      wineTaste.puntosNariz = formulas.puntosNariz;
      wineTaste.puntosBoca = formulas.puntosBoca;
      wineTaste.puntosFinal = formulas.calculosFinal;
    }

    notifyListeners();
  }

  void calculateAverageRatings() {
    Map<String, AverageRatings> puntuaciones = {};
    
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

      puntuaciones[key] = AverageRatings(
        vista: Formulas.puntuacionCategoria(tempPuntosVistaList),
        nariz: Formulas.puntuacionCategoria(tempPuntosNarizList), 
        boca: Formulas.puntuacionCategoria(tempPuntosBocaList),
        puntos: Formulas.puntuacionFinal(tempPuntuacionesList), 
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
    if (userMultipleTaste.isNotEmpty && userMultipleTaste.first.puntosFinal != -1) otherUsers.add(user);

    othersUsersTaste.forEach((key, value) {
      value.forEach((key, value) {
        if (value.user == user) {
          otherUsers[0] = user;
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

  initLoadedMultipleTaste(Multiple loadedMultipleTaste) {
    // Asign actual MultipleTaste
    multipleTaste = loadedMultipleTaste;
    notifyListeners();
    // Set WineSequence
    Map<String, Map<String, WineTaste>> tempWineSequence = {};
    for (String wineId in multipleTaste.wineSequence) {
      Map<String, Map<String, WineTaste>> wineMap = {
        wineId: multipleTaste.wines[wineId]!,
      };
      tempWineSequence = {...tempWineSequence, ...wineMap};
    }
    multipleTaste.wines = tempWineSequence;
    notifyListeners();
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

  void addMultipleTasteWines(List<Wines> wines) {
    // List<Wines> wines = [];
    // for (String wineId in multipleTaste.wineSequence) {
    //   wines.add(winesByIndex[int.parse(wineId)]);
    // }
    winesMultipleTaste = wines;
    notifyListeners();
  }

  // void addVisibleWines(List<Wines> wines) {
  //   winesMultipleTaste = wines;
  //   notifyListeners();
  // }

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

  void hideAllWines() {
    multipleTaste.hidden = !multipleTaste.hidden;
    notifyListeners();
  }

  AutovalidateMode get autovalidateMode => _autovalidateName;

  set autovalidateMode(AutovalidateMode mode) {
    _autovalidateName = mode;
    notifyListeners();
  }

  String get multipleName => _multipleName;

  set multipleName(String value) {
    _multipleName = value;
    notifyListeners();
  }

  String get userView => _userView;

  set userView(String value) {
    _userView = value;
    notifyListeners();
  }

  bool get overview => _overview;

  set overview(bool value) {
    _overview = value;
    notifyListeners();
  }

  int get winesHiddenNumber => _winesHiddenNumber;

  set winesHiddenNumber(int value) {
    _winesHiddenNumber = value;
    notifyListeners();
  }

  void resetSettings() {
    multipleName = '';
    multipleTaste.name = ''; 
    multipleTaste.description = '';
    multipleTaste.password = null;
    multipleTaste.hidden = false;
    multipleTaste.tasteQuiz = null;
    multipleTaste.dateLimit = null;
    multipleTaste.wines = {};
    multipleTaste.averageRatings = {};
    tasteQuiz = {
      'simple': false,
      'advanced': false,
    };
    winesHiddenNumber = 0;
    overview = false;
    
    winesMultipleTaste.clear();
    userMultipleTaste.clear();
    // hideIndex.clear();
    
    notifyListeners();
  }
}