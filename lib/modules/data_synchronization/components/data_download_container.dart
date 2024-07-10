import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/client_provider/client_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/action_button.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/line_seperator.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/synchronization_progress_bar.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/config.dart';

class DataDownload extends StatefulWidget {
  const DataDownload({
    super.key,
  });

  @override
  DataDownloadState createState() => DataDownloadState();
}

late StreamController<D2SyncStatus> downloadController;

class DataDownloadState extends State<DataDownload> {
  @override
  void initState() {
    super.initState();
    downloadController = StreamController<D2SyncStatus>();
  }

  @override
  void dispose() {
    downloadController.close();
    super.dispose();
  }

  List<String> totalDataToDownload = [];
  double dataDownloaded = 0;

  bool _syncAction = false;

  downloadTrackerData(String programId,
      {required D2ObjectBox db, required D2ClientService client}) async {
    D2TrackedEntityRepository trackedEntityRepo = D2TrackedEntityRepository(db);
    D2EnrollmentRepository enrollmentRepo = D2EnrollmentRepository(db);
    D2EventRepository eventRepo = D2EventRepository(db);
    D2Program? program = D2ProgramRepository(db).getByUid(programId);

    if (program != null) {
      if (program.programType == 'WITH_REGISTRATION') {
        trackedEntityRepo.setProgram(program);
        trackedEntityRepo.initializeQuery();
        trackedEntityRepo.label = '${program.shortName} Registrations';
        trackedEntityRepo
            .setDownloadPageSize(AppConfig.paging)
            .setupDownload(client)
            .download();
        await downloadController.addStream(trackedEntityRepo.downloadStream);
        enrollmentRepo.setProgram(program);
        enrollmentRepo.label = '${program.shortName} Enrollments';
        enrollmentRepo
            .setDownloadPageSize(AppConfig.paging)
            .setupDownload(client)
            .download();

        await downloadController.addStream(enrollmentRepo.downloadStream);
      }
      eventRepo.label = '${program.shortName} Sessions & Visits';
      eventRepo.setProgram(program);
      eventRepo
          .setDownloadPageSize(AppConfig.paging)
          .setupDownload(client)
          .download();
      await downloadController.addStream(eventRepo.downloadStream);
    } else {
      Fluttertoast.showToast(msg: 'Error, no program with id $programId');
    }
  }

  downloadAggregateData(List<String> dataSetIds,
      {required D2ObjectBox db,
      required D2ClientService client,
      required List<String> orgUnitIds}) async {
    List<String> periods = [];

    for (String dataSetId in dataSetIds) {
      D2DataSet? dataSet = D2DataSetRepository(db).getByUid(dataSetId);
      if (dataSet == null) {
        continue;
      }
      List<String> periodList = D2PeriodType.fromId(
              AppUtil.camelCaseToSnakeCase(dataSet.periodType),
              year: DateTime.now().year,
              category: D2PeriodTypeCategory.fixed)
          .periods
          .map<String>((D2Period period) => period.id)
          .toList()
          .cast<String>();
      periods.addAll(periodList);
    }
    D2DataValueSetRepository repository = D2DataValueSetRepository(db);
    repository
        .setupDownload(
            client: client,
            dataSetIds: dataSetIds,
            periods: periods,
            orgUnitIds: orgUnitIds)
        .download();
    await downloadController.addStream(repository.downloadStream);
  }

  @override
  Widget build(BuildContext context) {
    Future<dynamic> downloadData() async {
      D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;
      D2User user = D2UserRepository(db).get()!;
      setState(() {
        _syncAction = true;
        totalDataToDownload = [...AppUtil.getProgramsToSync(user)];
      });
      downloadController = StreamController<D2SyncStatus>();
      D2ClientService client =
          Provider.of<D2ClientState>(context, listen: false).client;

      try {
        for (String programId in AppUtil.getProgramsToSync(user)) {
          await downloadTrackerData(programId, db: db, client: client);
          setState(() {
            dataDownloaded = dataDownloaded + 1;
          });
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg:
                'There were issues downloading the data. Please try again or contact the system administrator');
      } finally {
        await downloadController.close();
        setState(() {
          _syncAction = false;
          dataDownloaded = 0;
        });
      }
    }

    return Container(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        right: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Text(
              'Data download',
              style: const TextStyle().copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          LineSeparator(
            color: CustomColor.primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 20.0),
          Visibility(
            visible: _syncAction,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 20.0,
              ),
              child: SynchronizationProgressBar(
                processPercentage: downloadController,
                isProcessCompleted: true,
                backgroundColor: CustomColor.primaryColor,
                textColor: CustomColor.primaryColor,
                selectedMetadata: totalDataToDownload,
                syncedMetadata: dataDownloaded,
                label: 'Downloading',
              ),
            ),
          ),
          ActionButton(
            onTap: () {
              downloadData();
            },
            isLoading: _syncAction,
            label: 'Download Data',
            loadingLabel: 'Downloading Data...',
          ),
        ],
      ),
    );
  }
}
