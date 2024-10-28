import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:puntuacion_tacher/models/models.dart';

class MultipleService extends ChangeNotifier {

  final String _baseUrl = 'puntos-tacher-default-rtdb.europe-west1.firebasedatabase.app';
  final String _jsonTypeMultiple = 'multiple.json';

  List<Multiple> multipleTasteList = [];

  final storage = const FlutterSecureStorage();

  MultipleService() {
    loadMultiple();
  }

  Future loadMultiple() async {
    List<Multiple> tempMultipleTasteList = [];
    // Cargo las catas multiples de bdd
    final url = Uri.https(_baseUrl, _jsonTypeMultiple, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.get(url);
    // Decodifico en un mapa pa respuesta
    final Map<String, dynamic> multipleResponse = json.decode(resp.body);
    // Añado al listado cada una de las catas multiples
    multipleResponse.forEach((key, value) {
      final tempMultipleTaste = Multiple.fromJson(value);
      tempMultipleTaste.name = key;
      tempMultipleTasteList.add(tempMultipleTaste);
    });
    // Asigno nuevo listado
    multipleTasteList = tempMultipleTasteList;

    print('catas multiple cargadas');

    notifyListeners();
  }

  Future<String> createMultipleTaste(Multiple multipleTaste) async {
    // Creo nueva cata multiple
    final String jsonCreateType = 'multiple/${multipleTaste.name}.json';
    final url = Uri.https(_baseUrl, jsonCreateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    final resp = await http.put(url, body: multipleTaste.toRawJson());
    notifyListeners();

    return resp.body;
  }

  Future<void> updateAverageRatings({required String multipleName, required Map<String, AverageRatings> averageRatings}) async {
    // Actualizo resultados de cata multiple
    averageRatings.forEach((key, value) async {
      final String jsonCreateType = 'multiple/$multipleName/averageRatings/$key.json';
      final url = Uri.https(_baseUrl, jsonCreateType, {
        'auth': await storage.read(key: 'idToken') ?? ''
      });
      await http.put(url, body: value.toRawJson());
      
    },);
  }

  Future<void> createUserMultipleTaste({required String multipleName, required List<WineTaste> userMultipleTaste}) async {
    // Busco indice de la cata multiple para posteriormente eliminar posibles inicializaciones vacias ('notStarted')
    final int index = multipleTasteList.indexWhere((element) => element.name == multipleName);
    // Creo map temporal para añadir los WineTaste
    Map<String, WineTaste> userMultipleTasteMap = {};
    // Paso listado de List<WineTaste> a Map<String, WineTaste>
    for (var element in userMultipleTaste) {
      final String date = CustomDatetime().toText(DateTime.now());
      // Añado fecha de cata al WineTaste
      element.fecha = date;
      // Creo nueva entrada para en map
      final Map<String, WineTaste> newTaste = {
        date: element,
      };
      // Añado al tempMap
      userMultipleTasteMap = {...userMultipleTasteMap, ...newTaste};
    }
    // Mapeo el nuevo tempTasteMap
    userMultipleTasteMap.forEach((key, value) async {
      // Para que el key (que es la fecha de la cata) y la fecha del WineTaste sean completamente iguales
      value.fecha = key;
      // Creo nueva cata multiple
      final String jsonUpdateType = 'multiple/$multipleName/wines/${value.id}/$key.json';
      final url = Uri.https(_baseUrl, jsonUpdateType, {
        'auth': await storage.read(key: 'idToken') ?? ''
      });
      await http.put(url, body: value.toRawJson());
      // Compruebo si la cata esta iniciada
      final bool delete = multipleTasteList[index].wines[value.id]!.containsKey('notStarted');
      // Elimino la inicializacion vacia de la cata si existe
      if (delete) {
        final urlDelete = Uri.https(_baseUrl, 'multiple/$multipleName/wines/${value.id}/notStarted.json', {
          'auth': await storage.read(key: 'idToken') ?? ''
        });
        await http.delete(urlDelete);
      }
    },);

    notifyListeners();   
  }

  bool isMultipleNameUsed(String multipleName) {
    // Evaluo si el nombre del vino ya ha sido usado anteriomente
    return multipleTasteList.any((element) => element.name == multipleName);
  }

  bool isMultipleTasted({required String multipleName, required String user}) {
    // Obtengo el indice de la cata multiple
    final int index = multipleTasteList.indexWhere((element) => element.name == multipleName);
    // Si no obtengo indice, es cata nueva, salgo de la funcion y prosigo
    if (index == -1) return false;
    // Obtengo en id del primer vino
    final String firstWine = multipleTasteList[index].wines.keys.toList().first;
    // Evaluo si el primer vino ha sido catado, porque solo se sube a firebase si todos los vinos estan catados
    return multipleTasteList[index].wines[firstWine]!.entries.any((element) => element.value.user == user);
  }
}