
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/line_seperator.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';

class PeriodSelector extends StatelessWidget {
  final AppModule selectedAppModule;
  final D2PeriodSelection initialSelection;
  final String? modalTitle;
  final void Function(D2PeriodSelection) onPeriodSelection;

  const PeriodSelector({
    super.key,
    required this.modalTitle,
    required this.selectedAppModule,
    required this.initialSelection,
    required this.onPeriodSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Text(
            modalTitle ?? '',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: selectedAppModule.color,
            ),
          ),
        ),
        LineSeparator(
          color: selectedAppModule.color?.withOpacity(0.1) ?? Colors.blue,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 15.0,
          ),
          child: D2PeriodSelector(
            onUpdate: onPeriodSelection,
            color: selectedAppModule.color ?? Colors.red,
            onlyAllowPeriodTypes: const ['MONTHLY'],
            initialSelection: initialSelection,
          ),
        ),
      ],
    );
  }
}
