import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/app_module_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


mixin AppModulePaginatedData<
    RepoType extends D2BaseTrackerDataRepository,
    DataType extends D2DataResource,
    ListDataType extends ListData> on BaseAppModuleData<RepoType, DataType> {
  late PagingController<int, ListDataType> _controller;
  static const _pageSize = 50;

  PagingController get pagingController {
    return _controller;
  }

  void dispose() {
    _controller.dispose();
  }

  Query<DataType> get query;

  @override
  void refresh() {
    _controller.refresh();
  }

  fetchPage(int page) async {
    int count = query.count();
    int numberOfPages = (count / _pageSize).ceil();

    query
      ..limit = _pageSize
      ..offset = page * _pageSize;

    List<DataType> entities = query.find();

    List<ListDataType> listData = entities
        .map<ListDataType>(
            (data) => module.helper!.toListCard(data) as ListDataType)
        .toList();
    bool isLastPage = page == numberOfPages - 1;
    if (isLastPage) {
      _controller.appendLastPage(listData);
    } else {
      _controller.appendPage(listData, page + 1);
    }
  }

  initializeController() {
    _controller = PagingController<int, ListDataType>(firstPageKey: 0);
    _controller.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }
}
