// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $mainRoute,
      $moduleSelectionRoute,
      $loginRoute,
    ];

RouteBase get $mainRoute => GoRouteData.$route(
      path: '/',
      factory: $MainRouteExtension._fromState,
    );

extension $MainRouteExtension on MainRoute {
  static MainRoute _fromState(GoRouterState state) => MainRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $moduleSelectionRoute => GoRouteData.$route(
      path: '/modules',
      name: 'modules-list',
      factory: $ModuleSelectionRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'tracker-program',
          factory: $TrackerProgramHomeRouteExtension._fromState,
        ),
      ],
    );

extension $ModuleSelectionRouteExtension on ModuleSelectionRoute {
  static ModuleSelectionRoute _fromState(GoRouterState state) =>
      ModuleSelectionRoute();

  String get location => GoRouteData.$location(
        '/modules',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TrackerProgramHomeRouteExtension on TrackerProgramHomeRoute {
  static TrackerProgramHomeRoute _fromState(GoRouterState state) =>
      TrackerProgramHomeRoute();

  String get location => GoRouteData.$location(
        '/modules/tracker-program',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      name: 'login',
      factory: $LoginRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'metadata',
          factory: $InitialMetadataDownloadRouteExtension._fromState,
        ),
      ],
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $InitialMetadataDownloadRouteExtension
    on InitialMetadataDownloadRoute {
  static InitialMetadataDownloadRoute _fromState(GoRouterState state) =>
      InitialMetadataDownloadRoute();

  String get location => GoRouteData.$location(
        '/login/metadata',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
