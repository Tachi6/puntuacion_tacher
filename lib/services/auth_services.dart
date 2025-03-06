
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum UserLoginStatus {notLogged, logged, registering}

class AuthServices extends ChangeNotifier {

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAgjYaZLrRcGjzh0nDCYnFMeP5pMDnq_zA';
  final String _unencodedPathRegister = '/v1/accounts:signUp';
  final String _unencodedPathLogin = '/v1/accounts:signInWithPassword';
  final String _unencodedPathUpdate = '/v1/accounts:update';

  String userEmail = '';
  String userUuid = '';
  String userDisplayName = '';
  String userInitial = '';
  String _tempDisplayName = '';
  bool _isUserLogued = false;

  final storage = const FlutterSecureStorage();

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
      userUuid = decodedResp['localId'];
      userEmail = email;
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
      await storage.write(key: 'localId', value: decodedResp['localId']);

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

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
      await storage.write(key: 'displayName', value: decodedResp['displayName']);
      await storage.write(key: 'localId', value: decodedResp['localId']);
      userUuid = decodedResp['localId'];
      userEmail = email;
      if (decodedResp['displayName'] != '') {
        userDisplayName = decodedResp['displayName'];
        userInitial = decodedResp['displayName'][0].toUpperCase();
        tempDisplayName = decodedResp['displayName'];
      }

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

  Future<String?> changeDisplayName(String displayName) async {

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
      userInitial = decodedResp['displayName'][0].toUpperCase();
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
    userEmail = '';
    userUuid = '';
    userDisplayName = '';
    userInitial = '';
    _tempDisplayName = '';
    _isUserLogued = false;
  }

  Future<UserLoginStatus> isUserLoggedLoadData(Future<void> Function() loadData) async {
    final String? idToken = await storage.read(key: 'idToken');
    if (idToken == null) return UserLoginStatus.notLogged;

    if (isUserLogued) {
      await loadData();
      return UserLoginStatus.logged;
    }

    final String? email = await storage.read(key: 'email');
    final String? password = await storage.read(key: 'password');
    final String? resp = await loginUser(email!, password!);
    if (resp != null) return UserLoginStatus.notLogged;
    
    final String? displayName = await storage.read(key: 'displayName');
    if (displayName == '') return UserLoginStatus.registering;

    await Future.delayed(const Duration(milliseconds: 500));
    await loadData();
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