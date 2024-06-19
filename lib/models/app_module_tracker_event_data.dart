import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';
import 'package:flutter/foundation.dart';


class AppModuleEventData extends BaseAppModuleData<D2EventRepository, D2Event>
     {
  @override
  D2EventRepository repository;
  D2ObjectBox db;
  D2Program? program;
  D2Enrollment?
      enrollment; //Only for tracker programs requiring an event data config

  AppModuleEventData(
      {required super.module,
      required super.dataType,
      required this.db,
      this.enrollment})
      : repository = D2EventRepository(db) {
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
    QueryBuilder<D2Event> queryBuilder = repository.box.query(D2Event_.program
        .equals(program!.id)
        .and(D2Event_.enrollment.equals(0, alias: 'enrollment')));

    Query<D2Event> query = queryBuilder.build();

    if (enrollment != null) {
      query.param(D2Event_.enrollment, alias: 'enrollment').value =
          enrollment!.id;
    }
    return query.count();
  }

  @override
  void init() {
    updateCount();
    // initializeController();
  }

  @override
  Query<D2Event> get query {
    Condition<D2Event> condition = D2Event_.program.equals(program!.id);

    // if (filters.isNotEmpty) {
    //   filters.forEach((key, value) {
    //     DataFilterQueryConfig? queryConfig = module.supportedFilters
    //         .firstWhereOrNull((element) => element.key == key);
    //     if (queryConfig != null) {
    //       Condition<D2Event> filterCondition =
    //           queryConfig.getCondition(value) as Condition<D2Event>;
    //       condition = condition.and(filterCondition);
    //     }
    //   });
    // }

    QueryBuilder<D2Event> queryBuilder = repository.box.query(condition);

    queryBuilder.order(D2Event_.createdAt, flags: Order.descending);
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
