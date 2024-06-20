import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_navigation_type.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';
import 'package:flutter/material.dart';

class AppModuleSelectionUtil {
  D2ObjectBox db;

  AppModuleSelectionUtil(this.db);

  List<AppModule> getAppModuleByType({String type = ''}) {
    return appModules
        .where((AppModule appModule) => appModule.type == type)
        .toList();
  }

  AppModule? getAppModuleById(String id) {
    return appModules
        .firstWhereOrNull((AppModule appModule) => appModule.id == id);
  }

  List<AppModule> get appModules {
    return [
      AppModule(
        title: 'Tracker Program',
        description: 'Gathers tracker data.',
        countLabel: 'Number of events',
        type: AppNavigationType.dataType,
        color: CustomColor.primaryColor,
        svgIcon: 'assets/icons/family-folder-icon.svg',
        homeRoutePath: '/tracker-program',
        isSearchApplicable: true,
        programs: ['ImU7LBc4QwD'],
        dataType: ModuleDataType.tracker,
        // helper: FamilyFolderHelper(),
        // supportedFilters: [
        //   EnrolledAtFilter(db),
        //   OccurredAtFilter<D2Enrollment>(db),
        //   SyncStatusFilter<D2Enrollment>(db),
        // ],
        // supportedSearch: [
        //   AttributeSearchFilter(db,
        //       programId: 'ImU7LBc4QwD',
        //       label: 'Household Number',
        //       id: 'householdId',
        //       icon: Icons.home_outlined),
        //   MemberFilter(db),
        // ],
        db: db,
      ),
      AppModule(
        title: 'Event Program',
        description: 'Gathers tracker event data.',
        countLabel: 'Number of events',
        type: AppNavigationType.dataType,
        color: Colors.amber,
        svgIcon: 'assets/icons/family-folder-icon.svg',
        homeRoutePath: '/event-program',
        isSearchApplicable: true,
        programs: ['qjFCUqsA0vZ'],
        dataType: ModuleDataType.event,
        db: db,
      ),
      AppModule(
        id: 'metadata-download',
        title: 'Metadata Download',
        type: AppNavigationType.actionType,
        color: CustomColor.primaryColor,
        svgIcon: 'assets/icons/metadata-download-icon.svg',
        homeRoutePath: '/metadata-download',
      ),
      AppModule(
        title: 'Data Synchronization',
        type: AppNavigationType.actionType,
        color: CustomColor.primaryColor,
        svgIcon: 'assets/icons/data-synchronizatiom-icon.svg',
        homeRoutePath: '/data-synchronization',
      ),
      AppModule(
        title: 'Logout',
        type: AppNavigationType.actionType,
        color: CustomColor.primaryColor,
        svgIcon: 'assets/icons/logout-icon.svg',
        isLogOutModule: true,
      ),
      AppModule(
        title: 'About Application',
        type: AppNavigationType.infoType,
        color: CustomColor.primaryColor,
        svgIcon: 'assets/icons/app-info-icon.svg',
        homeRoutePath: '/about-information',
      ),
    ];
  }
}
