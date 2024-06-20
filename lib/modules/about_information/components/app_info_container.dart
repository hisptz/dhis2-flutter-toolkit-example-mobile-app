import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_info_reference.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/about_information/utils/about_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppInfoContainer extends StatelessWidget {
  const AppInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/logos/hisptz.svg',
            width: size.width * 0.3,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: const Text(
            'App Information',
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
                  'App Name:',
                  AppInfoReference.currentAppName,
                ),
                AboutPageUtil.getTableRowContent(
                  'App Version:',
                  AppInfoReference.currentAppVersion,
                ),
                AboutPageUtil.getTableRowContent(
                  'App Id:',
                  AppInfoReference.androidId,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
