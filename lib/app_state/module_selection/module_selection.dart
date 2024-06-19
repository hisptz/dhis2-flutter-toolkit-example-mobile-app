import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:flutter/foundation.dart';

class AppModuleSelectionState extends ChangeNotifier {
  AppModule? _selectedAppModule;

  AppModule get selectedAppModule => _selectedAppModule ?? AppModule(title: '');

  void clearSelection() {
    _selectedAppModule = null;
  }

  void setSelectedAppModule({
    required AppModule appModule,
  }) {
    _selectedAppModule =
        selectedAppModule.id != appModule.id ? appModule : null;
    notifyListeners();
  }

}
