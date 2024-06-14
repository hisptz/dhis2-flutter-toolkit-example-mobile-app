import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/auth_state/auth_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/line_seperator.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/app_util.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/login/components/login_button.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/login/constants/login_page_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final Function onLoginComplete;

  const LoginForm({super.key, required this.onLoginComplete});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _loading = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController baseURLController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> onLogin() async {
    setState(() {
      _loading = true;
    });
    try {
      AuthState authState = Provider.of<AuthState>(context, listen: false);
      String baseURL = baseURLController.text;
      String username = usernameController.text.trim();
      String password = passwordController.text;
      D2UserCredential? credentials = await authState.login(
          baseURL: baseURL, username: username, password: password);
      await AppUtil.initializeServices(context, credentials);
      widget.onLoginComplete();
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF656565),
      );
      setState(() {
        _loading = false;
      });
    }finally{
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color inActiveInputColor = Colors.grey.withOpacity(0.25);
    Color iconBoxColor = Colors.grey.withOpacity(0.1);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'DHIS2 url',
                style: LoginPageStyles.formLabelStyle,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 5.0,
            ),
            child: TextFormField(
              controller: baseURLController,
              autocorrect: false,
              style: LoginPageStyles.formInputValueStyle,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixText: "https://",
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.public,
                  color: Theme.of(context).primaryColor,
                ),
                prefixIconConstraints: LoginPageStyles.loginBoxConstraints,
              ),
            ),
          ),
          LineSeparator(color: inActiveInputColor),
          Row(
            children: [
              Text(
                'Username',
                style: LoginPageStyles.formLabelStyle,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 5.0,
            ),
            child: TextFormField(
              controller: usernameController,
              autocorrect: false,
              style: LoginPageStyles.formInputValueStyle,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                prefixIconConstraints: LoginPageStyles.loginBoxConstraints,
              ),
            ),
          ),
          LineSeparator(color: inActiveInputColor),
          Container(
            margin: const EdgeInsets.only(
              top: 20.0,
            ),
            child: Row(
              children: [
                Text(
                  'Password',
                  style: LoginPageStyles.formLabelStyle,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 5.0,
            ),
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              autocorrect: false,
              style: LoginPageStyles.formInputValueStyle,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  fontSize: 15.0,
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
                prefixIconConstraints: LoginPageStyles.loginBoxConstraints,
                suffixIconConstraints: LoginPageStyles.loginBoxConstraints,
              ),
            ),
          ),
          LineSeparator(
            color: inActiveInputColor,
          ),
          LoginButton(
            isLoginProcessActive: _loading,
            onLogin: () => {onLogin()},
          ),
        ],
      ),
    );
  }
}
