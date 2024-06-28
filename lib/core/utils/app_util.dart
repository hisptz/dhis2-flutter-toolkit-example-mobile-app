import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppUtil {
  static Future<void> initializeServices(
      BuildContext context, D2UserCredential? credentials) async {
    if (credentials != null) {
      DBState dbState = Provider.of<DBState>(context, listen: false);
      UserState userState = Provider.of<UserState>(context, listen: false);
      dbState.close();
      await dbState.init(credentials);
      D2ObjectBox? db = dbState.db;
      userState.init(db);
    }
  }

  static initializeUser(BuildContext context) {
    DBState dbState = Provider.of<DBState>(context, listen: false);
    UserState userState = Provider.of<UserState>(context, listen: false);
    userState.init(dbState.db);
  }

  static List<String> getProgramsToSync(D2User? user) {
    print('**********app_Util_getProgramm ${user?.programs}');
    return user?.programs.toList() ?? [];
  }

  static String camelCaseToSnakeCase(String input) {
    if (input.isEmpty) return input; // Return empty string if input is empty

    String snakeCase = input.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match[1]}_${match[2]}',
    );

    return snakeCase.toUpperCase();
  }

  static List<String> getDataSetsToSync(D2User? user) {
     print('**********app_Util_getDataset${user?.dataSets}');
    return user?.dataSets.toList()
            .where((element) => AppConfig.dataSets.contains(element))
            .toList() ??
        [];
  }
}
