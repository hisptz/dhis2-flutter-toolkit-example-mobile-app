import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/app_module_data/app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/app_page/app_page_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/datasets/components/itemlist.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/datasets/components/period_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DatasetHome extends StatefulWidget {
  const DatasetHome({super.key, this.id});

  final String? id;

  @override
  State<DatasetHome> createState() => _DatasetHomeState();
}

class _DatasetHomeState extends State<DatasetHome> {
  late D2PeriodSelection initialSelection;

  setPeriod(D2PeriodSelection selection) {
    Provider.of<SelectedAppModuleDataState>(context, listen: false)
        .updateFilter('period', selection);
  }

  @override
  void initState() {
    super.initState();
  }

  void onPeriodSelection(D2PeriodSelection selection) {
    setPeriod(selection);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModuleSelectionState>(
      builder: (context, dataModuleSelectionState, child) {
        AppModule selectedAppModule =
            dataModuleSelectionState.selectedAppModule;
        return Consumer<SelectedAppModuleDataState>(
          builder: (context, selectedDataState, child) {
            D2PeriodSelection? selection =
                selectedDataState.dataConfig?.filters['period'];

            String? periodId = selection?.selected?.first;

            return AppPageContainer(
              pageTitle: selectedAppModule.title ?? '',
              onAppBarAddOrEdit: () {},
              onSubAppBarAddOrEdit: () {
                showModalBottomSheet(
                    elevation: 0.0,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (BuildContext context) => PeriodSelector(
                          modalTitle: 'Select Period',
                          selectedAppModule: selectedAppModule,
                          initialSelection:
                              selection ?? D2PeriodSelection.fromSelection([]),
                          onPeriodSelection: onPeriodSelection,
                        ));
              },
              isSubAppBarVisible: true,
              isFilterApplicable: false,
              subAppBarAddActionIcon: Icons.calendar_month_outlined,
              subAppBarAddActionLabel: periodId != null
                  ? D2PeriodType.getPeriodById(periodId).name
                  : 'Select period',
              isDrawerVisible: true,
              pageBodyContainer: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  child: AggregateItemList()),
            );
          },
        );
      },
    );
  }
}
