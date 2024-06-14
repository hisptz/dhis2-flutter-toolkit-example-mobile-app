import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.isLoginProcessActive,
    this.onLogin,
    this.buttonText = 'Login', 
    this.backgroundColor = const Color(0xFF023047),
    this.textColor = Colors.white,
    this.progressIndicatorColor = Colors.white,
  });

  final bool isLoginProcessActive;
  final VoidCallback? onLogin;
  final String buttonText;
  final Color backgroundColor;
  final Color textColor;
  final Color progressIndicatorColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20.0),
      child: TextButton(
        onPressed: isLoginProcessActive ? null : onLogin,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          backgroundColor: WidgetStateColor.resolveWith(
                    (states) => Theme.of(context).primaryColor)
        ),
        child: isLoginProcessActive
            ? SizedBox(
                height: 21.0,
                width: 21.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(progressIndicatorColor),
                  strokeWidth: 2.0,
                ),
              )
            : Text(
                buttonText,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
