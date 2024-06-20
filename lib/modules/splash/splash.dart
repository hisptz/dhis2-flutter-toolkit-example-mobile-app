import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/auth_state/auth_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/circular_process_loader.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    setLandingPage();
  }

  void checkUser() {
    bool isUserLoggedIn =
        Provider.of<AuthState>(context, listen: false).isLoggedIn;
    print("userloged $isUserLoggedIn");
    if (!isUserLoggedIn) {
      LoginRoute().go(context);
      return;
    }
    D2User? user = Provider.of<UserState>(context, listen: false).user;
    print("user $user");
    if (user != null) {
      ModuleSelectionRoute().go(context);
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setLandingPage() {
    Timer(const Duration(milliseconds: 1000), () => checkUser());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
            color: CustomColor.appBackgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.symmetric(),
                child: SvgPicture.asset('assets/logos/hisptz.svg'),
              ),
              SizedBox(
                  height: 40), 
              CircularProcessLoader(
                color: CustomColor.primaryColor,
                size: 2.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
