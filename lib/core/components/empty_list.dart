import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String title;
  final bool hasActiveFilters;
  final bool isEventAdditionEnabled;

  const EmptyList(
      {super.key,
      required this.title,
      this.hasActiveFilters = false,
      this.isEventAdditionEnabled = true});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.6,
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Text(
        hasActiveFilters
            ? 'There are no $title that match the provided filters.'
            : 'There are no $title registered. ${isEventAdditionEnabled ? 'Click the above button to add one.' : ''}',
        textAlign: TextAlign.center,
        style: const TextStyle().copyWith(
          fontSize: 14,
          color: const Color(0xFF737373),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
