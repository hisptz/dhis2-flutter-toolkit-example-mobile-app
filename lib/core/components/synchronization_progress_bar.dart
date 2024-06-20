import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class SynchronizationProgressBar extends StatefulWidget {
  const SynchronizationProgressBar({
    super.key,
    required this.processPercentage,
    required this.isProcessCompleted,
    required this.backgroundColor,
    required this.textColor,
    required this.label,
    this.selectedMetadata,
    this.syncedMetadata,
  });

  final Color backgroundColor;
  final Color textColor;
  final String label;
  final StreamController<D2SyncStatus> processPercentage;
  final bool isProcessCompleted;
  final List<String>? selectedMetadata;
  final double? syncedMetadata;

  @override
  State<SynchronizationProgressBar> createState() =>
      _SynchronizationProgressBarState();
}

class _SynchronizationProgressBarState
    extends State<SynchronizationProgressBar> {
  @override
  void dispose() {
    widget.processPercentage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double? overallPercentage = ((widget.syncedMetadata ?? 0) /
            (widget.selectedMetadata?.length ?? 0)) *
        100;

    TextStyle style = TextStyle(
      color: widget.textColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Column(
        children: [
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(8),
            value: overallPercentage > 0 ? overallPercentage / 100 : null,
            minHeight: 7,
            semanticsValue: overallPercentage.toString(),
            color: widget.backgroundColor,
            backgroundColor: widget.backgroundColor.withOpacity(0.3),
          ),
          const SizedBox(width: 4.0),
          StreamBuilder<D2SyncStatus>(
              stream: widget.processPercentage.stream,
              builder: (context, data) {
                D2SyncStatus? status = data.data;
                var error = data.error;

                if (error != null) {
                  return Text(
                    error.toString(),
                    style: style,
                  );
                }

                if (status == null) {
                  return Text(
                    'Initializing...',
                    style: style,
                  );
                }

                if (status.status == D2SyncStatusEnum.initialized) {
                  return Text('Please wait...', style: style);
                }

                if (status.status == D2SyncStatusEnum.complete) {
                  return Text(
                    'Completed',
                    style: style,
                  );
                }

                double? percentage = ((status.synced!) / status.total!) * 100;

                return Text(
                    '${widget.label} ${status.label} ${percentage.toStringAsPrecision(2)}%',
                    style: style);
              }),
        ],
      ),
    );
  }
}
