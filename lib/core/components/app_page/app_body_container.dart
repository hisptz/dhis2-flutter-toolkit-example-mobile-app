import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBodyContainer extends StatelessWidget {
  const AppBodyContainer({
    super.key,
    required this.pageBodyContainer,
    required this.selectedAppModule,
    required this.isSubAppBarVisible,
    required this.subAppBarAddActionLabel,
    required this.onSubAppBarAddOrEdit,
    required this.isFilterActive,
    required this.isSearchActive,
    this.subAppBarAddActionIcon,
    this.appBarFilterContainer,
    this.appBarSearchContainer,
  });

  final Widget pageBodyContainer;
  final Widget? appBarFilterContainer;
  final Widget? appBarSearchContainer;
  final AppModule selectedAppModule;
  final bool isSubAppBarVisible;
  final String subAppBarAddActionLabel;
  final IconData? subAppBarAddActionIcon;

  final bool isSearchActive;
  final bool isFilterActive;

  final VoidCallback onSubAppBarAddOrEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastEaseInToSlowEaseOut,
            child: Visibility(
              visible: isFilterActive || isSearchActive,
              child: Container(
                  width: double.infinity,
                  color: selectedAppModule.color,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    // horizontal: 15.0,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: isFilterActive
                        ? appBarFilterContainer
                        : isSearchActive
                            ? appBarSearchContainer ??
                                const EmptyExpandedContainer(
                                  message:
                                      'There are no search criteria configured',
                                )
                            : Container(),
                  ) 
                  ),
            ),
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: Color(0xFFE9ECEF),
              appBar: isSubAppBarVisible
                  ? AppBar(
                      leading: const Offstage(),
                      leadingWidth: double.minPositive,
                      elevation: 1.0,
                      toolbarHeight: 45,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      surfaceTintColor: Colors.white,
                      shadowColor: Color(0xFFE9ECEF),
                      title: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(),
                        child: Consumer<SelectedAppModuleDataState>(
                          builder: (context, dataState, child) {
                            return RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${selectedAppModule.countLabel}: ',
                                    style: const TextStyle().copyWith(
                                      color: const Color.fromARGB(255, 43, 49, 53),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: dataState.activeCount?.toString() ??
                                        'N/A',
                                    style: const TextStyle().copyWith(
                                      color:const Color.fromARGB(255, 43, 49, 53),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        Visibility(
                          visible: subAppBarAddActionLabel.isNotEmpty,
                          child: IconButton(
                            onPressed: onSubAppBarAddOrEdit,
                            icon: Row(
                              children: [
                                Icon(
                                  subAppBarAddActionIcon ?? Icons.add,
                                  color: selectedAppModule.color,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 2.0,
                                    right: 10.0,
                                  ),
                                  child: Text(
                                    subAppBarAddActionLabel,
                                    style: const TextStyle().copyWith(
                                      color: selectedAppModule.color,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : null,
              body: pageBodyContainer,
            ),
          )
        ],
      ),
    );
  }
}

class EmptyExpandedContainer extends StatelessWidget {
  const EmptyExpandedContainer({
    super.key,
    this.message = 'There are no contents to be added',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle().copyWith(
        color: Colors.white,
      ),
    );
  }
}
