
import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/program_state/program_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_navigation_type.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';

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
    ProgramRepository programRepo = ProgramRepository(db);
    List<D2Program> programs = programRepo.getAllPrograms();
  

    List<AppModule> modules = [
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

    for (D2Program program in programs) {
      modules.add(AppModule(
        title: program.name,
        countLabel: 'Number of Events',
        description: 'Program Description',
        type: AppNavigationType.dataType,
        programs: [program.uid],
        dataType: program.programType == 'WITH_REGISTRATION'
            ? ModuleDataType.tracker
            : ModuleDataType.event,
        color: program.dartColor ?? CustomColor.primaryColor,
        svgIcon: 'assets/icons/program-icon.svg',
        homeRoutePath: '/program/${program.uid}',
        db: db,
      ));
    }

    return modules;
  }
}
