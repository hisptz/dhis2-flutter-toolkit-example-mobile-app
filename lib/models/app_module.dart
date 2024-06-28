
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_navigation_type.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/app_module_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module_aggregate_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module_tracker_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module_tracker_event_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppModule {
  String? id;
  String? title;
  String? description;
  String? countLabel;
  String? type;
  IconData? icon;
  String? svgIcon;
  Color? color;
  bool? isSearchApplicable;
  bool? isLogOutModule;
  String? homeRoutePath;
  List<String>? programs;
  List<String>? dataSets;
  BaseAppModuleHelper? helper;
  ModuleDataType? dataType;
  // List<DataFilterQueryConfig> supportedFilters;
  // List<DataFilterQueryConfig> supportedSearch;
  BaseAppModuleData? data;

  AppModule({
    this.id,
    required this.title,
    this.description = '',
    this.countLabel = '',
    this.type = '',
    this.color,
    this.icon,
    this.svgIcon,
    this.isSearchApplicable = false,
    this.isLogOutModule = false,
    this.homeRoutePath = '/',
    this.helper,
    ModuleDataType? dataType,
    D2ObjectBox? db,
    this.data,
    this.programs = const [],
    this.dataSets = const [],
    // this.supportedFilters = const [],
    // this.supportedSearch = const [],
  }) {
    id = id ?? title;
    if (type == AppNavigationType.dataType) {
      if (db == null || dataType == null) {
        throw 'db and dataType parameters are required for navigation type data';
      }
      switch (dataType) {
        case ModuleDataType.tracker:
          data = AppModuleTrackerData(module: this, dataType: dataType, db: db);
        case ModuleDataType.event:
          data = AppModuleEventData(module: this, dataType: dataType, db: db);
          break;
        case ModuleDataType.aggregate:
          if (dataSets == null || dataSets!.isEmpty) {
            throw 'At least one data set is required for aggregate data type';
          }
          data = AppModuleAggregateData(
              module: this, dataType: dataType, db: db, dataSets: dataSets!);
          break;
        default:
          if (kDebugMode) {
            print('Invalid data module $dataType');
          }
          break;
      }

     
      helper?.setModule(this);
    }
  }

  bool get available {
    if (type != AppNavigationType.dataType) {
      return true;
    }
    if (data != null) {
      return data!.available;
    }
    return false;
  }

  @override
  String toString() {
    return '<$id $title>';
  }
}
