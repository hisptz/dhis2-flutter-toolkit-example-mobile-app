import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.loadingLabel,
    required this.isLoading,
    this.isDisabled = false,
    this.height = 50.0,
  });

  final VoidCallback onTap;
  final double height;
  final String label;
  final String loadingLabel;
  final bool isLoading;
  final bool isDisabled;

  @override
  ActionButtonState createState() => ActionButtonState();
}

class ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: const EdgeInsets.only(
        bottom: 10.0,
      ),
      child: InkWell(
        onTap: widget.isDisabled || widget.isLoading ? null : widget.onTap,
        borderRadius: BorderRadius.circular(100.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: widget.isDisabled || widget.isLoading
                ? const Color(0xFFF1F3F5)
                : CustomColor.primaryColor,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.isLoading ? widget.loadingLabel : widget.label,
            style: TextStyle(
              color: widget.isDisabled || widget.isLoading
                  ? const Color(0xFFA5B2BD)
                  : Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }
}
