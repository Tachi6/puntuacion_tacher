
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAgjYaZLrRcGjzh0nDCYnFMeP5pMDnq_zA';
  final String _unencodedPathRegister = '/v1/accounts:signUp';
  final String _unencodedPathLogin = '/v1/accounts:signInWithPassword';
  final String _unencodedPathUpdate = '/v1/accounts:update';

  String userEmail = '';
  String userDisplayName = '';
  String _tempDisplayName = '';
  bool _isSavingUser = false;

  final storage = const FlutterSecureStorage();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // Si retornamos algo es un error, sino todo esta bien
  Future<String?> createUser(String email, String password) async {
    
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, _unencodedPathRegister, {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'email', value: email);
      userEmail = email;
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
      notifyListeners();

      return null;
    } 
    else {
      return decodedResp['error']['message'];
    }
  }

  // Si retornamos algo es un error, sino todo esta bien
  Future<String?> loginUser(String email, String password) async {
    
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, _unencodedPathLogin, {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'email', value: email);
      userEmail = email;
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
      await storage.write(key: 'displayName', value: decodedResp['displayName']);
      userDisplayName = decodedResp['displayName'];
      notifyListeners();
      return null;
    } 
    else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> renameUser(String displayName) async {

    final idToken = await storage.read(key: 'idToken');

    final Map<String, dynamic> authData = {
      'idToken': idToken,
      'displayName': displayName,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, _unencodedPathUpdate, {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('displayName')) {
      await storage.write(key: 'displayName', value: decodedResp['displayName']);
      userDisplayName = decodedResp['displayName'];
      notifyListeners();

      return null;
    }
    else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.deleteAll();
  }

  Future<String> readIdToken() async {
    return await storage.read(key: 'idToken') ?? '';
  }

  String get tempDisplayName => _tempDisplayName;

  set tempDisplayName(String value) {
    _tempDisplayName = value;
    notifyListeners();
  }

  bool get isSavingUser => _isSavingUser;

  set isSavingUser(bool isSaving) {
    _isSavingUser = isSaving;
    notifyListeners();
  }
}