import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  D2UserCredential? _credential;

  D2UserCredential? get credentials {
    return _credential;
  }

  bool get isLoggedIn {
    return _credential != null;
  }

  //Sets the current user from auth service
  Future<D2UserCredential?> init() async {
    _credential = await D2AuthService().currentUser();
    notifyListeners();
    return credentials;
  }

  Future<void> logout() async {
    return await D2AuthService().logoutUser();
  }

  Future<D2UserCredential?> login(
      {required String username, required String password, required baseURL}) async {
    _credential = await D2AuthService()
        .login(baseURL: baseURL, username: username, password: password);
    notifyListeners();
    return credentials;
  }
}