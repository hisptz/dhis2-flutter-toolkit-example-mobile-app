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

  // Static AppModule instances
  static final List<AppModule> staticModules = [
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

  // Fetch programs from the repository with pagination
  Future<List<D2Program>> getPrograms({required int offset, required int limit}) {
    ProgramRepository programRepo = ProgramRepository(db);
    return programRepo.getPrograms(offset: offset, limit: limit);
  }

  // Fetch datasets from the repository with pagination
  Future<List<D2DataSet>> getDatasets({required int offset, required int limit}) {
    ProgramRepository programRepo = ProgramRepository(db);
    return programRepo.getDatasets(offset: offset, limit: limit);
  }

  List<AppModule> programsList(List<D2Program> programs) {
    return programs.map((program) {
      return AppModule(
        title: program.name,
        countLabel: 'Number of Events',
        description: program.programType == 'WITH_REGISTRATION'
            ? 'Tracker Program'
            : 'Event Program',
        type: AppNavigationType.dataType,
        helper: program.programType == 'WITH_REGISTRATION'
            ? TrackerHelper()
            : EventHelper(),
        programs: [program.uid],
        dataType: program.programType == 'WITH_REGISTRATION'
            ? ModuleDataType.tracker
            : ModuleDataType.event,
        color: program.dartColor ?? CustomColor.primaryColor,
        icon: Icons.add_home_outlined,
        homeRoutePath: '/program/${program.uid}',
        db: db,
      );
    }).toList();
  }

  
  List<AppModule> datasetList(List<D2DataSet> datasets) {
    return datasets.map((dataset) {
      return AppModule(
        title: dataset.name,
        countLabel: 'Number of options',
        description: 'Dataset',
        type: AppNavigationType.dataType,
        programs: [],
        dataSets: [dataset.uid],
        helper: AggregateHelper(),
        dataType: ModuleDataType.aggregate,
        color: CustomColor.primaryColor,
        icon: Icons.add_home_outlined,
        homeRoutePath: '/dataset/${dataset.uid}',
        db: db,
      );
    }).toList();
  }

  // Get all AppModules including static ones
  List<AppModule> get appModules {
    List<AppModule> modules = List.from(staticModules);
    ProgramRepository programRepo = ProgramRepository(db);
    List<D2Program> programs = programRepo.getAllPrograms();
    List<D2DataSet> dataSets = programRepo.getAllDataSets();

    modules.addAll(programsList(programs));
    modules.addAll(datasetList(dataSets));
    return modules;
  }

   Future<List<AppModule>> getDynamicModules({required bool isProgram, required int offset, required int limit}) async {
    if (isProgram) {
      List<D2Program> programs = await getPrograms(offset: offset, limit: limit);
      return programsList(programs);
    } else {
      List<D2DataSet> datasets = await getDatasets(offset: offset, limit: limit);
      return datasetList(datasets);
    }
  }

  // Get AppModules by type
  List<AppModule> getAppModuleByType({String type = ''}) {
    return appModules
        .where((AppModule appModule) => appModule.type == type)
        .toList();
  }

  // Get AppModule by ID
  AppModule? getAppModuleById(String id) {
    return appModules.firstWhereOrNull((AppModule appModule) => appModule.id == id);
  }
}
