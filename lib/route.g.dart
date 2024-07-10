// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $mainRoute,
      $moduleSelectionRoute,
      $loginRoute,
      $splashRoute,
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
          path: 'program/:uid',
          factory: $ProgramHomeRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'dataset/:uid',
          factory: $DatasetHomeRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'about-information',
          factory: $AboutInformationHomeRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'data-synchronization',
          factory: $DataSynchronizationHomeRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'metadata-download',
          factory: $MetadataDownloadHomeRouteExtension._fromState,
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

extension $ProgramHomeRouteExtension on ProgramHomeRoute {
  static ProgramHomeRoute _fromState(GoRouterState state) => ProgramHomeRoute(
        uid: state.pathParameters['uid']!,
      );

  String get location => GoRouteData.$location(
        '/modules/program/${Uri.encodeComponent(uid)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DatasetHomeRouteExtension on DatasetHomeRoute {
  static DatasetHomeRoute _fromState(GoRouterState state) => DatasetHomeRoute(
        uid: state.pathParameters['uid']!,
      );

  String get location => GoRouteData.$location(
        '/modules/dataset/${Uri.encodeComponent(uid)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AboutInformationHomeRouteExtension on AboutInformationHomeRoute {
  static AboutInformationHomeRoute _fromState(GoRouterState state) =>
      AboutInformationHomeRoute();

  String get location => GoRouteData.$location(
        '/modules/about-information',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DataSynchronizationHomeRouteExtension
    on DataSynchronizationHomeRoute {
  static DataSynchronizationHomeRoute _fromState(GoRouterState state) =>
      DataSynchronizationHomeRoute();

  String get location => GoRouteData.$location(
        '/modules/data-synchronization',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MetadataDownloadHomeRouteExtension on MetadataDownloadHomeRoute {
  static MetadataDownloadHomeRoute _fromState(GoRouterState state) =>
      MetadataDownloadHomeRoute();

  String get location => GoRouteData.$location(
        '/modules/metadata-download',
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

RouteBase get $splashRoute => GoRouteData.$route(
      path: '/splash',
      name: 'splash',
      factory: $SplashRouteExtension._fromState,
    );

extension $SplashRouteExtension on SplashRoute {
  static SplashRoute _fromState(GoRouterState state) => SplashRoute();

  String get location => GoRouteData.$location(
        '/splash',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
