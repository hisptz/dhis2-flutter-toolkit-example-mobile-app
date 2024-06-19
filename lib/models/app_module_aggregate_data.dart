import 'package:collection/collection.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';

import '../core/utils/app_util.dart';

class AppModuleAggregateData
    extends BaseAppModuleData<D2DataValueSetRepository, D2DataValueSet> {
  D2DataSet? dataSet;
  D2ObjectBox db;
  D2User? user;
  List<D2DataValueSet> dataValues = [];

  String? get period {
    return filters['period']?.selected.first;
  }

  String? get orgUnitId {
    return user?.organisationUnits.first;
  }

  initializePeriod() {
    if (dataSet == null) {
      return;
    }
    String periodType = AppUtil.camelCaseToSnakeCase(dataSet!.periodType);
    D2PeriodType type = D2PeriodType.fromId(periodType,
        year: DateTime.now().year, category: D2PeriodTypeCategory.fixed);
    List<D2Period> periods = type.periods;
    D2Period? initialPeriod = periods.firstWhereOrNull((element) {
      return DateTime.now() > element.start! && element.end! > DateTime.now();
    });
    if (initialPeriod != null) {
      filters['period'] = D2PeriodSelection.fromSelection([initialPeriod.id]);
    }
  }

  getData() {
    if (period == null || orgUnitId == null) {
      return;
    }
    dataValues = repository.box
        .query(D2DataValueSet_.period.equals(period!).and(D2DataValueSet_
            .organisationUnit
            .equals(D2OrgUnitRepository(db).getIdByUid(orgUnitId!)!)
            .and(D2DataValueSet_.attributeOptionCombo.equals(
                dataSet!.categoryCombo.target!.categoryOptionCombos.first.id))))
        .build()
        .find();
  }

  @override
  updateFilter(String key, dynamic value) {
    filters[key] = value;
    getData();
  }

  AppModuleAggregateData(
      {required super.module,
      required super.dataType,
      required this.db,
      required List<String> dataSets})
      : user = D2UserRepository(db).get(),
        repository = D2DataValueSetRepository(db) {
    D2DataSet? dataSet = D2DataSetRepository(db).getByUid(dataSets.first);
    if (dataSet == null) {
      return;
    }
    this.dataSet = dataSet;
    initializePeriod();
    getData();
  }

  @override
  bool get available => dataSet != null;

  @override
  int get totalCount {
    return dataSet?.dataSetElements.length ?? 0;
  }

  @override
  void refresh() {
    getData();
  }

  @override
  D2DataValueSetRepository repository;

  @override
  void init() {}

  @override
  void updateCount() {
    activeCount = totalCount;
  }
}
