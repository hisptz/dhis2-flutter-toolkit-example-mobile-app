import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/navigation_drawer/navigation_drawer_category_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/navigation_drawer/navigation_drawer_header_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/navigation_drawer/navigation_logout_confirmation_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_navigation_type.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NavigationDrawerContainer extends StatefulWidget {
  const NavigationDrawerContainer({super.key});

  @override
  State<NavigationDrawerContainer> createState() =>
      _NavigationDrawerContainerState();
}

class _NavigationDrawerContainerState extends State<NavigationDrawerContainer> {
  bool _shouldDeleteData = false;

  void onUserLogoOut(BuildContext context) async {
    D2AuthService().logoutUser(deleteData: _shouldDeleteData).then((_) {
      Provider.of<AppModuleSelectionState>(context, listen: false)
          .clearSelection();
      if (context.canPop()) {
        context
            .pop(); //TODO: A hack. This should be fixed in the confirmation dialog @chingalo
      }
      context.replace('/splash');
    }).catchError((onError) {
      //TODO popup meessage for the app
    });
  }

  void onSelectAppModule(
    BuildContext context, {
    required AppModule appModule,
  }) {
    if ('${appModule.isLogOutModule}' == 'true') {
      D2AppModalUtil.showPopUpConfirmation(
        context,
        title: 'Logout',
        confirmActionLabel: 'Logout',
        confirmationContent: NavigationLogoutConfirmationContainer(
          onChanges: (bool value) {
            _shouldDeleteData = value;
            setState(() {});
          },
        ),
        confirmationButtomThemColor: const Color(0xFFB21E35),
        onConfirm: () => onUserLogoOut(context),
      );
    } else {
      var currentAppModule =
          Provider.of<AppModuleSelectionState>(context, listen: false)
              .selectedAppModule;
      if (currentAppModule.id != appModule.id) {
        Provider.of<AppModuleSelectionState>(context, listen: false)
            .setSelectedAppModule(appModule: appModule);
      }
      context.go('/modules${appModule.homeRoutePath ?? ''}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const NavigationDrawerHeaderContainer(),
          NavigationDrawerCategoryContainer(
            title: 'Modules',
            appModuleType: AppNavigationType.dataType,
            onTap: (AppModule appModule) => onSelectAppModule(
              context,
              appModule: appModule,
            ),
          ),
          NavigationDrawerCategoryContainer(
            title: 'Actions',
            appModuleType: AppNavigationType.actionType,
            onTap: (AppModule appModule) => onSelectAppModule(
              context,
              appModule: appModule,
            ),
          ),
          NavigationDrawerCategoryContainer(
            title: 'Information',
            appModuleType: AppNavigationType.infoType,
            onTap: (AppModule appModule) => onSelectAppModule(
              context,
              appModule: appModule,
            ),
          ),
        ],
      ),
    );
  }
}
