import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/auth_state/auth_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/about_information/about_information.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/data_synchronization/data_synchronization.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/initial_metadata_download/initial_metadata_download.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/login/login.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/metadata_download/metadata_download.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/program/program_home.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/splash/splash.dart';
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
      return '/splash';
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

        return '/splash';
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
      TypedGoRoute<ProgramHomeRoute>(path: 'program/:uid'),
      TypedGoRoute<AboutInformationHomeRoute>(path: 'about-information'),
      TypedGoRoute<DataSynchronizationHomeRoute>(path: 'data-synchronization'),
      TypedGoRoute<MetadataDownloadHomeRoute>(path: 'metadata-download'),
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


class ProgramHomeRoute extends GoRouteData {
  final String uid;

  ProgramHomeRoute(
      {required this.uid});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProgramHome(
      id: uid,
    );
  }
}


class DataSynchronizationHomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DataSynchronizationHome();
  }
}

class MetadataDownloadHomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MetadataDownloadHome();
  }
}

class AboutInformationHomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutInformationHome();
  }
}

@TypedGoRoute<SplashRoute>(path: '/splash', name: 'splash')
@immutable
class SplashRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Splash();
  }
}
