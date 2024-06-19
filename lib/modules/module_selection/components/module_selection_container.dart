
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/module_selection/components/module_selection_button.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/module_selection/components/module_selection_detail_container.dart';
import 'package:flutter/material.dart';

class ModuleSelectionContainer extends StatelessWidget {
  const ModuleSelectionContainer(
      {super.key,
      required this.appModule,
      required this.isOpen,
      required this.onOpen,
      required this.onTap,
      this.disabled = false});

  final bool disabled;

  final double iconContainerSize = 63.0;

  final AppModule appModule;
  final bool isOpen;

  final VoidCallback onTap;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      width: double.infinity,
      child: Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        shadowColor: appModule.color?.withOpacity(0.1),
        child: Column(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: disabled ? null : onTap,
              child: ModuleSelectionDetailContainer(
                iconContainerSize: iconContainerSize,
                appModule: appModule,
                disabled: disabled
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastEaseInToSlowEaseOut,
              child: Visibility(
                visible: isOpen,
                child: ModuleSelectionButton(
                  iconContainerSize: iconContainerSize,
                  appModule: appModule,
                  onTap: onOpen,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
