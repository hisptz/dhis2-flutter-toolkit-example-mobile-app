import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:flutter/material.dart';

class MetadataDownloadActions extends StatelessWidget {
  const MetadataDownloadActions({
    super.key,
    required this.onSelectAll,
    required this.onSelectNone,
    this.isReadOnly = false,
  });

  final Function onSelectAll;
  final Function onSelectNone;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    Color iconColor = isReadOnly
        ? CustomColor.primaryColor.withOpacity(0.3)
        : CustomColor.primaryColor;
    Color textColor =
        isReadOnly ? const Color(0xFFA5B2BD) : CustomColor.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          InkWell(
            onTap: isReadOnly ? null : () => onSelectAll(),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(
                right: 8.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.done_all,
                    color: iconColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Text(
                      'Select All',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: isReadOnly ? null : () => onSelectNone(),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(
                right: 8.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_none,
                    color: iconColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Text(
                      ' Select None',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
