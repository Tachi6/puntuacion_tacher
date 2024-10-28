
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:puntuacion_tacher/models/models.dart';

class WinesService extends ChangeNotifier {

  final String _baseUrl = 'puntos-tacher-default-rtdb.europe-west1.firebasedatabase.app';
  final String _jsonType = 'wines.json';
  final String _jsonTypeLatest = 'latest.json';

  final storage = const FlutterSecureStorage();

  List<Wines> winesByIndex = [];
  List<Wines> winesByRate = [];
  List<Wines> winesLatestTasted = [];
  Wines? _selectedWine;
  List<Wines> latest = [];

  bool isLoading = true;
  bool isSaving = false;

  WinesService() {
    loadWines();
    loadLatestWines();
    // pruebaLatest();
  }

  Future loadWines() async {

    isLoading = true;
    notifyListeners();

    List<Wines> tempWinesByIndex = [];

    final url = Uri.https(_baseUrl, _jsonType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> winesMap = json.decode(resp.body);

    winesMap.forEach((key, value) {
      final tempWine = Wines.fromMap(value);
      tempWine.id = key;
      tempWinesByIndex.add(tempWine);
    });

    winesByIndex = tempWinesByIndex;

    // Wines sort by points
    updateWinesByRate();
    isLoading = false;
    
    notifyListeners();
  }

  Future loadLatestWines() async {

    List<Wines> tempLatestTasted = [];

    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, _jsonTypeLatest, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.get(url);

    final Map<String, dynamic> latestMap = json.decode(resp.body);

    latestMap.forEach((key, value) {
      final latestWine = Wines.fromMap(value);
      latestWine.id = key;
      tempLatestTasted.add(latestWine);
    });

    winesLatestTasted = tempLatestTasted.reversed.toList();  

    isLoading = false;
    notifyListeners();
  }

  void updateWinesByRate() {
    winesByRate = List.from(winesByIndex);
    winesByRate.sort((a, b) => b.puntuacionFinal.compareTo(a.puntuacionFinal));
  }

  List<Wines> winesBestCategory(String category) {
    List<Wines> winesCategory = List.from(winesByRate);
    winesCategory.removeWhere((element) => element.tipo != category);

    return winesCategory;
  }

  List<Wines> userTastedWines(String mail) {

    // Creo lista temporal de vinos
    List<Wines> tempTastedWines = List.from(winesByRate);
    // Elimino usuarios que no han catado ese vino
    tempTastedWines.removeWhere((element) => !element.usuarios.contains(mail));
    // Creo nueva lista para vinos catados 2 veces
    List<Wines> userTastedWines = [];

    for (Wines element in tempTastedWines) { // TODO comprobar correcto funcionamiento
      // Lista de indices donde ha catado el usuario
      List<int> userIndex = [];
      for (var i = 0; i < element.usuarios.length; i++) {
        if (element.usuarios[i] == mail) {
          userIndex.add(i);
        }
      }
      
      for (var i = 0; i < userIndex.length; i++) {
        // Creo vino temporal
        Wines tempWine = Wines(
          anada: element.anada, 
          bodega: element.bodega, 
          comentarios: [],
          descripcion: element.descripcion, 
          fechas: [], 
          graduacion: element.graduacion,
          id: element.id,
          nombre: element.nombre, 
          notaBoca: element.notaBoca, 
          notaNariz: element.notaNariz, 
          notaVista: element.notaVista, 
          notasBoca: [], 
          notasNariz: [], 
          notasVista: [], 
          puntuacionBoca: element.puntuacionBoca, 
          puntuacionFinal: element.puntuacionFinal, 
          puntuacionNariz: element.puntuacionNariz, 
          puntuacionVista: element.puntuacionVista, 
          puntuaciones: [], 
          puntuacionesBoca: [], 
          puntuacionesNariz: [], 
          puntuacionesVista: [], 
          region: element.region, 
          tipo: element.tipo, 
          usuarios: [], 
          variedades: element.variedades, 
          vino: element.vino
        );

        // Añado a tempWine solo los valores de cada cata de usuario, y si hay mas de una con el ciclo for lo añade
        tempWine.comentarios.add(element.comentarios[userIndex[i]]);
        tempWine.fechas.add(element.fechas[userIndex[i]]);
        if (userIndex.length > 1) {
          tempWine.id = element.id! + i.toString();
        }
        tempWine.notasBoca.add(element.notasBoca[userIndex[i]]);
        tempWine.notasNariz.add(element.notasNariz[userIndex[i]]);
        tempWine.notasVista.add(element.notasVista[userIndex[i]]);
        tempWine.puntuaciones.add(element.puntuaciones[userIndex[i]]);
        tempWine.puntuacionesBoca.add(element.puntuacionesBoca[userIndex[i]]);
        tempWine.puntuacionesNariz.add(element.puntuacionesNariz[userIndex[i]]);
        tempWine.puntuacionesVista.add(element.puntuacionesVista[userIndex[i]]);
        tempWine.usuarios.add(element.usuarios[userIndex[i]]);

        userTastedWines.add(tempWine);
      }
    }
    // Ordeno userTastedWines by rate
    userTastedWines.sort((a, b) => b.puntuaciones[0].compareTo(a.puntuaciones[0]));

    return userTastedWines;
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

    final String jsonUpdateType = 'wines/${wine.id}.json';
    final url = Uri.https(_baseUrl, jsonUpdateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.put(url, body: wine.toJson());

    // Actualizar el listado de productos
    int id =  winesByIndex.indexWhere((element) => element.id == wine.id);
    winesByIndex[id] = wine;

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
    final resp = await http.put(url, body: wine.toJson());

    winesByIndex.add(wine);
    updateWinesByRate();

    isSaving = false;
    notifyListeners();

    return resp.body;
  }

  Future<String> saveDeleteLatestTastedWine({required Wines wine, required String email, required String displayName}) async {   
    // Creo id de firebase con la fecha custom
    final String idFirebase =  CustomDatetime().toText(DateTime.now());
    // Subo displayName a Firebase dejo lo necesario
    displayName == ''
      ? wine.displayName = email
      : wine.displayName = displayName;
    // Subo ultimo vino catado a Firebase
    final String jsonCreateType = 'latest/$idFirebase.json'; 
    final url = Uri.https(_baseUrl, jsonCreateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.put(url, body: wine.toJson());

    // TODO de momento no limito los maximos vinos
    // if (winesLatestTasted.length > 100) {

    //   loadLatestWines();
    //   final urlDelete = Uri.https(_baseUrl, 'latest/${winesLatestTasted.last.id}.json', {
    //     'auth': await storage.read(key: 'idToken') ?? ''
    //   });

    //   await http.delete(urlDelete);

    // }

    winesLatestTasted.insert(0, wine);

    return resp.body;
  }

  Future<String> likesCount(Wines wine) async {

    loadLatestWines();

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



}