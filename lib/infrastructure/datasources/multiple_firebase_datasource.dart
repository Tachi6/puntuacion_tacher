import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:puntuacion_tacher/domain/datasources/multiple_datasource.dart';
import 'package:puntuacion_tacher/domain/entities/entities.dart';

class MultipleFirebaseDatasource extends MultipleDatasource {

  final String _baseUrl = 'puntos-tacher-default-rtdb.europe-west1.firebasedatabase.app';
  final String _jsonMultipleBaseType = 'multiple.json';
  final storage = const FlutterSecureStorage(); //TODO: hacer variable global

  @override
  Future<Multiple> createMultipleTaste(Multiple multipleTaste) async {
    // Creo nueva cata multiple, firebase me crea su id de la entrada
    final postUrl = Uri.https(_baseUrl, _jsonMultipleBaseType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });

    final resp = await http.post(postUrl, body: multipleTaste.toRawJson());
    // Firebase retorna algo asi en el resp.body:  {"name":"-OQgtwB62DSZX9f2Rh9N"}
    final Map<String, dynamic> decodedRespBody = jsonDecode(resp.body);
    final String id = decodedRespBody["name"];
    final String encodedIdMap = jsonEncode({"id": id});
    // Actualizo el id en la nueva entrada creada
    final String jsonUpdateType = 'multiple/$id.json';
    final patchUrl = Uri.https(_baseUrl, jsonUpdateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });

    await http.patch(patchUrl, body: encodedIdMap);
    // Asigno el id al multipleTaste local
    multipleTaste.id = id;

    return multipleTaste;
  }

  @override
  Future<List<Multiple>> loadAllMultipleTaste() async {
    List<Multiple> multipleTasteList = [];
    // Obtengo las catas multiples de bdd
    final url = Uri.https(_baseUrl, _jsonMultipleBaseType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });

    final resp = await http.get(url);
    // Decodifico en un mapa la respuesta
    final Map<String, dynamic> multipleResponse = json.decode(resp.body);
    // Añado al listado cada una de las catas multiples
    multipleResponse.forEach((key, value) {
      final Multiple tempMultipleTaste = Multiple.fromJson(value);
      multipleTasteList.add(tempMultipleTaste);
    });

    return multipleTasteList;
  }

  @override
  Future<Multiple> loadSingleMultipleTaste(String id) async {
    // Obtengo solo la cata multiple que quiero
    final String jsonGetMultiple = 'multiple/$id.json';
    final url = Uri.https(_baseUrl, jsonGetMultiple, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });

    final resp = await http.get(url);
    // Decodifico la respuesta
    final Multiple multipleUpdated = Multiple.fromRawJson(resp.body);
    
    return multipleUpdated;
  }

  @override
  Future<void> updateAverageRatings(String multipleId, Map<String, AverageRatings> averageRatings) async {
    final String jsonUpdateType = '/multiple/$multipleId/averageRatings.json';
    final url = Uri.https(_baseUrl, jsonUpdateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });

    Map<String, Map<String, dynamic>> updateMap = {};
    averageRatings.forEach((key, value) {
      Map<String, Map<String, dynamic>> tempMap = {key: value.toJson()};
      updateMap = {...updateMap, ...tempMap};
    });

    await http.patch(url, body: jsonEncode(updateMap));
  }

  @override
  Future<void> updateMultipleTaste(String multipleId, WineTaste wineTaste) async {
    final String jsonUpdateType = '/multiple/$multipleId/wines/${wineTaste.id}.json';
    final url = Uri.https(_baseUrl, jsonUpdateType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });
    // Codifico el nuevo mapa a subir
    final Map<String, Map<String, dynamic>> updateMap = {
      wineTaste.fecha: wineTaste.toJson(),
    };

    await http.patch(url, body: jsonEncode(updateMap));
  }
  
}