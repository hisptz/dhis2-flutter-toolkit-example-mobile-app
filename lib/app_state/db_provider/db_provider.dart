import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:flutter/foundation.dart';

Admin? admin;

class DBState extends ChangeNotifier {
  D2ObjectBox? _db;

  get db {
    if (_db == null) {
      throw 'DBState not initialized. You need to call init first';
    }
    return _db;
  }

  get initialized {
    return _db != null;
  }

  close() {
    _db?.store.close();
    _db = null;
  }

  Future<void> initializeDb(D2UserCredential credentials) async {
    _db = await D2ObjectBox.create(credentials);
    if (kDebugMode && Admin.isAvailable() && _db != null) {
      admin = Admin(_db!.store);
    }
    notifyListeners();
  }

  Future<void> init(D2UserCredential? credentials) async {
    if (credentials == null) {
      if (_db != null) {
        close();
      }
      return;
    }
    if (_db != null) {
      if (_db!.storeId != credentials.id) {
        debugPrint(
            'Inconsistencies of store with credentials has been detected!! Please investigate this issue in the DBProvider');
        //Fail-safe
        _db!.store.close();
        initializeDb(credentials);
        return;
      }

      if (kDebugMode) {
        debugPrint('STORE already initialized. Ignoring...');
      }
      return;
    }
    await initializeDb(credentials);
    return;
  }
}
