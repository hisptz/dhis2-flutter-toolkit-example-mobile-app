import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/user_state/user_state.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../app_state/app_module_data/app_module_data.dart';

class TrackerFormContainer extends StatefulWidget {
  final AppModule selectedAppModule;
  final bool editable;
  final D2TrackedEntity? trackedEntity;
  final D2Event? event;
  final D2Program? program;
  final D2Enrollment? enrollment;

  const TrackerFormContainer(
      {super.key,
      required this.selectedAppModule,
      this.trackedEntity,
      this.program,
      this.enrollment,
      this.editable = true,
      this.event});

  @override
  State<TrackerFormContainer> createState() =>
      _TrackerFormContainerState();
}

class _TrackerFormContainerState
    extends State<TrackerFormContainer> {
  D2TrackerEnrollmentFormController? controller;

  initializeController() {
    D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;
    D2User? user = Provider.of<UserState>(context, listen: false).user;

    if (widget.program == null) {
      return;
    }

   
    if (user!.organisationUnits.isNotEmpty) {
      controller = D2TrackerEnrollmentFormController(
        db: db,
        enrollment: widget.enrollment,
        trackedEntity: widget.trackedEntity,
        program: widget.program!,
        orgUnit: user.organisationUnits.first,
        mandatoryFields: ['geometry'],
      );
    }
  }

  @override
  void initState() {
    initializeController();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> onSave() async {
    try {
      await controller?.save();
      Navigator.of(context).pop();
      Provider.of<SelectedAppModuleDataState>(context, listen: false).refresh();
      Timer(const Duration(milliseconds: 800), () {
        Fluttertoast.showToast(
          msg: 'Saved successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.red,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: controller != null
          ? Column(
              children: [
                D2TrackerRegistrationForm(
                  disabled: !widget.editable,
                  controller: controller!,
                  color: widget.selectedAppModule.color!,
                  program: widget.program ??
                      widget.selectedAppModule.data!.repository.program,
                  options: D2TrackerFormOptions(
                      clearable: true,
                      showSectionTitle: false,
                      showTitle: widget.program!.programSections.length > 1,
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
                          ],
                        ),
                      ]),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Visibility(
                    visible: widget.editable,
                    child: FilledButton(
                      style: const ButtonStyle().copyWith(
                        backgroundColor: WidgetStateProperty.all(
                            widget.selectedAppModule.color!),
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        textStyle: WidgetStateProperty.all(
                          const TextStyle().copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () {
                        onSave();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Text(
                          'Save',
                          style: const TextStyle().copyWith(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: Container(
                margin: const EdgeInsets.symmetric(),
                child: Text(
                  'The form is incomplete due to missing configurations.',
                  style: const TextStyle().copyWith(),
                ),
              ),
            ),
    );
  }
}
