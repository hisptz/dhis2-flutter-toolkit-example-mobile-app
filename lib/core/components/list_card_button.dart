import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnPressed = void Function(BuildContext context);

class ListCardButton extends StatelessWidget {
  final IconData? icon;
  final String buttonName;
  final OnPressed onPressed;

  const ListCardButton({
    super.key,
    this.icon,
    required this.buttonName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModuleSelectionState>(builder: (context, state, child) {
      var selectedAppModule = state.selectedAppModule;
      return IconButton(
        onPressed: () => onPressed(context),
        icon: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: selectedAppModule.color,
              ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(
                buttonName,
                style: const TextStyle().copyWith(
                  color: selectedAppModule.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
