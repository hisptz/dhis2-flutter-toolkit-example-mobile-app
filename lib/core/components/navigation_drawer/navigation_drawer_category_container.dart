import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_navigation_type.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/app_module_selection_util.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class NavigationDrawerCategoryContainer extends StatelessWidget {
  const NavigationDrawerCategoryContainer({
    super.key,
    required this.title,
    required this.appModuleType,
    required this.onTap,
  });

  final String title;
  final String appModuleType;
  final Function onTap;

  final iconContainerSize = 28.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10.0,
        bottom: 2.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              title,
              style: const TextStyle().copyWith(
                color: CustomColor.appColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(
            color: CustomColor.appColor.withOpacity(0.5),
            thickness: 0.5,
          ),
          Container(
            margin: const EdgeInsets.symmetric(),
            child: Consumer<DBState>(
              builder: (_, dbState, child) {
                D2ObjectBox db = dbState.db;
                AppModuleSelectionUtil appSelectionUtil =
                    AppModuleSelectionUtil(db);

                return Column(
                  children: [
                    ...appSelectionUtil
                        .getAppModuleByType(type: appModuleType)
                        .map(
                          (AppModule appModule) => Opacity(
                            opacity: appModule.available ? 1.0 : 0.4,
                            child: InkWell(
                              onTap: !appModule.available
                                  ? null
                                  : () => onTap(appModule),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 2.5,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: iconContainerSize,
                                      width: iconContainerSize,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: appModule.color?.withOpacity(
                                          [AppNavigationType.dataType]
                                                  .contains(appModuleType)
                                              ? 0.1
                                              : 0.0,
                                        ),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                        vertical: 5.0,
                                      ),
                                      padding: const EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(  
                                        appModule.svgIcon ?? '',
                                        height: iconContainerSize * 0.7,
                                        width: iconContainerSize * 0.7,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(),
                                        child: Text(
                                          appModule.title ?? '',
                                          style: const TextStyle().copyWith(
                                            color: [AppNavigationType.dataType]
                                                    .contains(appModuleType)
                                                ? appModule.color
                                                : const Color(0XFF1D2B36),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
