import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:flutter/material.dart';

class NavigationLogoutConfirmationContainer extends StatefulWidget {
  const NavigationLogoutConfirmationContainer({
    super.key,
    required this.onChanges,
  });

  final Function onChanges;

  @override
  State<NavigationLogoutConfirmationContainer> createState() =>
      _NavigationLogoutConfirmationContainerState();
}

class _NavigationLogoutConfirmationContainerState
    extends State<NavigationLogoutConfirmationContainer> {
  bool _inputValue = false;

  void onValueChange() {
    _inputValue = !_inputValue;
    setState(() {});
    widget.onChanges(_inputValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(),
          child: Text(
            'Are you sure you want to log out?',
            style: const TextStyle().copyWith(
              color: CustomColor.appColor,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _inputValue,
                activeColor: CustomColor.primaryColor,
                checkColor: _inputValue ? Colors.white : null,
                onChanged: (val) => onValueChange(),
              ),
              InkWell(
                onTap: onValueChange,
                child: Container(
                  margin: const EdgeInsets.symmetric(),
                  child: Text(
                    'Clear my data',
                    style: const TextStyle().copyWith(
                      color: CustomColor.appColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
