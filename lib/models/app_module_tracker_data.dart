import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module_paginated_data_mixin.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';
import 'package:flutter/foundation.dart';

class AppModuleTrackerData extends BaseAppModuleData<D2EnrollmentRepository, D2Enrollment>  with AppModulePaginatedData
    {
  @override
  D2EnrollmentRepository repository;
  D2Program? program;

  AppModuleTrackerData({
    required super.module,
    required super.dataType,
    required D2ObjectBox db,
  }) : repository = D2EnrollmentRepository(db) {
    try {
      String mainProgram = module.programs!.first;
      D2Program? program = D2ProgramRepository(db).getByUid(mainProgram);
      if (program != null) {
        this.program = program;
        repository.setProgram(program);
      }
    } on StateError catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          print(e.toString());
          print('Missing at least one program in the module configuration');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        print('Program with ID ${module.programs!.first} is not found.');
      }
    }
  }

  @override
  bool get available {
    return program != null;
  }

  @override
  int? get totalCount {
    if (program == null) {
      return null;
    }
    QueryBuilder<D2Enrollment> queryBuilder =
        repository.box.query(D2Enrollment_.program.equals(program!.id));

    Query<D2Enrollment> query = queryBuilder.build();
    return query.count();
  }

  @override
  void init() {
    updateCount();
    initializeController();

  }

  Condition<D2Enrollment> getSearchAttributeConditions(String keyword) {
    List<D2ProgramTrackedEntityAttribute>
        searchableProgramTrackedEntityAttributes =
        D2ProgramTrackedEntityAttributeRepository(repository.db)
            .box
            .query(D2ProgramTrackedEntityAttribute_.program
                .equals(program!.id)
                .and(D2ProgramTrackedEntityAttribute_.searchable.equals(true)))
            .build()
            .find();

    Condition<D2TrackedEntityAttributeValue>? trackedEntityConditions;

    for (D2ProgramTrackedEntityAttribute element
        in searchableProgramTrackedEntityAttributes) {
      trackedEntityConditions = trackedEntityConditions == null
          ? D2TrackedEntityAttributeValue_.trackedEntityAttribute
              .equals(element.trackedEntityAttribute.target!.id)
              .and(D2TrackedEntityAttributeValue_.value.contains(keyword))
          : trackedEntityConditions.or(D2TrackedEntityAttributeValue_
              .trackedEntityAttribute
              .equals(element.trackedEntityAttribute.target!.id)
              .and(D2TrackedEntityAttributeValue_.value.contains(keyword)));
    }

    QueryBuilder<D2TrackedEntity> trackedEntityQueryBuilder =
        D2TrackedEntityRepository(repository.db).box.query();

    trackedEntityQueryBuilder.linkMany(
        D2TrackedEntity_.attributesForQuery, trackedEntityConditions);
    List<int> trackedEntityIds =
        trackedEntityQueryBuilder.build().property(D2TrackedEntity_.id).find();

    return D2Enrollment_.trackedEntity.oneOf(trackedEntityIds);
  }

  @override
  Query<D2Enrollment> get query {
    Condition<D2Enrollment> condition =
        D2Enrollment_.program.equals(program!.id);

    // if (filters.isNotEmpty) {
    //   filters.forEach((key, value) {
    //     DataFilterQueryConfig? queryConfig = [
    //       ...module.supportedFilters,
    //       ...module.supportedSearch
    //     ].firstWhereOrNull((element) => element.key == key);
    //     if (queryConfig != null && value != null) {
    //       Condition<D2Enrollment> filterCondition =
    //           queryConfig.getCondition(value) as Condition<D2Enrollment>;
    //       condition = condition.and(filterCondition);
    //     }
    //   });
    // }

    if (searchKeyword != null) {
      if (searchKeyword!.isNotEmpty) {
        condition = condition.and(getSearchAttributeConditions(searchKeyword!));
      }
    }

    QueryBuilder<D2Enrollment> queryBuilder = repository.box.query(condition);
    queryBuilder.order(D2Enrollment_.createdAt, flags: Order.descending);
    return queryBuilder.build();
  }

  @override
  void refresh() {
    updateCount();
    super.refresh();
  }

  @override
  void updateCount() {
    activeCount = query.count();
  }
}
