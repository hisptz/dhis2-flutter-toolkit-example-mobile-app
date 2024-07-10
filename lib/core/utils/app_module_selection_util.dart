
import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/program_state/program_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_navigation_type.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/aggregate_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/event_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/tracker_helper.dart';
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
    List<D2DataSet> dataSets = programRepo.getAllDataSets();

  

    List<AppModule> modules = [
      AppModule(
        id: 'metadata-download',
        title: 'Metadata Download',
        type: AppNavigationType.actionType,
        color: CustomColor.primaryColor,
        homeRoutePath: '/metadata-download',
      ),
      AppModule(
        title: 'Data Synchronization',
        type: AppNavigationType.actionType,
        color: CustomColor.primaryColor,
        homeRoutePath: '/data-synchronization',
      ),
      AppModule(
        title: 'Logout',
        type: AppNavigationType.actionType,
        color: CustomColor.primaryColor,
        isLogOutModule: true,
      ),
      AppModule(
        title: 'About Application',
        type: AppNavigationType.infoType,
        color: CustomColor.primaryColor,
        homeRoutePath: '/about-information',
      ),
    ];

    for (D2Program program in programs) {
      modules.add(AppModule(
        title: program.name,
        icon: Icons.add_home_outlined,
        countLabel: 'Number of Events',
        helper: program.programType == 'WITH_REGISTRATION'
                ? TrackerHelper()
                : EventHelper(),
        description: 'Program Description',
        type: AppNavigationType.dataType,
        programs: [program.uid],
        dataType: program.programType == 'WITH_REGISTRATION'
            ? ModuleDataType.tracker
            : ModuleDataType.event,
        color: program.dartColor ?? CustomColor.primaryColor,
        homeRoutePath: '/program/${program.uid}',
        db: db,
      ));
    }
    for (D2DataSet dataSet in dataSets) {
      modules.add(AppModule(
        title: dataSet.name,
        icon: Icons.add_home_outlined,
        countLabel: 'Number of Events',
        helper: AggregateHelper(),
        description: 'dataSet Description',
        type: AppNavigationType.dataType,
        dataSets: [dataSet.uid],
        dataType: ModuleDataType.aggregate,
        color:  CustomColor.primaryColor,
        homeRoutePath: '/dataset/${dataSet.uid}',
        db: db,
      ));
    }

    return modules;
  }
}
