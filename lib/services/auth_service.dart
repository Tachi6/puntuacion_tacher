
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum UserLoginStatus {notLogged, logged, registering}

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
  bool _isUserLogued = false;

  final storage = const FlutterSecureStorage();

  bool isValidLoginRegister() {
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
      await storage.write(key: 'localId', value: decodedResp['localId']); // TODO trabajar con localId en vez que con email en app y en bd

      isUserLogued = true;

      notifyListeners();
      // To refresh user auto every 55 minuts
      refreshUser();

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

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'email', value: email);
      userEmail = email;
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
      await storage.write(key: 'displayName', value: decodedResp['displayName']);
      await storage.write(key: 'localId', value: decodedResp['localId']);
      userDisplayName = decodedResp['displayName'];
      tempDisplayName = decodedResp['displayName'];

      isUserLogued = true;

      notifyListeners();
      // To refresh user auto every 55 minuts
      refreshUser();

      return null;
    } 
    else {
      return decodedResp['error']['message'];
    }
  }

  Future<void> refreshUser() async {

    while (isUserLogued) {
      await Future.delayed(const Duration(seconds: 3300), () async {

        final String? email = await storage.read(key: 'email');
        final String? password = await storage.read(key: 'password');
        
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
          await storage.write(key: 'idToken', value: decodedResp['idToken']);
          notifyListeners();
        } 
      });
    }
    
  }

  Future<bool> isUniqueDisplayName(String newDisplayName) async {

    const String baseUrl = 'puntos-tacher-default-rtdb.europe-west1.firebasedatabase.app';
    const String jsonUpdateType = 'users.json';
    final String idToken = await storage.read(key: 'idToken') ?? '';
    final String oldDisplayName = await storage.read(key: 'displayName') ?? '';
    final String jsonDeleteType = 'users/$oldDisplayName.json';

    final url = Uri.https(baseUrl, jsonUpdateType, {
      'auth': idToken,
    });

    final Map<String, String> data = {
      newDisplayName: ""
    };

    final String json = jsonEncode(data);

    final resp = await http.patch(url, body: json);

    final urlDelete = Uri.https(baseUrl, jsonDeleteType, {
      'auth': idToken,
    });

    await http.delete(urlDelete);

    if(resp.statusCode == 200) return true;

    return false;
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
      tempDisplayName = decodedResp['displayName'];
      notifyListeners();

      return null;
    }
    else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.deleteAll();
    userDisplayName = '';
    _tempDisplayName = '';
    _isUserLogued = false;
  }

  Future<UserLoginStatus> isUserLoggedLoadData(Future<void> Function() loadData) async {
    final String? idToken = await storage.read(key: 'idToken');
    if (idToken == null) return UserLoginStatus.notLogged;

    final String? email = await storage.read(key: 'email');
    final String? password = await storage.read(key: 'password');
    final String? resp = await loginUser(email!, password!);
    if (resp != null) return UserLoginStatus.notLogged;
    
    final String? displayName = await storage.read(key: 'displayName');
    await loadData();
    if (displayName == '') return UserLoginStatus.registering;

    await Future.delayed(const Duration(milliseconds: 500));
    return UserLoginStatus.logged;
  }

  String get tempDisplayName => _tempDisplayName;

  set tempDisplayName(String value) {
    _tempDisplayName = value;
    notifyListeners();
  }

  bool get isUserLogued => _isUserLogued;

  set isUserLogued(bool isUserLogued) {
    _isUserLogued = isUserLogued;
    notifyListeners();
  }
}