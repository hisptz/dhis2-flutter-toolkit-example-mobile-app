
import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/list_card_button.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/app_module_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module_aggregate_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/datasets/components/aggregate_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/app_module.dart';

class AggregateHelper extends BaseAppModuleHelper<D2DataElement> {

  @override
  ListCardData toListCard(D2DataElement entity, String index) {
    Map<String, String> options = {};

    for (var option in entity.categoryCombo.target!.categoryOptionCombos) {
      options.addAll({option.name: '0'});
    }

    return ListCardData(
        id: entity.uid,
        onSync: (context) {
        },
        fields: options,
        title: entity.displayFormName ??
            entity.formName ??
            entity.displayName ??
            entity.name);
  }

  Future onFormOpen(BuildContext context,
      {required String orgUnitId,
      required D2DataElement dataElement,
      required D2DataSet dataSet,
      required String period}) async {
    AppModule selectedAppModule =
        Provider.of<AppModuleSelectionState>(context, listen: false)
            .selectedAppModule;
    await D2AppModalUtil.showActionSheetModal(context,
        initialHeightRatio: 0.8,
        titleColor: selectedAppModule.color!,
        title: dataElement.displayFormName ??
            dataElement.formName ??
            dataElement.displayName ??
            dataElement.name,
        actionSheetContainer: AggregateForm(
            orgUnitId: orgUnitId,
            dataElement: dataElement,
            dataSet: dataSet,
            period: period));
  }

  ListCardData toAggregateListCard(D2DataElement entity,
      {required AppModuleAggregateData dataConfig}) {
    Map<String, String> options = {};

    for (var option in entity.categoryCombo.target!.categoryOptionCombos) {
      String value = dataConfig.dataValues
              .firstWhereOrNull((element) =>
                  element.categoryOptionCombo.targetId == option.id &&
                  element.dataElement.targetId == entity.id)
              ?.value ??
          'N/A';
      options.addAll({option.name: value});
    }

    return ListCardData(
        id: entity.uid,
        onSync: (context) {
        },
        fields: options,
        actionButtons: [
          ListCardButton(
              icon: Icons.edit,
              buttonName: 'Record',
              onPressed: (context) {
                onFormOpen(context,
                        orgUnitId: dataConfig.orgUnitId ?? '',
                        dataElement: entity,
                        dataSet: dataConfig.dataSet!,
                        period: dataConfig.period ?? '')
                    .then((value) {
                  Provider.of<SelectedAppModuleDataState>(context,
                          listen: false)
                      .refresh();
                });
              })
        ],
        title: entity.displayFormName ??
            entity.formName ??
            entity.displayName ??
            entity.name);
  }

  @override
  List<Map<String, String>> fieldConfig = [];
}
