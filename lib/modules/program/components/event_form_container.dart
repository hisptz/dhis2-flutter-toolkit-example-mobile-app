import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EventFormContainer extends StatefulWidget {
  final AppModule selectedAppModule;
  final D2Event? event;
  final bool editable;

  const EventFormContainer({
    super.key,
    required this.selectedAppModule,
    this.event,
    this.editable = true,
  });

  @override
  State<EventFormContainer> createState() => _EventFormContainerState();
}

class _EventFormContainerState extends State<EventFormContainer> {
  D2TrackerEventFormController? controller;

  @override
  void initState() {
    initializeController();
    super.initState();
  }

  initializeController() {
    D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;
    D2User? user = Provider.of<UserState>(context, listen: false).user;
    List<String>? compatibleOrgUnits = user?.organisationUnits
        .where((String orgUnitId) => widget
            .selectedAppModule.data!.repository.program!.organisationUnits
            .any((D2OrgUnit orgUnit) => orgUnit.uid == orgUnitId))
        .toList();
    if (compatibleOrgUnits != null && compatibleOrgUnits.isNotEmpty) {
      controller = D2TrackerEventFormController(
        db: db,
        event: widget.event,
        programStage: widget
            .selectedAppModule.data!.repository.program!.programStages.first,
        orgUnit: user?.organisationUnits.first,
        mandatoryFields: ['geometry', 'occurredAt'],
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: widget.selectedAppModule.data!.repository.program != null &&
              controller != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                D2TrackerEventForm(
                  disabled: !widget.editable,
                  controller: controller!,
                  programStage: widget.selectedAppModule.data!.repository
                      .program!.programStages.first,
                  options: D2TrackerFormOptions(
                    clearable: true,
                    showTitle: false,
                    showSectionTitle: widget.selectedAppModule.data!.repository
                            .program!.programStages.length >
                        1,
                    formSections: [
                      D2FormSection(
                        id: 'meta',
                        fields: [
                          D2GeometryInputConfig(
                            label: 'Coordinates',
                            type: D2InputFieldType.coordinate,
                            name: 'geometry',
                            mandatory: true,
                          ),
                          D2DateInputFieldConfig(
                            label: 'Session Date',
                            type: D2InputFieldType.date,
                            name: 'occurredAt',
                            mandatory: true,
                          )
                        ],
                      )
                    ],
                  ),
                  color: widget.selectedAppModule.color,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  width: double.infinity,
                  child: Visibility(
                    visible: widget.editable,
                    child: FilledButton(
                      onPressed: () {
                        controller?.save().then((value) {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: 'Saved successfully!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }).catchError((e) {
                          Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                            backgroundColor: Colors.red,
                            fontSize: 16.0,
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.selectedAppModule.color,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'The form is incomplete due to missing configurations.',
                style: const TextStyle().copyWith(
                  color: const Color(0xFF737373),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
    );
  }
}
