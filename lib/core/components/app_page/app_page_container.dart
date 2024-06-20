import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/app_page/app_body_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/navigation_drawer/navigation_drawer_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppPageContainer extends StatefulWidget {
  const AppPageContainer({
    super.key,
    required this.onAppBarAddOrEdit,
    required this.onSubAppBarAddOrEdit,
    required this.pageTitle,
    required this.pageBodyContainer,
    this.isDrawerVisible = false,
    this.isSubAppBarVisible = false,
    this.appBarAddOrEditLabel = '',
    this.isAppBarAddVisible = false,
    this.isAppBarEditVisible = false,
    this.subAppBarAddActionLabel = '',
    this.isFilterApplicable = false,
    this.isSearchApplicable = false,
    this.subAppBarAddActionIcon,
    this.appBarFilterContainer,
    this.appBarSearchContainer,
  });

  final String pageTitle;
  final Widget pageBodyContainer;
  final bool isDrawerVisible;
  final bool isSubAppBarVisible;
  final String subAppBarAddActionLabel;
  final bool isAppBarAddVisible;
  final bool isAppBarEditVisible;
  final String appBarAddOrEditLabel;

  final IconData? subAppBarAddActionIcon;

  final Widget? appBarFilterContainer;
  final Widget? appBarSearchContainer;

  final VoidCallback onAppBarAddOrEdit;
  final VoidCallback onSubAppBarAddOrEdit;

  final bool isFilterApplicable;
  final bool isSearchApplicable;

  @override
  State<AppPageContainer> createState() => _AppPageContainerState();
}

class _AppPageContainerState extends State<AppPageContainer> {
  bool isFilterActive = false;
  bool isSearchActive = false;

  List<Widget> _getAppBarActions(
      {required bool isFilterVisible,
      required bool isSearchVisible,
      int? filterCount,
      int? searchCount}) {
    return [
      Visibility(
        visible: isFilterVisible,
        child: Consumer<AppModuleSelectionState>(
          builder: (context, appModule, child) => IconButton(
            onPressed: () {
              isFilterActive = !isFilterActive;
              isSearchActive = false;
              setState(() {});
            },
            icon: Badge.count(
              alignment: Alignment.topLeft,
              backgroundColor: Colors.white,
              textColor: appModule.selectedAppModule.color,
              offset: const Offset(-4, -4),
              isLabelVisible: filterCount != null && filterCount != 0,
              count: filterCount ?? 0,
              child: const Icon(
                Icons.tune,
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: isSearchVisible,
        child: Consumer<AppModuleSelectionState>(
          builder: (context, appModule, child) => IconButton(
            onPressed: () {
              isSearchActive = !isSearchActive;
              isFilterActive = false;
              setState(() {});
            },
            icon: Badge.count(
              alignment: Alignment.topLeft,
              backgroundColor: Colors.white,
              textColor: appModule.selectedAppModule.color,
              offset: const Offset(-4, -4),
              isLabelVisible: searchCount != null && searchCount != 0,
              count: searchCount ?? 0,
              child: const Icon(
                Icons.search,
              ),
            ),
          ),
        ),
      ),
      Visibility(
        visible: widget.isAppBarAddVisible || widget.isAppBarEditVisible,
        child: IconButton(
          onPressed: widget.onAppBarAddOrEdit,
          icon: Row(
            children: [
              Icon(
                widget.isAppBarAddVisible ? Icons.add : Icons.edit_sharp,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                ),
                child: Text(
                  widget.appBarAddOrEditLabel,
                  style: const TextStyle().copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppModuleSelectionState, SelectedAppModuleDataState>(
      builder: (context, dataModuleSelectionState, dataState, child) {
        AppModule selectedAppModule =
            dataModuleSelectionState.selectedAppModule;

        // int? filterCount = dataState.dataConfig?.activeFilterCount;
        // int? searchCount = dataState.dataConfig?.activeSearchCount;

        return Scaffold(
          backgroundColor: Color(0xFFE9ECEF),
          appBar: AppBar(
            iconTheme: const IconThemeData().copyWith(
              color: Colors.white,
            ),
            backgroundColor: selectedAppModule.color,
            title: Column(
              children: [
                Text(
                  widget.pageTitle,
                  style: const TextStyle().copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            //   actions: _getAppBarActions(
            //       isFilterVisible: widget.isFilterApplicable,
            //       isSearchVisible: widget.isSearchApplicable,
            //       filterCount: filterCount,
            //       searchCount: searchCount),
          ),
          drawer:
              widget.isDrawerVisible ? const NavigationDrawerContainer() : null,
          body: AppBodyContainer(
            pageBodyContainer: widget.pageBodyContainer,
            selectedAppModule: selectedAppModule,
            isSubAppBarVisible: widget.isSubAppBarVisible,
            subAppBarAddActionLabel: widget.subAppBarAddActionLabel,
            onSubAppBarAddOrEdit: widget.onSubAppBarAddOrEdit,
            appBarFilterContainer: widget.appBarFilterContainer,
            appBarSearchContainer: widget.appBarSearchContainer,
            isFilterActive: isFilterActive,
            isSearchActive: isSearchActive,
            subAppBarAddActionIcon: widget.subAppBarAddActionIcon,
          ),
        );
      },
    );
  }
}
