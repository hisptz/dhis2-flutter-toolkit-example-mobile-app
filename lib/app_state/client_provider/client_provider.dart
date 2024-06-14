import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class D2ClientState with ChangeNotifier {
  D2ClientService? _client;

  get client {
    if (_client == null) {
      throw 'You need to call init first before accessing client';
    }
    return _client;
  }

  init(D2UserCredential? credentials) {
    if (credentials != null) {
      _client = D2ClientService(credentials);
      notifyListeners();
    }
    return this;
  }
}
