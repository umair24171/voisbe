import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isLogin = false;

  setIslogin(bool value) {
    isLogin = value;
    notifyListeners();
  }
}
