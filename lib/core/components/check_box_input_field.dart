import 'package:flutter/material.dart';

class CheckBoxInputField extends StatefulWidget {
  const CheckBoxInputField({
    super.key,
    required this.onInputValueChange,
    required this.label,
    required this.value,
    required this.color,
    required this.isReadOnly,
  });

  final Function onInputValueChange;
  final String? label;
  final Color? color;
  final dynamic value;
  final bool isReadOnly;

  @override
  State<CheckBoxInputField> createState() => _CheckBoxInputFieldState();
}

class _CheckBoxInputFieldState extends State<CheckBoxInputField> {
  bool? _inputValue;

  @override
  void initState() {
    super.initState();
    updateInputValueState();
  }

  updateInputValueState() {
    setState(() {
      _inputValue = widget.value != null && '${widget.value}' == 'true';
    });
  }

  @override
  void didUpdateWidget(covariant CheckBoxInputField oldWidget) {
    super.didUpdateWidget(widget);
    if (oldWidget.value != widget.value) updateInputValueState();
  }

  void onInputValueChange(bool? value) {
    updateInputValueState();
    widget.onInputValueChange(value == true ? value : null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _inputValue,
          activeColor:
              widget.isReadOnly ? const Color(0xFFA5B2BD) : widget.color,
          checkColor: _inputValue! ? Colors.white : null,
          onChanged: widget.isReadOnly ? null : onInputValueChange,
        ),
        Expanded(
          child: InkWell(
            onTap: () =>
                widget.isReadOnly ? null : onInputValueChange(!_inputValue!),
            child: Text(
              widget.label!,
              style: const TextStyle().copyWith(
                color:
                    widget.isReadOnly ? const Color(0xFFA5B2BD) : Colors.black,
                fontSize: 16.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}
