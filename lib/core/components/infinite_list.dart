import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/empty_list.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/list_card.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/app_module_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module_paginated_data_mixin.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class InfiniteList extends StatelessWidget {
  const InfiniteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectedAppModuleDataState>(
      builder: (BuildContext context, dataState, Widget? child) {
        if (dataState.dataConfig is! AppModulePaginatedData) {
          return const Center(
            child: Text('Invalid data module selected for infinite list'),
          );
        }

        AppModulePaginatedData paginatedDataConfig =
            dataState.dataConfig as AppModulePaginatedData;

        return PagedListView.separated(
            shrinkWrap: true,
            separatorBuilder: (
              context,
              item,
            ) =>
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                ),
            pagingController: paginatedDataConfig.pagingController,
            builderDelegate: PagedChildBuilderDelegate(
                noItemsFoundIndicatorBuilder: (context) {
                  return Consumer2<AppModuleSelectionState,
                          SelectedAppModuleDataState>(
                      builder: (context, appModule, dataState, child) =>
                          EmptyList(
                            hasActiveFilters:
                                dataState.dataConfig!.hasActiveFilters,
                            title: appModule.selectedAppModule.title!,
                          ));
                },
                firstPageProgressIndicatorBuilder: (context) {
                  return Center(
                    child: Consumer<AppModuleSelectionState>(
                        builder: (context, appModule, child) =>
                            CircularProgressIndicator(
                                color: appModule.selectedAppModule.color)),
                  );
                },
                itemBuilder: (BuildContext context, item, int index) =>
                    ListCard(
                      key: Key((item as ListCardData).title),
                      data: item,
                    )));
      },
    );
  }
}
