
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/app_page/app_page_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/line_seperator.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/about_information/components/app_info_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/about_information/components/system_info_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/about_information/components/user_info_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutInformationHome extends StatelessWidget {
  const AboutInformationHome({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const AppInfoContainer(),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(size.width * 0.8),
                      children: [
                        TableRow(
                          children: [
                            LineSeparator(color: CustomColor.primaryColor.withOpacity(0.3))
                          ],
                        )
                      ],
                    ),
                  ),
                  const UserInfoContainer(),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(size.width * 0.8),
                      children: [
                        TableRow(
                          children: [
                            LineSeparator(color: CustomColor.primaryColor.withOpacity(0.3))
                          ],
                        )
                      ],
                    ),
                  ),
                  const SystemInfoContainer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
