import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:puntuacion_tacher/models/models.dart';


//TODO repasar que no pase objetos por referencia

class WineServices extends ChangeNotifier {
  WineServices();

  final String _baseUrl = 'puntos-tacher-default-rtdb.europe-west1.firebasedatabase.app';
  final String _jsonType = 'wines.json';
  final String _jsonTypeLatest = 'latest.json';

  final storage = const FlutterSecureStorage();

  List<Wines> winesByIndex = [];
  List<Wines> winesByRate = [];
  List<WineTaste> winesTaste = [];
  Wines? _selectedWine;
  List<Wines> latest = [];

  bool isLoading = true;
  bool isSaving = false;

  bool _needRefreshLogo = false;

  bool get refreshLogo => _needRefreshLogo;

  set refreshLogo(bool value) {
    _needRefreshLogo = value;
    notifyListeners();
  }

  Future<void> loadWines() async {

    isLoading = true;
    notifyListeners();

    List<Wines> tempWinesByIndex = [];

    final url = Uri.https(_baseUrl, _jsonType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> winesMap = json.decode(resp.body);

    winesMap.forEach((key, value) async {
      Wines tempWine = Wines.fromMap(value);
      tempWine.id = key;
      tempWinesByIndex.add(tempWine);
    });

    winesByIndex = tempWinesByIndex;

    // // TODO lo hago asi porque no me funciona el Hero manejando el error. Pensar otra forma
    // for (Wines wine in winesByIndex) {
    //   wine.imagenVino = await checkErrorImage(wine.imagenVino);
    //   wine.logoBodega = await checkErrorImage(wine.logoBodega);
    // }

    // Wines sort by points
    updateWinesByRate();
    isLoading = false;
    
    notifyListeners();
  }

  Future<void> loadWinesTaste() async {
    List<WineTaste> tempLatestTasted = [];

    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, _jsonTypeLatest, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> latestMap = json.decode(resp.body);

    latestMap.forEach((key, value) {
      final latestWine = WineTaste.fromJson(value);
      // latestWine.id = key;
      tempLatestTasted.add(latestWine);
    });

    winesTaste = tempLatestTasted.reversed.toList();  

    isLoading = false;
    notifyListeners();
  }

  void updateWinesByRate() {
    winesByRate = [...winesByIndex];
    // Elimino vinos sin valoracion
    winesByRate.removeWhere((element) => element.puntuacionFinal == -1);
    winesByRate.sort((a, b) => b.puntuacionFinal.compareTo(a.puntuacionFinal));
  }

  List<Wines> winesBestCategory(String category) {
    List<Wines> winesCategory = [...winesByRate];
    winesCategory.removeWhere((element) => element.tipo != category);

    return winesCategory;
  }

  List<WineTaste> userWineTaste(String userUuid) {
    // Creo lista temporal de vinos
    List<WineTaste> userTastedWines = [...winesTaste];
    // Elimino usuarios que no han catado ese vino
    userTastedWines.removeWhere((element) => !element.user.contains(userUuid));
    // Ordeno la lista por mayores puntuaciones
    userTastedWines.sort((a, b) => b.puntosFinal.compareTo(a.puntosFinal));
    
    return userTastedWines;
  }

  List<WineTaste> otherWineTaste(Wines wine, String? date) {
    List<WineTaste> otherUsersTastedWines = [];
    for (var wineTaste in winesTaste) {
      if(wineTaste.id == wine.id) {
        otherUsersTastedWines = [...otherUsersTastedWines, wineTaste];
      }
    }

    if (date != null) {
      final userIndex = otherUsersTastedWines.indexWhere((element) => element.fecha == date);
      if (userIndex != 0) otherUsersTastedWines.swap(0, userIndex);
    }

    return otherUsersTastedWines;
  }

  Wines? get selectedWine {
     return _selectedWine;
   }

  set selectedWine(Wines? wine) {
    _selectedWine = wine;
    notifyListeners();
  }

  Future<String> updateWine(Wines wine) async {

    isSaving = true;
    notifyListeners();
    
    await loadWines();

    final String jsonUpdateType = 'wines/${wine.id}.json';
    final url = Uri.https(_baseUrl, jsonUpdateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.put(url, body: wine.toJson());

    // Actualizar el listado de productos
    final int wineId = int.parse(wine.id!);
    winesByIndex[wineId] = wine;

    isSaving = false;
    notifyListeners();

    return resp.body;
  }

  Future<String> createWine(Wines wine) async {
    // Assigno nueva id
    final String lastWineIndex = winesByIndex.length.toString();
    final idLenght = lastWineIndex.length;
    const defaultNewId = "00000000000000000000";
    final newId = defaultNewId.replaceRange(20 - idLenght, 20, lastWineIndex);
    wine.id = newId;

    final String jsonCreateType = 'wines/${wine.id}.json';
    final url = Uri.https(_baseUrl, jsonCreateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    await http.put(url, body: wine.toJson());

    winesByIndex.add(wine);
    updateWinesByRate();

    isSaving = false;
    notifyListeners();

    return newId;
    // return resp.body;
  }

  Future<String> saveTastedWine(WineTaste wineTaste) async {
    // Creo id de firebase con la fecha custom
    final String idFirebase = wineTaste.fecha;

    final String jsonCreateType = 'latest/$idFirebase.json'; 
    final url = Uri.https(_baseUrl, jsonCreateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    // final resp = await http.put(url, body: wine.toJson());
    final resp = await http.put(url, body: wineTaste.toRawJson());

    winesTaste.insert(0, wineTaste);

    notifyListeners();

    return resp.body;
  }

  Wines obtainWine(String id) {
    final wineIndex = int.parse(id);    
    return winesByIndex[wineIndex];
  }

  Future<bool> isValidImage(String? url) async {
    if (url == null) return false;

    final bool isURLValid = Uri.parse(url).host.isNotEmpty;
    if (!isURLValid) return false; 

    final Uri uri = Uri.parse(url);
    final resp = await http.head(uri);
    if (resp.statusCode != 200) return false;
      
    return true;
  }

  Future<String> likesCount(Wines wine) async {

    loadWinesTaste();

    if (wine.likes == null) {
      wine.likes = 1;
    }
    else {
      wine.likes = wine.likes! + 1;
    }
    notifyListeners();

    final String jsonUpdateType = 'latest/${wine.id}.json';
    final url = Uri.https(_baseUrl, jsonUpdateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.put(url, body: wine.toJson());

    return resp.body;
  }

  // void createNewJson() async {
  //   int wineCount = 0;

  //   final String repeatedDate = "2022-01-01T00:00:00.000000";

  //   // Map<String, Wines> tempJsonMap = {};

  //   for (Wines wine in winesByRate) {
  //     for (int i = 0; i < wine.fechas!.length; i++) { 
  //       if (repeatedDate == wine.fechas![i]) wineCount++;

  //       // final double ratingVista = ((wine.puntuacionesVista![i] * 7) / 5).round().toDouble();
  //       // final double ratingNariz = ((wine.puntuacionesNariz![i] * 9) / 5).round().toDouble();
  //       // final double ratingBoca = ((wine.puntuacionesBoca![i] * 9) / 5).round().toDouble();

  //       final String newDate = (repeatedDate == wine.fechas![i]) 
  //         ? repeatedDate.replaceRange(26 - wineCount.toString().length, 26, wineCount.toString())
  //         : wine.fechas![i];

  //       wine.fechas![i] = newDate.replaceAll('.', ':');

  //       // Map<String, Wines> tempMap = {
  //       //   wine.id!: wine,
  //       // };

  //       // Map<String, WineTaste> tempMap = {
  //       //   newDate.replaceAll('.', ':'): WineTaste(
  //       //     fecha: newDate.replaceAll('.', ':'), 
  //       //     id: wine.id!, 
  //       //     nombre: wine.nombre, 
  //       //     user: wine.usuarios![i] == '' ? 'admin@tacher.com' : wine.usuarios![i], 
  //       //     ratingVista: ratingVista,
  //       //     ratingNariz: ratingNariz,
  //       //     ratingBoca: ratingBoca, 
  //       //     ratingPuntos: obtainRatingPuntospuntos(
  //       //       ratingVista: ratingVista,
  //       //       ratingNariz: ratingNariz,
  //       //       ratingBoca: ratingBoca,
  //       //       puntosFinal: wine.puntuaciones![i],
  //       //     ), 
  //       //     puntosVista: wine.puntuacionesVista![i], 
  //       //     puntosNariz: wine.puntuacionesNariz![i], 
  //       //     puntosBoca: wine.puntuacionesBoca![i], 
  //       //     puntosFinal: wine.puntuaciones![i],
  //       //     notasVista: wine.notasVista![i],
  //       //     notasNariz: wine.notasNariz![i],
  //       //     notasBoca: wine.notasBoca![i],
  //       //     comentarios: wine.comentarios![i],
  //       //   )
  //       // };

  //       // tempJsonMap = {...tempJsonMap, ...tempMap};
  //     }

  //     await updateWine(wine);
  //   }
    
  //   // return jsonEncode(tempJsonMap);    
  // }

}