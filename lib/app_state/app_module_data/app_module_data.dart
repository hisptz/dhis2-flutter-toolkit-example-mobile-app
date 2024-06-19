
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';
import 'package:flutter/cupertino.dart';

import '../../models/app_module.dart';

class SelectedAppModuleDataState extends ChangeNotifier {
  final AppModule? module;

  BaseAppModuleData? get dataConfig {
    return module?.data;
  }

  int? get activeCount {
    return dataConfig?.activeCount;
  }

  SelectedAppModuleDataState({this.module}) {
    init();
  }

  static onAppModuleChange(AppModule? module) {
    return SelectedAppModuleDataState(module: module);
  }

  //This should be called with any updates to the filter
  updateFilter(String key, dynamic value) {
    if (dataConfig != null) {
      // dataConfig?.updateFilter(key, value);
      dataConfig?.updateCount();
      refresh();
    }
  }

  refresh() {
    if (dataConfig != null) {
      dataConfig!.refresh();
    }
    notifyListeners();
  }

  init() {
    if (dataConfig != null) {
      dataConfig!.init();
    }
  }

  @override
  void dispose() {
    // if (dataConfig != null) {
    //   if (dataConfig is AppModulePaginatedData) {
    //     (dataConfig as AppModulePaginatedData).dispose();
    //   }
    // }

    super.dispose();
  }
}
