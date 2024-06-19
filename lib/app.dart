import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/client_provider/client_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state/auth_state/auth_state.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(
          create: (_) => AppModuleSelectionState(),
        ),
        ChangeNotifierProxyProvider<AppModuleSelectionState,
                SelectedAppModuleDataState>(
            create: (_) => SelectedAppModuleDataState(),
            update: (_, appModule, appModuleData) {
              return SelectedAppModuleDataState.onAppModuleChange(
                  appModule.selectedAppModule);
            }),
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider<DBState>(
          create: (_) => DBState(),
        ),
        ChangeNotifierProxyProvider<AuthState, D2ClientState>(
            create: (_) => D2ClientState(),
            update: (_, appAuth, d2Client) =>
                d2Client?.init(appAuth.credentials)),
        ChangeNotifierProvider<UserState>(
          create: (_) => UserState(),
        )
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'DHIS2 SDK Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: routerConfigurations,
      ),
    );
  }
}
