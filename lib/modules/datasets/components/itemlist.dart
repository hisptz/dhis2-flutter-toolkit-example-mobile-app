import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/empty_list.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/list_card.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/aggregate_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/module_helpers/app_module_helper.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module_aggregate_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AggregateItemList extends StatelessWidget {
  const AggregateItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DBState>(
      builder: (context, dbState, child) =>
          Consumer<SelectedAppModuleDataState>(
              builder: (context, dataState, child) {
        BaseAppModuleData? dataConfig = dataState.dataConfig;

        if (dataConfig is AppModuleAggregateData) {
          List<D2DataSetElement> dataSetElements =
              dataConfig.dataSet?.dataSetElements ?? [];

          if (dataSetElements.isEmpty) {
            return const EmptyList(title: 'stock items');
          }

          List<ListCardData> dataCards = dataSetElements.map((dataSetElement) {
            D2DataElement dataElement = dataSetElement.dataElement.target!;
            return AggregateHelper().toAggregateListCard(dataElement,
                dataConfig: dataConfig);
          }).toList();

          return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListCard(data: dataCards[index]);
              },
              separatorBuilder: (context, index) =>
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              itemCount: dataCards.length);
        }

        return const EmptyList(title: 'stock item');
      }),
    );
  }
}
