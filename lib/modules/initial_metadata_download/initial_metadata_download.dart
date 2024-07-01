import 'dart:async';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/client_provider/client_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/config.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/app_util.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/initial_metadata_download/components/metadata_download_progress.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/login/components/login_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class InitialMetadataDownloadPage extends StatefulWidget {
  const InitialMetadataDownloadPage({super.key});

  @override
  State<InitialMetadataDownloadPage> createState() =>
      _InitialMetadataDownloadPageState();
}

class _InitialMetadataDownloadPageState
    extends State<InitialMetadataDownloadPage>
    with SingleTickerProviderStateMixin {
  bool hasError = false;

  late D2UserRepository d2UserRepository;
  late D2SystemInfoRepository d2SystemInfoRepository;
  late D2OrgUnitRepository d2OrgUnitRepository;
  late D2ProgramRepository d2ProgramRepository;
  late D2TrackedEntityTypeRepository d2TrackedEntityTypeRepository;
  late D2RelationshipTypeRepository d2RelationshipTypeRepository;
  late D2ReservedValueRepository d2reservedValueRepository;
  late D2DataStoreRepository d2dataStoreRepository;
  late D2DataSetRepository d2dataSetRepository;
  late StreamController<D2SyncStatus> formMetadataController;

  Future initializeOrgUnitDownload(
      {required D2ClientService client, required D2ObjectBox db}) async {
    D2OrgUnitLevelRepository d2orgUnitLevelRepository =
        D2OrgUnitLevelRepository(db);
    D2OrgUnitGroupRepository d2orgUnitGroupRepository =
        D2OrgUnitGroupRepository(db);
    await d2orgUnitLevelRepository.setupDownload(client).download();
    await d2OrgUnitRepository
        .setupDownload(client)
        .setPageSize(AppConfig.paging)
        .download();
    await d2orgUnitGroupRepository.setupDownload(client).download();
  }

  Future<void> initializeMetadataDownload() async {
    D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;
    formMetadataController = StreamController<D2SyncStatus>();
    D2ClientService client =
        Provider.of<D2ClientState>(context, listen: false).client;

    d2UserRepository = D2UserRepository(db);
    d2SystemInfoRepository = D2SystemInfoRepository(db);
    d2OrgUnitRepository = D2OrgUnitRepository(db);
    d2ProgramRepository = D2ProgramRepository(db);
    d2TrackedEntityTypeRepository = D2TrackedEntityTypeRepository(db);
    d2RelationshipTypeRepository = D2RelationshipTypeRepository(db);
    d2reservedValueRepository = D2ReservedValueRepository(db);
    d2dataStoreRepository = D2DataStoreRepository(db);
    d2dataSetRepository = D2DataSetRepository(db);

    // Downloading user information
    await d2UserRepository.setupDownload(client).download();
    // Downloading system information
    await d2SystemInfoRepository.setupDownload(client).download();
    // Downloading the reporting hierarchy
    await initializeOrgUnitDownload(client: client, db: db);
    // Downloading metadata for the modules
    await initializeProgramDownload(db: db, client: client);
    d2reservedValueRepository.setupDownload(client: client);
    await d2reservedValueRepository.downloadAllReservedValues(
        numberToReserve:
            AppConfig.numberToReserve);
    d2dataStoreRepository.setupDownload(client: client);
    // await d2dataStoreRepository.initializeDownload(
    //     namespaces: AppConfig.namespaces);
  }

  Future<void> initializeProgramDownload(
      {required D2ObjectBox db, required D2ClientService client}) async {
    await d2TrackedEntityTypeRepository.setupDownload(client).download();

    await d2RelationshipTypeRepository.setupDownload(client).download();

    //Get the saved user first and get the programs
    D2User? user = D2UserRepository(db).get();
    if (user == null) {
      throw 'Error getting user. Please refresh the application';
    }
    List<String> dataSetsToSync = AppUtil.getDataSetsToSync(user);
    d2dataSetRepository
        .setupDownload(client, dataSetIds: dataSetsToSync)
        .download();
    await formMetadataController.addStream(d2dataSetRepository.downloadStream);

    List<String> programsToSync = AppUtil.getProgramsToSync(user);
    d2ProgramRepository.setupDownload(client, programsToSync).download();
    await formMetadataController.addStream(d2ProgramRepository.downloadStream);
  }

  @override
  void initState() {
    initializeMetadataDownload().then((_) {
      context.replace('/');
    }).catchError((error) {
      setState(() {
        hasError = true;
        Fluttertoast.showToast(
          msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xFF656565),
        );
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    d2ProgramRepository.downloadController.close();
    d2OrgUnitRepository.downloadController.close();
    d2RelationshipTypeRepository.downloadController.close();
    d2TrackedEntityTypeRepository.downloadController.close();
    d2SystemInfoRepository.downloadController.close();
    d2UserRepository.downloadController.close();
    d2reservedValueRepository.downloadController.close();
    formMetadataController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double spacingHeight = 8.0;
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Consumer<D2ClientState>(
            builder: (BuildContext context, d2Client, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MetadataDownloadProgress(
                  metadataLabel: 'user information',
                  downloadController: d2UserRepository.downloadController,
                  onRetry: d2UserRepository.download,
                  onDownload:
                      d2UserRepository.setupDownload(d2Client.client).download,
                  allowManualTrigger: hasError,
                ),
                // spacing
                SizedBox(height: spacingHeight),
                MetadataDownloadProgress(
                  metadataLabel: 'system information',
                  downloadController: d2SystemInfoRepository.downloadController,
                  onRetry: d2SystemInfoRepository.download,
                  onDownload: d2SystemInfoRepository
                      .setupDownload(d2Client.client)
                      .download,
                  allowManualTrigger: hasError,
                ),
                // spacing
                SizedBox(height: spacingHeight),
                MetadataDownloadProgress(
                  metadataLabel: 'reporting hierarchy',
                  downloadController: d2OrgUnitRepository.downloadController,
                  onRetry: d2OrgUnitRepository.download,
                  allowManualTrigger: hasError,
                  onDownload: d2OrgUnitRepository
                      .setupDownload(d2Client.client)
                      .setPageSize(AppConfig.paging)
                      .download,
                ),
                SizedBox(height: spacingHeight),
                Consumer<DBState>(
                  builder: (BuildContext context, dbState, child) =>
                      MetadataDownloadProgress(
                    metadataLabel: 'form configurations',
                    downloadController: formMetadataController,
                    onRetry: d2ProgramRepository.download,
                    onDownload: () => initializeProgramDownload(
                        db: dbState.db, client: d2Client.client),
                    allowManualTrigger: hasError,
                  ),
                ),
                SizedBox(height: spacingHeight),
              Consumer<D2ClientState>(
                builder: (context, clientState, child) =>
                    MetadataDownloadProgress(
                  metadataLabel: 'reserved values',
                  downloadController:
                      d2reservedValueRepository.downloadController,
                  onRetry: () async =>
                      await d2reservedValueRepository.downloadAllReservedValues(
                          numberToReserve: AppConfig.numberToReserve),
                  allowManualTrigger: hasError,
                  onDownload: () async {
                    d2reservedValueRepository.setupDownload(
                        client: clientState.client);
                    return await d2reservedValueRepository
                        .downloadAllReservedValues(
                            numberToReserve: AppConfig.numberToReserve);
                  },
                ),
              ),
                SizedBox(
                  height: spacingHeight * 4,
                ),
                Visibility(
                    visible: hasError,
                    child: const Center(
                      child: Text(
                        'There were some issues syncing the required metadata as indicated above. Click on retry to fix the issues. When done, click on Continue',
                        textAlign: TextAlign.center,
                      ),
                    )),
                Visibility(
                    visible: hasError,
                    child: Center(
                      child: LoginButton(
                        isLoginProcessActive: false,
                        buttonText: 'Continue',
                        onLogin: () {
                          context.replace('/');
                        },
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
