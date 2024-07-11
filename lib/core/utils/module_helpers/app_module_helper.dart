import 'package:dhis2_flutter_toolkit_demo_app/core/components/list_card_button.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/material.dart';

abstract class ListData {}

class ListCardData extends ListData {
  String id;
  String title;
  String? svgIcon;
  String? date;
  bool? syncStatus;
  OnPressed onSync;
  Map<String, dynamic>? referralFields;
  Map<String, String>? fields;
  List<Widget>? actionButtons;
  MainAxisAlignment? actionButtonAlignment;

  ListCardData({
    required this.id,
    required this.title,
    required this.onSync,
    this.svgIcon,
    this.date,
    this.syncStatus,
    this.fields,
    this.referralFields,
    this.actionButtons,
    this.actionButtonAlignment,
  });
}

abstract class BaseAppModuleHelper<T> {
  AppModule? selectedAppModule;

  abstract List<Map<String, String>> fieldConfig;

  ListCardData toListCard(T entity, String string);

  void setModule(AppModule module) {
    selectedAppModule = module;
  }
}
