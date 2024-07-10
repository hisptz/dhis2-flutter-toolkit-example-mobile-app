
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AggregateForm extends StatefulWidget {
  const AggregateForm(
      {super.key,
      required this.orgUnitId,
      required this.dataElement,
      required this.dataSet,
      required this.period});

  final String orgUnitId;
  final D2DataElement dataElement;
  final D2DataSet dataSet;
  final String period;

  @override
  State<AggregateForm> createState() => _AggregateFormState();
}

class _AggregateFormState extends State<AggregateForm> {
  late D2DataSetStateFormController controller;

  @override
  void initState() {
    D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;

    Map<String, dynamic> initialValues = getInitialValues(db);
    controller = D2DataSetStateFormController(
        dataSet: widget.dataSet,
        db: db,
        period: widget.period,
        orgUnitId: widget.orgUnitId,
        initialValues: initialValues);
    super.initState();
  }

  Map<String, dynamic> getInitialValues(D2ObjectBox db) {
    Map<String, dynamic> values = {};
    List<D2DataValueSet> dataValues = D2DataValueSetRepository(db)
        .box
        .query(D2DataValueSet_.period.equals(widget.period).and(D2DataValueSet_
            .organisationUnit
            .equals(D2OrgUnitRepository(db).getIdByUid(widget.orgUnitId)!)
            .and(D2DataValueSet_.attributeOptionCombo.equals(widget
                .dataSet.categoryCombo.target!.categoryOptionCombos.first.id))))
        .build()
        .find();
    for (D2DataValueSet dataValueSet in dataValues) {
      values.addAll({
        '${dataValueSet.dataElement.target!.uid}.${dataValueSet.categoryOptionCombo.target!.uid}':
            dataValueSet.value
      });
    }

    return values;
  }

  List<D2BaseInputFieldConfig> getFields() {
    List<D2BaseInputFieldConfig> fields = [];
    D2DataElement d2dataElement = widget.dataElement;
    for (D2CategoryOptionCombo element
        in d2dataElement.categoryCombo.target!.categoryOptionCombos) {
      String name = '${d2dataElement.uid}.${element.uid}';
      String label = element.name;

      D2BaseInputFieldConfig inputFieldConfig =
          D2FormUtils.getFieldConfigFromDataItem(d2dataElement);
      inputFieldConfig.name = name;
      inputFieldConfig.label = label;
      fields.add(inputFieldConfig);
    }
    return fields;
  }

  @override
  Widget build(BuildContext context) {
    List<D2BaseInputFieldConfig> fields = getFields();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Consumer<AppModuleSelectionState>(
        builder: (context, selectedModuleState, child) {
          return Column(
            children: [
              D2InputFieldContainer(
                  input: D2BaseInputFieldConfig(
                    label: 'Period',
                    name: 'period',
                    type: D2InputFieldType.text,
                    icon: Icons.calendar_month,
                    mandatory: true,
                  ),
                  onChange: (value) {},
                  disabled: true,
                  value: D2PeriodType.getPeriodById(widget.period).name,
                  color: selectedModuleState.selectedAppModule.color),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
              ),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  itemBuilder: (context, index) {
                    D2BaseInputFieldConfig input = fields[index];
                    input.clearable = true;
                    return D2FormControlledInputField(
                        input: input,
                        controller: controller,
                        color: selectedModuleState.selectedAppModule.color);
                  },
                  separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                      ),
                  itemCount: fields.length),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    controller.save().then((value) {
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
                    backgroundColor:
                        selectedModuleState.selectedAppModule.color,
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
              )
            ],
          );
        },
      ),
    );
  }
}
