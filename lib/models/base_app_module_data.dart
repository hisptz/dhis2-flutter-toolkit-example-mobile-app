import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/app_module_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';

enum ModuleDataType { tracker, event, aggregate, stock }

abstract class BaseAppModuleData<RepoType, DataType> {
  AppModule module;
  ModuleDataType dataType;
  abstract RepoType repository;

  String? searchKeyword;

  int? activeCount;

  // int? get activeFilterCount {
  //   return module.supportedFilters
  //       .where(
  //           (DataFilterQueryConfig element) => filters.containsKey(element.key))
  //       .length;
  // }

  bool get hasActiveFilters => filters.isNotEmpty;

  // int? get activeSearchCount {
  //   return module.supportedSearch
  //       .where(
  //           (DataFilterQueryConfig element) => filters.containsKey(element.key))
  //       .length;
  // }

  Map<String, dynamic> filters = {};

  BaseAppModuleData({required this.module, required this.dataType});

  int? get totalCount;

  bool get available;

  BaseAppModuleHelper? get helper {
    return module.helper;
  }

  void refresh() {
    updateCount();
  }

  void init();

  void updateCount();

  // updateFilter(String key, DataFilter? value) {
  //   if (value == null) {
  //     filters.remove(key);
  //     return;
  //   }
  //   filters.addAll({key: value});
  // }
}
