import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/about_information/utils/about_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SystemInfoContainer extends StatelessWidget {
  const SystemInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;

    D2SystemInfoRepository systemInfoRepo = D2SystemInfoRepository(db);
    D2SystemInfo? systemInfo = systemInfoRepo.get();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: const Text(
            'System Information',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Table(
              defaultColumnWidth: FixedColumnWidth(size.width * 0.65),
              children: [
                AboutPageUtil.getTableRowContent(
                    'System Name:', systemInfo?.systemName),
                AboutPageUtil.getTableRowContent(
                    'Url:', systemInfo?.contextPath),
                AboutPageUtil.getTableRowContent(
                    'Registration download limit:', 'N/A'),
                AboutPageUtil.getTableRowContent(
                    'Visits download limit:', 'N/A'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
