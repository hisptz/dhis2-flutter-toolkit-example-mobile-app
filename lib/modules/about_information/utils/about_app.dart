import 'package:flutter/material.dart';

class AboutPageUtil {
  static TableRow getTableRowContent(
      String tableRowKey, String? tableRowValue) {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: tableRowKey,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF667685),
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: tableRowValue,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF1D2B36),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
