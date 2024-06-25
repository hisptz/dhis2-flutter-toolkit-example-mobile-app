import 'package:collection/collection.dart';
import 'package:dart_date/dart_date.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/list_card_button.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/config.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/app_module_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/event_program/components/event_form_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/app_module.dart';

class EventHelper extends BaseAppModuleHelper<D2Event> {
  @override
  List<Map<String, String>> fieldConfig = [];

  String titleUId = 'OJT6yAkrnow';
  String otherSpecifyUid = 'xkbLnxT3uwX';
  String EventHelperProgram = 'qjFCUqsA0vZ';

  String? title;

  void onFormOpen(BuildContext context,
      {required AppModule selectedAppModule,
      required D2Event event,
      bool editable = true}) async {
    await D2AppModalUtil.showActionSheetModal(
      context,
      initialHeightRatio: 0.75,
      title: selectedAppModule.title!.toUpperCase(),
      titleColor: selectedAppModule.color!,
      actionSheetContainer: EventFormContainer(
        selectedAppModule: selectedAppModule,
        event: event,
        editable: editable,
      ),
    );
    Provider.of<SelectedAppModuleDataState>(context, listen: false).refresh();
  }

  @override
  ListCardData toListCard(D2Event entity) {
    bool synced = entity.synced;
    List<D2DataValue> dataValues = entity.dataValues;
    Map<String, String> fields = {};
    for (var field in fieldConfig) {
      D2DataValue? dataValue = dataValues.firstWhereOrNull(
          (element) => element.dataElement.target!.uid == field['id']);
      String label = field['label']!;
      fields.addAll({label: dataValue?.getDisplayValue() ?? ''});
    }

    var dataValue = dataValues.firstWhereOrNull(
        (element) => element.dataElement.target!.uid == titleUId);

    String otherSpecify = dataValues
            .firstWhereOrNull(
                (element) => element.dataElement.target!.uid == otherSpecifyUid)
            ?.getDisplayValue() ??
        '';

    String title = dataValue?.value == 'OET'
        ? otherSpecify
        : dataValue?.getDisplayValue() ?? '';

    return ListCardData(
        id: entity.uid,
        title: title,
        onSync: (BuildContext context) {
          // AppUtil.uploadEventData(context, EventHelperProgram, entity);
        },
        syncStatus: !synced,
        actionButtons: [
          ListCardButton(
              icon: Icons.open_in_new,
              buttonName: 'View',
              onPressed: (BuildContext context) {
                onFormOpen(context,
                    selectedAppModule: selectedAppModule!,
                    event: entity,
                    editable: false);
              }),
          ListCardButton(
              icon: Icons.mode_edit,
              buttonName: 'Edit',
              onPressed: (BuildContext context) {
                onFormOpen(context,
                    selectedAppModule: selectedAppModule!, event: entity);
              })
        ],
        svgIcon: selectedAppModule!.svgIcon,
        actionButtonAlignment: MainAxisAlignment.end,
        date: entity.occurredAt!.format(AppConfig.dateFormat),
        fields: fields);
  }
}
