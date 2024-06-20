import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/client_provider/client_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/action_button.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/line_seperator.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/synchronization_progress_bar.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/config.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_util.dart';

class OfflineDataSummary extends StatefulWidget {
  const OfflineDataSummary({super.key});

  @override
  OfflineDataSummaryState createState() => OfflineDataSummaryState();
}

class OfflineDataSummaryState extends State<OfflineDataSummary> {
  late StreamController<D2SyncStatus> uploadController;
  late int registrationCount;
  late int offlineVisitCount;

  void getCount() {
    D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;
    D2TrackedEntityRepository trackedEntityRepo = D2TrackedEntityRepository(db);
    D2EventRepository eventRepo = D2EventRepository(db);

    setState(() {
      registrationCount = trackedEntityRepo.getUnSyncedQuery().count();
      offlineVisitCount = eventRepo.getUnSyncedQuery().count();
    });
  }

  @override
  void initState() {
    uploadController = StreamController<D2SyncStatus>();
    getCount();
    super.initState();
  }

  @override
  void dispose() {
    uploadController.close();
    super.dispose();
  }

  bool _syncAction = false;

  List<String> totalDataToUpload = [];
  double dataUploaded = 0;

  @override
  Widget build(BuildContext context) {
    D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;
    D2ClientService client =
        Provider.of<D2ClientState>(context, listen: false).client;
    D2User? user = D2UserRepository(db).get();

    Future<void> uploadTrackerData(String programId) async {
      D2TrackedEntityRepository trackedEntityRepo =
          D2TrackedEntityRepository(db);
      D2EnrollmentRepository enrollmentRepo = D2EnrollmentRepository(db);
      D2EventRepository eventRepo = D2EventRepository(db);
      D2RelationshipRepository relationshipRepo = D2RelationshipRepository(db);
      D2Program? program = D2ProgramRepository(db).getByUid(programId);

      if (program != null) {
        if (program.programType == 'WITH_REGISTRATION') {
          trackedEntityRepo.setProgram(program);
          trackedEntityRepo.initializeQuery();

          await trackedEntityRepo.setupUpload(client).upload();

          enrollmentRepo.setProgram(program);
          enrollmentRepo.initializeQuery();
          await enrollmentRepo.setupUpload(client).upload();
        }

        eventRepo.setProgram(program);
        eventRepo.initializeQuery();

        await eventRepo.setupUpload(client).upload();

        relationshipRepo.setProgram(program);
        relationshipRepo.initializeQuery();

        await relationshipRepo.setupUpload(client).upload();
      } else {
        Fluttertoast.showToast(msg: 'Error, no program with id $programId');
      }
    }

    Future<dynamic> uploadData() async {
      setState(() {
        _syncAction = true;
        totalDataToUpload = AppUtil.getProgramsToSync(user);
        uploadController = StreamController<D2SyncStatus>();
      });

      D2SyncStatus status = D2SyncStatus(
          status: D2SyncStatusEnum.syncing,
          label: 'Registration, Visits, and Sessions');
      status.setTotal(totalDataToUpload.length);
      uploadController.add(status);

      try {
        for (String programId in AppUtil.getProgramsToSync(user)) {
          await uploadTrackerData(programId);
          uploadController.add(status.increment());
          setState(() {
            dataUploaded = dataUploaded + 1;
          });
        }
        uploadController.add(status.complete());
        uploadController.close();
      } catch (e) {
        uploadController.close();
        Fluttertoast.showToast(
            msg:
                'There were issues uploading the data. Please try again or contact the system administrator');
      } finally {
        setState(() {
          _syncAction = false;
          dataUploaded = 0;
        });
        getCount();
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
            child: Text('Offline data summary',
                style: const TextStyle().copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                )),
          ),
          LineSeparator(
            color: CustomColor.primaryColor.withOpacity(0.3),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 7.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Offline Registration: ',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF667685),
                          ),
                        ),
                        TextSpan(
                          text: '$registrationCount',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 7.0,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Offline Visits: ',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF667685),
                          ),
                        ),
                        TextSpan(
                          text: '$offlineVisitCount',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _syncAction,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 20.0,
              ),
              child: SynchronizationProgressBar(
                processPercentage: uploadController,
                isProcessCompleted: true,
                backgroundColor: const Color(0xFF4B9F64),
                textColor: const Color(0xFF4B9F64),
                selectedMetadata: AppConfig.programs,
                syncedMetadata: dataUploaded,
                label: 'Uploading',
              ),
            ),
          ),
          ActionButton(
            onTap: () {
              uploadData();
            },
            isLoading: _syncAction,
            label: 'Upload Data',
            loadingLabel: 'Uploading Data...',
          ),
        ],
      ),
    );
  }
}
