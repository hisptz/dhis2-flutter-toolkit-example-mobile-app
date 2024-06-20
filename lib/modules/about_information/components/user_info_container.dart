
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/about_information/utils/about_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoContainer extends StatelessWidget {
  const UserInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: const Text(
            'User Information',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Consumer<UserState>(
          builder: (context, state, child) {
            List<D2OrgUnit> orgUnits = [];

            D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;

            D2OrgUnitRepository orgUnitRepo = D2OrgUnitRepository(db);

            for (String orgUnitId in state.user?.organisationUnits ?? []) {
              D2OrgUnit? orgUnit = orgUnitRepo.getByUid(orgUnitId);
              orgUnit != null ? orgUnits.add(orgUnit) : null;
            }

            return Container(
              margin: const EdgeInsets.symmetric(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Table(
                    defaultColumnWidth: FixedColumnWidth(size.width * 0.65),
                    children: [
                      AboutPageUtil.getTableRowContent(
                          'Full name:', state.user?.fullName),
                      AboutPageUtil.getTableRowContent(
                          'Username:', state.user?.username),
                      AboutPageUtil.getTableRowContent(
                          'Email:', state.user?.email ?? 'N/A'),
                      AboutPageUtil.getTableRowContent(
                          'Assigned locations:',
                          orgUnits.isNotEmpty
                              ? orgUnits
                                  .map((orgUnit) => orgUnit.displayName)
                                  .join(', ')
                              : 'N/A'),
                      AboutPageUtil.getTableRowContent(
                          'Assigned Roles:',
                          state.user?.userRoles.isNotEmpty == true
                              ? state.user?.userRoles
                                  .map((e) => e.displayName)
                                  .join(', ')
                              : 'N/A'),
                      AboutPageUtil.getTableRowContent(
                          'Assigned Groups:',
                          state.user?.userGroups.isNotEmpty == true
                              ? state.user?.userGroups
                                  .map((e) => e.displayName)
                                  .join(', ')
                              : 'N/A'),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
