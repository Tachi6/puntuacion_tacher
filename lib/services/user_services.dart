import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserServices extends ChangeNotifier  {
  UserServices();
  
  final String _baseUrl = 'puntos-tacher-default-rtdb.europe-west1.firebasedatabase.app';
  final String _jsonUuidType = 'uuid.json';
  final String _jsonUserType = 'users.json';

  final storage = const FlutterSecureStorage();

  Map<String, dynamic> users = {};

  Future<void> loadUsers() async {

    final url = Uri.https(_baseUrl, _jsonUuidType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });

    final resp = await http.get(url);

    final Map<String, dynamic> usersMap = json.decode(resp.body);

    users = usersMap;
    notifyListeners();
  }

  String obtainDisplayName(String uuid) {
    // Todo delete not uuid check
    return users[uuid] ?? uuid;
  }

  Future<void> updateUuidDisplayName(String displayName) async {

    final url = Uri.https(_baseUrl, _jsonUuidType, {
      'auth': await storage.read(key: 'idToken') ?? '',
    });
    
    final String userUuid = await storage.read(key: 'localId') ?? '';

    final Map<String, String> data = {
      userUuid: displayName
    };

    await http.patch(url, body: jsonEncode(data));
  }

  Future<bool> isUniqueDisplayName(String newDisplayName) async {

    final String oldDisplayName = await storage.read(key: 'displayName') ?? '';
    final String jsonDeleteType = 'users/$oldDisplayName.json';

    final url = Uri.https(_baseUrl, _jsonUserType, {
      'auth': await storage.read(key: 'idToken') ?? '',
    });

    final Map<String, String> data = {
      newDisplayName: ""
    };

    final resp = await http.patch(url, body: jsonEncode(data));

    final urlDelete = Uri.https(_baseUrl, jsonDeleteType, {
      'auth': await storage.read(key: 'idToken') ?? '',
    });

    await http.delete(urlDelete);

    if(resp.statusCode == 200) return true;

    return false;
  }
}