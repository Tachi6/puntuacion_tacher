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
  List<Wines> winesByName = [];
  List<WineTaste> winesTaste = [];

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
    updateWinesByName();
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

  void updateWinesByName() {
    winesByName = [...winesByIndex];
    // Elimino vinos sin valoracion
    winesByName.sort((a, b) => b.nombre.compareTo(a.nombre));
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

  List<WineTaste> otherWineTaste(Wines wine, String? date, bool swapCheck) {
    List<WineTaste> otherUsersTastedWines = [];
    for (var wineTaste in winesTaste) {
      if(wineTaste.id == wine.id) {
        otherUsersTastedWines = [...otherUsersTastedWines, wineTaste];
      }
    }

    if (date != null && !swapCheck) {
      final userIndex = otherUsersTastedWines.indexWhere((element) => element.fecha == date);
      if (userIndex != 0) otherUsersTastedWines.swap(0, userIndex);
    }

    return otherUsersTastedWines;
  }

  Future<Wines> loadWine(String wineId) async {

    final String jsonType = 'wines/$wineId.json';

    final url = Uri.https(_baseUrl, jsonType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.get(url);

    final Wines wine = Wines.fromJson(resp.body);

    // Wines update
    winesByIndex[int.parse(wineId)] = wine;
    updateWinesByRate();
    updateWinesByName();   
    notifyListeners();

    return wine;
  }

  Future<String> updateWine(Wines wine) async {

    isSaving = true;
    notifyListeners();

    final String jsonUpdateType = 'wines/${wine.id}.json';
    final url = Uri.https(_baseUrl, jsonUpdateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.patch(url, body: wine.toJson());

    // Actualizar el listado local de productos
    final int wineId = int.parse(wine.id!);
    winesByIndex[wineId] = wine;
    updateWinesByRate();
    updateWinesByName();   
    isSaving = false;
    notifyListeners();

    return resp.body;
  }

  Future<String> createWine(Wines wine) async {
    // Actualizo vinos para que el id sea correcto
    await loadWines();
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
    updateWinesByName();

    isSaving = false;
    notifyListeners();

    return newId;
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
}