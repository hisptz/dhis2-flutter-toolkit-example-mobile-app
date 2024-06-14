import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  D2User? _currentUser;

  D2User? get user {
    return _currentUser;
  }

  bool get initialized {
    return _currentUser != null;
  }

  UserState init(D2ObjectBox? db) {
    if (db != null) {
      _currentUser = D2UserRepository(db).get();
      notifyListeners();
    }
    return this;
  }
}
