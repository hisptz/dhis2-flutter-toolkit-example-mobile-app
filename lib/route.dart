import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/auth_state/auth_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/initial_metadata_download/initial_metadata_download.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/login/login.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/tracker_program/tracker_program.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// In case you change the routes in this file, run `dart run build_runner build` to re-generate the route.g.dart file.

part 'route.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final routerConfigurations = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    routes: $appRoutes);

@TypedGoRoute<MainRoute>(path: '/')
class MainRoute extends GoRouteData {
  final GlobalKey<NavigatorState> $navigatorKey = _rootNavigatorKey;

  @override
  FutureOr<String> redirect(BuildContext context, GoRouterState state) async {
    ///This acts as a redirect for all initial navigation.
    AuthState authState = Provider.of<AuthState>(context, listen: false);
    bool isUserLoggedIn = authState.isLoggedIn;
    if (!isUserLoggedIn || authState.credentials == null) {
      print('${isUserLoggedIn}');

      print('${authState.credentials}');
      print('***************************!isUserLoggedIn || authState.credentials == null');
      return '/login';
    }
    D2UserCredential? credentials = authState.credentials;

    DBState dbState = Provider.of<DBState>(context, listen: false);
    if (!dbState.initialized) {
      await dbState.init(credentials);
    }
    UserState userState = Provider.of<UserState>(context, listen: false);
    if (!userState.initialized) {
      userState.init(dbState.db);
      if (!userState.initialized) {
      print('***************************!userState.initialized');

        return '***************************/login';
      }
    }
      print('/module');

    return '/modules';
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Placeholder();
  }
}

@TypedGoRoute<ModuleSelectionRoute>(
    path: '/modules',
    name: 'modules-list',
    routes: [
      TypedGoRoute<TrackerProgramHomeRoute>(path: 'tracker-program'),
    ])
class ModuleSelectionRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ModuleSelection();
  }
}

@TypedGoRoute<LoginRoute>(
    path: '/login',
    name: 'login',
    routes: [TypedGoRoute<InitialMetadataDownloadRoute>(path: 'metadata')])
@immutable
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Login();
  }
}

class InitialMetadataDownloadRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InitialMetadataDownloadPage();
  }
}

class TrackerProgramHomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TrackerProgramHome();
  }
}
