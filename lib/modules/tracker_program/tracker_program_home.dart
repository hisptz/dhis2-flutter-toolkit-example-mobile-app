import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/app_page/app_page_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/infinite_list.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/tracker_program/components/tracker_form_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackerProgramHome extends StatelessWidget {
  const TrackerProgramHome({super.key});
  void onAddOrEditHousehold(BuildContext context,
      {required AppModule selectedAppModule,
      required List<String> mandatoryFields}) async {
    await D2AppModalUtil.showActionSheetModal(
      context,
      initialHeightRatio: 0.69,
      title: 'HOUSEHOLD IDENTIFICATION DETAILS',
      titleColor: selectedAppModule.color!,
      actionSheetContainer: TrackerFormContainer(
        selectedAppModule: selectedAppModule,
        program: selectedAppModule.data?.repository.program,
      ),
    );
    Provider.of<SelectedAppModuleDataState>(context, listen: false).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModuleSelectionState>(
      builder: (context, dataModuleSelectionState, child) {
        AppModule selectedAppModule =
            dataModuleSelectionState.selectedAppModule;
        return AppPageContainer(
          pageTitle: selectedAppModule.title ?? '',
          onAppBarAddOrEdit: () {},
          onSubAppBarAddOrEdit: () {
            onAddOrEditHousehold(context,
                selectedAppModule: selectedAppModule,
                mandatoryFields: ['geometry']);
          },
          isSubAppBarVisible: true,
          isFilterApplicable: true,
          subAppBarAddActionLabel: 'Add Event',
          isDrawerVisible: true,
          pageBodyContainer: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: InfiniteList()),
        );
      },
    );
  }
}
