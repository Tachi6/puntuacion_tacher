
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool _passwordObscure = true;
  
  String email = '';
  String password = '';

  bool _isLoading = false;
  bool _isRegister = false;

  bool get isLoading => _isLoading;
  bool get isRegister => _isRegister;

  set isLoading( bool value ) {
    _isLoading = value;
    notifyListeners();
  }

  set isRegister( bool value ) {
    _isRegister = value;
    notifyListeners();
  }

  bool isValidForm() {
    return loginFormKey.currentState?.validate() ?? false;
  }

  bool get passwordObscure => _passwordObscure;

  set passwordObscure(bool value) {
    _passwordObscure = value;
    notifyListeners();
  }

}