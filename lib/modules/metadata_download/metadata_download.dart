import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/client_provider/client_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/action_button.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/app_page/app_page_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/check_box_input_field.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/line_seperator.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/synchronization_progress_bar.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/config.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/metadata_download/components/metadata_download_actions.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/metadata_download/constants/metadata_download_constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MetadataDownloadHome extends StatefulWidget {
  const MetadataDownloadHome({super.key});

  @override
  MetadataDownloadHomeState createState() => MetadataDownloadHomeState();
}

class MetadataDownloadHomeState extends State<MetadataDownloadHome> {
  List<String> selectedMetadata = [];
  double syncedMetadata = 0;
  List<String> allMetadata = [
    MetadataDownloadConstant.userInfo,
    MetadataDownloadConstant.systemInfo,
    MetadataDownloadConstant.reportingHierarchy,
    MetadataDownloadConstant.formMetadata,
    // MetadataDownloadConstant.reservedValues,
  ];
  bool _syncAction = false;

  late StreamController<D2SyncStatus> downloadController;

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

  void onSelectAll() {
    setState(() {
      selectedMetadata = List.from(allMetadata);
    });
  }

  void onSelectNone() {
    setState(() {
      selectedMetadata = [];
    });
  }

  void updateSelectedMetadata(String metadata) {
    setState(() {
      if (selectedMetadata.contains(metadata)) {
        selectedMetadata.remove(metadata);
      } else {
        selectedMetadata.add(metadata);
      }
    });
  }

  Future<void> initializeProgramDownload(
      {required D2ObjectBox db, required D2ClientService client}) async {
    D2ProgramRepository d2ProgramRepository = D2ProgramRepository(db);

    D2TrackedEntityTypeRepository d2TrackedEntityTypeRepository =
        D2TrackedEntityTypeRepository(db);

    D2RelationshipTypeRepository d2RelationshipTypeRepository =
        D2RelationshipTypeRepository(db);
    d2TrackedEntityTypeRepository.setupDownload(client).download();
    await downloadController
        .addStream(d2TrackedEntityTypeRepository.downloadStream);
    d2RelationshipTypeRepository.setupDownload(client).download();
    await downloadController
        .addStream(d2RelationshipTypeRepository.downloadStream);
    //Get the saved user first and get the programs
    D2User? user = D2UserRepository(db).get();
    if (user == null) {
      throw 'Error getting user. Please refresh the application';
    }
    List<String> programsToSync = user.programs.toList();

    print('**********getProgramm ${programsToSync}');
    d2ProgramRepository.setupDownload(client, programsToSync).download();
    await downloadController.addStream(d2ProgramRepository.downloadStream);

    D2DataSetRepository d2dataSetRepository = D2DataSetRepository(db);

    List<String> dataSetsToSync = user.dataSets
        .where((element) => AppConfig.dataSets.contains(element))
        .toList();
    await d2dataSetRepository
        .setupDownload(client, dataSetIds: dataSetsToSync)
        .download();
        print('**********getDataSet${dataSetsToSync}');
  }

  Future<dynamic> downloadSelectedMetadata() async {
    setState(() {
      _syncAction = true;
    });
    downloadController = StreamController<D2SyncStatus>();

    D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;
    D2ClientService client =
        Provider.of<D2ClientState>(context, listen: false).client;

    try {
      if (selectedMetadata.contains(MetadataDownloadConstant.userInfo)) {
        D2UserRepository userRepository = D2UserRepository(db);
        userRepository.setupDownload(client).download();
        await downloadController.addStream(userRepository.downloadStream);
        setState(() {
          syncedMetadata = syncedMetadata + 1;
        });
      }

      if (selectedMetadata.contains(MetadataDownloadConstant.systemInfo)) {
        D2SystemInfoRepository systemInfoRepository =
            D2SystemInfoRepository(db);
        systemInfoRepository.setupDownload(client).download();
        await downloadController.addStream(systemInfoRepository.downloadStream);
        setState(() {
          syncedMetadata = syncedMetadata + 1;
        });
      }

      if (selectedMetadata
          .contains(MetadataDownloadConstant.reportingHierarchy)) {
        D2OrgUnitLevelRepository d2orgUnitLevelRepository =
            D2OrgUnitLevelRepository(db);
        D2OrgUnitGroupRepository d2orgUnitGroupRepository =
            D2OrgUnitGroupRepository(db);
        await d2orgUnitLevelRepository.setupDownload(client).download();
        D2OrgUnitRepository reportingHierarchy = D2OrgUnitRepository(db);
        reportingHierarchy.setPageSize(500).setupDownload(client).download();
        await downloadController.addStream(reportingHierarchy.downloadStream);
        await d2orgUnitGroupRepository.setupDownload(client).download();
        setState(() {
          syncedMetadata = syncedMetadata + 1;
        });
      }

      if (selectedMetadata.contains(MetadataDownloadConstant.formMetadata)) {
        await initializeProgramDownload(db: db, client: client);
        setState(() {
          syncedMetadata = syncedMetadata + 1;
        });
      }

      // if (selectedMetadata.contains(MetadataDownloadConstant.reservedValues)) {
      //   D2ReservedValueRepository d2reservedValueRepository =
      //       D2ReservedValueRepository(db);
      //   d2reservedValueRepository.setupDownload(client: client);
      //   // d2reservedValueRepository.downloadAllReservedValues(
      //   //     numberToReserve: AppConfig.numberToReserve);
      //   await downloadController
      //       .addStream(d2reservedValueRepository.downloadStream);
      //   setState(() {
      //     syncedMetadata = syncedMetadata + 1;
      //   });
      // }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _syncAction = false;
        syncedMetadata = 0;
      });
      Fluttertoast.showToast(
          msg:
              'There were issues downloading the selected metadata. Please try again or contact the system administrator');
    } finally {
      await Future.delayed(
        const Duration(seconds: 2),
        await downloadController.close(),
      );
      setState(() {
        _syncAction = false;
        syncedMetadata = 0;
      });
      Provider.of<AppModuleSelectionState>(context, listen: false)
          .clearSelection();
      context.replace('/splash');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModuleSelectionState>(
      builder: (context, dataModuleSelectionState, child) {
        AppModule selectedAppModule =
            dataModuleSelectionState.selectedAppModule;
        return AppPageContainer(
          pageTitle: selectedAppModule.title ?? '',
          onAppBarAddOrEdit: () {},
          onSubAppBarAddOrEdit: () {},
          isDrawerVisible: true,
          pageBodyContainer: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text('Metadata selection',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      )),
                ),
                LineSeparator(color: CustomColor.primaryColor.withOpacity(0.3)),
                MetadataDownloadActions(
                  onSelectAll: onSelectAll,
                  onSelectNone: onSelectNone,
                  isReadOnly: _syncAction,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Column(
                    children: allMetadata.map((metadata) {
                      return CheckBoxInputField(
                        label: metadata,
                        value: selectedMetadata.contains(metadata),
                        onInputValueChange: (value) {
                          updateSelectedMetadata(metadata);
                        },
                        color: CustomColor.primaryColor,
                        isReadOnly: _syncAction,
                      );
                    }).toList(),
                  ),
                ),
                Visibility(
                  visible: _syncAction,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: SynchronizationProgressBar(
                      processPercentage: downloadController,
                      isProcessCompleted: true,
                      backgroundColor: CustomColor.primaryColor,
                      textColor: CustomColor.primaryColor,
                      selectedMetadata: selectedMetadata,
                      syncedMetadata: syncedMetadata,
                      label: 'Downloading',
                    ),
                  ),
                ),
                ActionButton(
                  onTap: () {
                    downloadSelectedMetadata();
                  },
                  isDisabled: selectedMetadata.isEmpty,
                  isLoading: _syncAction,
                  label: 'Download Metadata',
                  loadingLabel: 'Downloading Metadata...',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
