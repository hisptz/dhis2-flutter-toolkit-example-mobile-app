import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';

class ModuleSelectionButton extends StatelessWidget {
  const ModuleSelectionButton({
    super.key,
    required this.iconContainerSize,
    required this.appModule,
    required this.onTap,
  });

  final double iconContainerSize;
  final AppModule appModule;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 10.0,
        left: iconContainerSize * 1.35,
        bottom: 16.0,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: appModule.color?.withOpacity(0.1),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 2.5,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: appModule.color,
                ),
              ),
              Text(
                'Open Module',
                style: const TextStyle().copyWith(
                  color: appModule.color,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
