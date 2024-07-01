import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/list_card_button.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/app_module_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/program/components/tracker_form_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackerHelper extends BaseAppModuleHelper<D2Enrollment> {
  @override
  List<Map<String, String>> fieldConfig = [];

  void onFormOpen(
    BuildContext context, {
    required AppModule selectedAppModule,
    D2TrackedEntity? trackedEntity,
    required D2Program program,
    required List<String> mandatoryFields,
    D2Enrollment? enrollment,
    D2Enrollment? householdEnrollment,
    bool editable = true,
  }) async {
    await D2AppModalUtil.showActionSheetModal(
      context,
      initialHeightRatio: 0.75,
      title: selectedAppModule.title!.toUpperCase(),
      titleColor: selectedAppModule.color!,
      actionSheetContainer: TrackerFormContainer(
        selectedAppModule: selectedAppModule,
        trackedEntity: trackedEntity,
        program: program,
        enrollment: enrollment,
        editable: editable,
      ),
    );
    Provider.of<SelectedAppModuleDataState>(context, listen: false).refresh();
  }

  @override
  ListCardData toListCard(D2Enrollment entity) {
   
    D2TrackedEntity trackedEntity = entity.trackedEntity.target!;

    bool synced = entity.trackedEntity.target!.synced;

    return ListCardData(
      id: entity.uid,
      title: 'Event',
      onSync: (context) async {
        // await AppUtil.uploadTrackerData(
        //     context, householdProgram, entity, trackedEntity);
      },
      syncStatus: !synced,
      actionButtons: [
        ListCardButton(
            icon: Icons.open_in_new,
            buttonName: 'View',
            onPressed: (BuildContext context) {
              onFormOpen(
                context,
                program: selectedAppModule!.data?.repository.program,
                selectedAppModule: selectedAppModule!,
                trackedEntity: trackedEntity,
                mandatoryFields: [],
                editable: false,
                enrollment: entity,
              );
            }),
        ListCardButton(
            icon: Icons.mode_edit,
            buttonName: 'Edit',
            onPressed: (BuildContext context) {
              onFormOpen(context,
                  program: selectedAppModule!.data?.repository.program,
                  selectedAppModule: selectedAppModule!,
                  mandatoryFields: ['geometry'],
                  enrollment: entity,
                  trackedEntity: trackedEntity);
            })
      ],
      svgIcon: selectedAppModule!.svgIcon,
      actionButtonAlignment: MainAxisAlignment.end,
    );
  }
}
