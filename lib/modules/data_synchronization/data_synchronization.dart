
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/app_page/app_page_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/data_synchronization/components/data_download_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/data_synchronization/components/offline_data_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataSynchronizationHome extends StatelessWidget {
  const DataSynchronizationHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModuleSelectionState>(
      builder: (context, dataModuleSelectionState, child) {
        AppModule selectedAppModule =
            dataModuleSelectionState.selectedAppModule;
        return AppPageContainer(
          pageTitle: selectedAppModule.title ?? '',
          onAppBarAddOrEdit: () {},
          onSubAppBarAddOrEdit: () {},
          isDrawerVisible: true,
          pageBodyContainer: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: const Column(
              children: [
                OfflineDataSummary(),
                SizedBox(
                  height: 20.0,
                ),
                DataDownload(),
              ],
            ),
          ),
        );
      },
    );
  }
}
