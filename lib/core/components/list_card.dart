import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../utils/module_helpers/app_module_helper.dart';

class ListCard extends StatelessWidget {
  final ListCardData data;

  final iconContainerSize = 63.0;

  const ListCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModuleSelectionState>(builder: (context, state, child) {
      var selectedAppModule = state.selectedAppModule;
      return Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.svgIcon != null) ...[
                Container(
                  height: iconContainerSize,
                  width: iconContainerSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: selectedAppModule.color?.withOpacity(0.1),
                  ),
                  child: SvgPicture.asset(
                    data.svgIcon ?? '',
                    height: iconContainerSize * 0.7,
                    width: iconContainerSize * 0.7,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.title,
                            style: TextStyle(
                              color: selectedAppModule.color,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (data.date != null) ...[
                          Text(
                            data.date!,
                            style: const TextStyle(
                              color: Color(0xFF667685),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (data.fields != null) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final entry in data.fields!.entries) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${entry.key} :',
                                            style: const TextStyle(
                                              color: Color(0xFF667685),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const WidgetSpan(
                                            child: SizedBox(width: 8),
                                          ),
                                          TextSpan(
                                            text: entry.value,
                                            style: const TextStyle(
                                              color: Color(0xFF1D2B36),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Visibility(
                              visible: data.syncStatus ?? false,
                              child: GestureDetector(
                                  onTap:() =>  data.onSync(context),
                                  child: const Icon(
                                    Icons.sync_problem,
                                    color: Color(0xFFFAAD14),
                                  ))),
                        ],
                      ),
                    ],
                    Row(
                      mainAxisAlignment:
                          data.actionButtonAlignment ?? MainAxisAlignment.end,
                      children: [...(data.actionButtons ?? [])],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
