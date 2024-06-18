import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/login/components/login_form.dart';
import 'package:dhis2_flutter_toolkit_demo_app/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void navigateAfterLogin() {
    D2User? user = Provider.of<UserState>(context, listen: false).user;
    if (user != null) {
      ModuleSelectionRoute().go(context);
      return;
    } else {
      setState(() {
        InitialMetadataDownloadRoute().go(context);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            width: size.width * 0.8,
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF023047),
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Enter your account details to login.',
                  style: TextStyle(
                    color: Color(0xFF737373),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15.0),
                LoginForm(
                  onLoginComplete: navigateAfterLogin,
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
