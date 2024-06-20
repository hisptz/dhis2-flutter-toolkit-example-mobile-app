import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class NavigationDrawerHeaderContainer extends StatelessWidget {
  const NavigationDrawerHeaderContainer({super.key});

  void onCloseDrawer(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: CustomColor.appBackgroundColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      margin: const EdgeInsets.symmetric(),
                      child: SvgPicture.asset('assets/logos/hisptz.svg'),
                    ),
                    Consumer<UserState>(
                      builder: (context, state, child) => Container(
                        margin: const EdgeInsets.symmetric(),
                        child: Text(
                          state.user?.fullName,
                          style: const TextStyle().copyWith(
                            fontSize: 16.0,
                            color: CustomColor.appColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(),
              child: IconButton(
                onPressed: () => onCloseDrawer(context),
                icon: const Icon(
                  Icons.close,
                  size: 28.0,
                  color: Color(0XFF1D2B36),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
