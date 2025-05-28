import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/helpers/formulas.dart';
import 'package:puntuacion_tacher/infrastructure/datasources/multiple_firebase_datasource.dart';
import 'package:puntuacion_tacher/infrastructure/repositories/multiple_repository_impl.dart';
import 'package:puntuacion_tacher/models/wines.dart';

class MultipleProvider extends ChangeNotifier {
  MultipleProvider(this._multipleSelected, this.winesByIndex, this.userUuid) {
    _multipleSelected.wines ??= {};

    _userView = userUuid;

    for (String wineId in _multipleSelected.wineSequence) {
      final Wines wine = winesByIndex.firstWhere((wine) => wine.id == wineId);
      multipleWines.add(wine);      
    }

    shuffleMultipleWines();

    checkIsMultipleFinished();
  }

  final List<Wines> winesByIndex;
  MultipleNew _multipleSelected;
  final String userUuid;
  late String _userView;

  final MultipleRepositoryImpl multipleRepositoryImpl = MultipleRepositoryImpl(MultipleFirebaseDatasource());

  final List<Wines> multipleWines = [];
  List<Wines> multipleWinesShuffled1 = [];
  List<Wines> multipleWinesShuffled2= [];
  List<Wines> multipleWinesShuffled3 = [];
  List<Wines> multipleWinesShuffled4 = [];
  bool isMultipleTasted = false;

  late PageController pageController;
  Widget _pageDestination = const SizedBox();

  MultipleNew get multipleSelected => _multipleSelected;
  Widget get pageDestination => _pageDestination;
  String get userView => _userView;

  set userView(String newUserView) {
    _userView = newUserView;
    notifyListeners();
  }

  void setandMoveToPage(Widget? newPage) {
    if (newPage != null) {
      _pageDestination = newPage;
      notifyListeners();
    }

    pageController.animateToPage(
      newPage != null ? 1 : 0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  Future<void> validateWineTaste(WineTaste wineTaste) async {
    await uploadWineTaste(wineTaste);
    await reloadMultiple();
    await uploadAverageRatings();
    checkIsMultipleFinished();
  }

  Future<void> reloadMultiple() async {
    _multipleSelected = await multipleRepositoryImpl.loadSingleMultipleTaste(_multipleSelected.id!);
    notifyListeners();
  }

  Future<void> uploadWineTaste(WineTaste wineTaste) async {
    // Subo cambios a firebase
    await multipleRepositoryImpl.updateMultipleTaste(_multipleSelected.id!, wineTaste);
  }

  Future<void> uploadAverageRatings() async {
    // Calculo los averageRatings
    Map<String, AverageRatings> averageRatingsMap = {};
    
    _multipleSelected.wines!.forEach((key, value) {
      List <double> puntosVistaList = [];
      List <double> puntosNarizList = [];
      List <double> puntosBocaList = [];
      List <int> puntuacionesList = [];

      value.forEach((key, value) {
        puntosVistaList.add(value.puntosVista);
        puntosNarizList.add(value.puntosNariz);
        puntosBocaList.add(value.puntosBoca);
        puntuacionesList.add(value.puntosFinal);
      });

      averageRatingsMap[key] = AverageRatings(
        vista: Formulas.puntuacionCategoria(puntosVistaList),
        nariz: Formulas.puntuacionCategoria(puntosNarizList), 
        boca: Formulas.puntuacionCategoria(puntosBocaList),
        puntos: Formulas.puntuacionFinal(puntuacionesList), 
      );
    });
    // Subo cambios a firebase
    await multipleRepositoryImpl.updateAverageRatings(_multipleSelected.id!, averageRatingsMap);
    // Actualizo localmente
    _multipleSelected.averageRatings = averageRatingsMap;

    notifyListeners();   
  }

  bool isWineTasted(String wineId) {
    return _multipleSelected.wines![wineId]?.values.any((wineTaste) => wineTaste.user == userUuid) ?? false;
  }

  void checkIsMultipleFinished() {
    List<bool> winesTasted = []; 
    _multipleSelected.wines!.forEach((key, value) {
      value.forEach((key, value) {
        if (value.user == userUuid) {
          winesTasted.add(true);
        }
      });
    });

    isMultipleTasted = winesTasted.length == _multipleSelected.wineSequence.length;

    notifyListeners();
  }

  void shuffleMultipleWines() {
    multipleWinesShuffled1 = [...multipleWines];
    multipleWinesShuffled1.shuffle();

    multipleWinesShuffled2 = [...multipleWines];
    multipleWinesShuffled2.shuffle();

    multipleWinesShuffled3 = [...multipleWines];
    multipleWinesShuffled3.shuffle();

    multipleWinesShuffled4 = [...multipleWines];
    multipleWinesShuffled4.shuffle();

    notifyListeners();
  }

  WineTaste? getSelectedWineTaste(String wineId) {
    WineTaste? wineTaste;
    _multipleSelected.wines![wineId]?.forEach((key, value) {
      if (value.user == userUuid) wineTaste = value;
    });
    return wineTaste;
  }

  List<WineTaste> anotherUserMultipleTaste(String user) {
    List<WineTaste> wineTasteList = [];
      
    multipleSelected.wines!.forEach((key, value) {
      value.forEach((key, value) {
        if (value.user == user && value.puntosFinal != -1) {
          wineTasteList.add(value);
        }
      },);      
    },);

    return wineTasteList;
  }

  List<AverageRatings> sortAverageRatings() {
    List<AverageRatings> averageRatings = [];
    for (String wineId in multipleSelected.wineSequence) {
      averageRatings.add(multipleSelected.averageRatings[wineId]!);
    }
    return averageRatings;
  }

  List<String> allUsersTaste() {
    // Añado Todos los usuarios para cada una de sus catas
    List<String> allUsers = [];
    multipleSelected.wines!.forEach((key, value) {
      value.forEach((key, value) {
        if (value.user != userUuid) allUsers.add(value.user);
      });
    });
    // Compruebo que todos los vinos estan catados, sino lo elimino la lista
    for (String user in allUsers) {
      final int userCount = allUsers.where((element) => element == user).length;
      if (userCount != multipleWines.length) {
        allUsers.removeWhere((element) => element == user);
      }
    }
    // Añado en primera posicion al usuario principal, porque sino puede acceder al overview, es porque tiene las catas realizadas
    return [userUuid, ...allUsers.toSet()];
  }
}