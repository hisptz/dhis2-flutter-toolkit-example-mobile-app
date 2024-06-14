import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class MetadataDownloadProgress extends StatefulWidget {
  const MetadataDownloadProgress(
      {super.key,
      required this.metadataLabel,
      required this.downloadController,
      required this.onRetry,
      required this.onDownload,
      this.allowManualTrigger = false});

  final Function onRetry;
  final Function onDownload;
  final bool allowManualTrigger;
  final String metadataLabel;
  final StreamController<D2SyncStatus> downloadController;

  @override
  State<MetadataDownloadProgress> createState() =>
      _MetadataDownloadProgressState();
}

class _MetadataDownloadProgressState extends State<MetadataDownloadProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  initAnimation() {
    _animationController.repeat();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    initAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.downloadController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.amber,
    );
    double spacingWidth = 4.0;
    return StreamBuilder(
        stream: widget.downloadController.stream,
        builder: (context, streamData) {
          D2SyncStatus? d2SyncStatusObject = streamData.data;
          var error = streamData.error;
          int synced = d2SyncStatusObject?.synced ?? 0;
          int total = d2SyncStatusObject?.total ?? 1;

          double? percentage = (synced / total) * 100;
          return Row(
            children: [
              Visibility(
                visible:
                    d2SyncStatusObject?.status != D2SyncStatusEnum.complete &&
                        error == null,
                child: RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: const Icon(
                    Icons.sync,
                    color: Colors.amber,
                  ),
                ),
              ),
              Visibility(
                visible: error != null,
                child: const Icon(
                  Icons.error,
                  color: Colors.redAccent,
                ),
              ),
              Visibility(
                visible:
                    d2SyncStatusObject?.status == D2SyncStatusEnum.complete &&
                        error == null,
                child: Icon(
                  Icons.done_all,
                  color:  Theme.of(context).primaryColor,
                ),
              ),
              // spacing
              SizedBox(width: spacingWidth),
              Expanded(
                child: Text(
                  'Downloading ${widget.metadataLabel}',
                  style: textStyle,
                ),
              ),
              Visibility(
                  visible: error != null,
                  child: InkWell(
                    onTap: () {
                      widget.onRetry();
                    },
                    child: const Text('Retry'),
                  )),
              Visibility(
                  visible: error == null &&
                      widget.allowManualTrigger &&
                      !widget.downloadController.isClosed &&
                      d2SyncStatusObject == null,
                  child: InkWell(
                    onTap: () {
                      widget.onDownload();
                    },
                    child: const Text('Download'),
                  )),
              // spacing
              SizedBox(width: spacingWidth),
              Visibility(
                visible: error == null &&
                    (!widget.allowManualTrigger || d2SyncStatusObject != null),
                child: Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: textStyle,
                ),
              ),
            ],
          );
        });
  }
}
