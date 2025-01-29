import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserServices extends ChangeNotifier  {
  
  final String _baseUrl = 'puntos-tacher-default-rtdb.europe-west1.firebasedatabase.app';
  final String _jsonType = 'uuid.json';

  final storage = const FlutterSecureStorage();

  Map<String, dynamic> users = {};

  Future<void> loadUsers() async {

    final url = Uri.https(_baseUrl, _jsonType, {
      'auth': await storage.read(key: 'idToken') ?? ''
    });

    final resp = await http.get(url);

    final Map<String, dynamic> usersMap = json.decode(resp.body);

    users = usersMap;
  }

  String obtainDisplayName(String uuid) {
    // Todo delete not uuid check
    return users[uuid] ?? uuid;
  }
}