// import 'package:collection/collection.dart';
// import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
// import 'package:dhis2_flutter_toolkit/objectbox.dart';
// import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
// import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_navigation_type.dart';
// import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
// import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';

// class AppModuleSelectionUtil {
//   final D2ObjectBox db;
//   List<AppModule> appModules = [];
//   final PagingController<int, D2Program> _pagingController =
//       PagingController(firstPageKey: 0);

//   AppModuleSelectionUtil(this.db) {
//     initializePaging();
//   }
//   List<AppModule> getAppModuleByType({String type = ''}) {
//     return appModules
//         .where((AppModule appModule) => appModule.type == type)
//         .toList();
//   }

//   AppModule? getAppModuleById(String id) {
//     return appModules
//         .firstWhereOrNull((AppModule appModule) => appModule.id == id);
//   }

//   void initializePaging() {
//     _pagingController.addPageRequestListener((pageKey) {
//       fetchPage(pageKey);
//     });
//   }

//   Future<void> fetchPage(int pageKey) async {
//     int offset = pageKey * 50;
//     const int limit = 50;

//     D2ProgramRepository repository = D2ProgramRepository(db);
//     QueryBuilder<D2Program> queryBuilder = repository.queryBuilder;
//     Query<D2Program> query = queryBuilder.build();

//     query
//       ..offset = offset
//       ..limit = limit;

//     List<D2Program> entities = await query.findAsync();
//     final isLastPage = entities.length < limit;

//     if (isLastPage) {
//       _pagingController.appendLastPage(entities);
//     } else {
//       final nextPageKey = pageKey + 1;
//       _pagingController.appendPage(entities, nextPageKey);
//     }
//   }

//   void dispose() {
//     _pagingController.dispose();
//   }

//   List<AppModule> getAppModules() {
//     List<AppModule> appModulesList = [];

//     // Adding static AppModules
//     appModulesList.addAll([
//       AppModule(
//         title: 'Tracker Program',
//         description: 'Gathers tracker data.',
//         countLabel: 'Number of events',
//         type: AppNavigationType.dataType,
//         color: CustomColor.primaryColor,
//         svgIcon: 'assets/icons/family-folder-icon.svg',
//         homeRoutePath: '/tracker-program',
//         isSearchApplicable: true,
//         programs: ['uy2gU8kT1jF'],
//         dataType: ModuleDataType.tracker,
//         db: db,
//       ),
//       AppModule(
//         id: 'metadata-download',
//         title: 'Metadata Download',
//         type: AppNavigationType.actionType,
//         color: CustomColor.primaryColor,
//         svgIcon: 'assets/icons/metadata-download-icon.svg',
//         homeRoutePath: '/metadata-download',
//       ),
//       AppModule(
//         title: 'Data Synchronization',
//         type: AppNavigationType.actionType,
//         color: CustomColor.primaryColor,
//         svgIcon: 'assets/icons/data-synchronizatiom-icon.svg',
//         homeRoutePath: '/data-synchronization',
//       ),
//       AppModule(
//         title: 'Logout',
//         type: AppNavigationType.actionType,
//         color: CustomColor.primaryColor,
//         svgIcon: 'assets/icons/logout-icon.svg',
//         isLogOutModule: true,
//       ),
//       AppModule(
//         title: 'About Application',
//         type: AppNavigationType.infoType,
//         color: CustomColor.primaryColor,
//         svgIcon: 'assets/icons/app-info-icon.svg',
//         homeRoutePath: '/about-information',
//       ),
//     ]);

//     // Converting D2Programs to AppModules
//     for (var program in _pagingController.itemList ?? []) {
//       appModulesList.add(AppModule(
//         title: program.name ?? '',
//         description: 'Program Description',
//         type: AppNavigationType.dataType,
//         color: program.dartColor ?? CustomColor.primaryColor,
//         svgIcon: 'assets/icons/program-icon.svg',
//         homeRoutePath: '/program/${program.uid}',
//         isSearchApplicable: true,
//         programs: [program.uid],
//         dataType: program.programType == 'WITH_REGISTRATION'
//             ? ModuleDataType.tracker
//             : ModuleDataType.event,
//         db: db,
//       ));
//     }

//     return appModulesList;
//   }
// }




import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/program_state/program_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_navigation_type.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';

class AppModuleSelectionUtil {
  D2ObjectBox db;
  // D2User 

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


  Future<List<D2Program>> getPrograms({required int offset, required int limit}) {
    ProgramRepository programRepo = ProgramRepository(db);
    return programRepo.getPrograms(offset: offset, limit: limit);
  }

  Future<List<D2DataSet>> getDatasets({required int offset, required int limit}) {
    ProgramRepository programRepo = ProgramRepository(db);
    return programRepo.getDatasets(offset: offset, limit: limit);
  }

  List<AppModule> get appModules {
    // Fetch D2Program data and add to the modules list
    // ProgramRepository programRepo = ProgramRepository(db);
    // List<D2Program> programs = programRepo.getAllPrograms();
  

    List<AppModule> modules = [
      // AppModule(
      //   title: 'Tracker Program',
      //   description: 'Gathers tracker data.',
      //   countLabel: 'Number of events',
      //   type: AppNavigationType.dataType,
      //   color: CustomColor.primaryColor,
      //   svgIcon: '',
      //   homeRoutePath: '/tracker-program',
      //   isSearchApplicable: true,
      //   programs: ['uy2gU8kT1jF'],
      //   dataType: ModuleDataType.tracker,
      //   db: db,
      // ),
      // AppModule(
      //   title: 'Event Program',
      //   description: 'Gathers tracker event data.',
      //   countLabel: 'Number of events',
      //   type: AppNavigationType.dataType,
      //   color: Colors.green,
      //   svgIcon: '',
      //   homeRoutePath: '/event-program',
      //   isSearchApplicable: true,
      //   programs: ['MoUd5BTQ3lY'],
      //   dataType: ModuleDataType.event,
      //   db: db,
      // ),
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

    // for (D2Program program in programs) {
    //   modules.add(AppModule(
    //     title: program.name,
    //     description: 'Program Description',
    //     type: AppNavigationType.dataType,
    //     programs: [program.uid],
    //     dataType: program.programType == 'WITH_REGISTRATION'
    //         ? ModuleDataType.tracker
    //         : ModuleDataType.event,
    //     color: program.dartColor ?? CustomColor.primaryColor,
    //     svgIcon: 'assets/icons/program-icon.svg',
    //     homeRoutePath: '/program/${program.uid}',
    //     db: db,
    //   ));
    // }

    return modules;
  }
}
