import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/navigation_drawer/navigation_drawer_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/app_module_selection_util.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/module_selection/components/module_selection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

enum Type { program, dataset }

class ModuleSelection extends StatefulWidget {
  const ModuleSelection({super.key});

  @override
  State<ModuleSelection> createState() => _ModuleSelectionState();
}

class _ModuleSelectionState extends State<ModuleSelection> {
  final PagingController<int, AppModule> _pagingController =
      PagingController(firstPageKey: 0);
  static const int pageSize = 50;
  bool isProgramSelected = true;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      D2ObjectBox db = Provider.of<DBState>(context, listen: false).db;
      AppModuleSelectionUtil appSelectionUtil = AppModuleSelectionUtil(db);

      List<AppModule> appModules = await appSelectionUtil.getDynamicModules(
        isProgram: isProgramSelected,
        offset: pageKey * pageSize,
        limit: pageSize,
      );

      final isLastPage = appModules.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(appModules);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(appModules, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  onOpenAppModule(BuildContext context) {
    AppModule appModule =
        Provider.of<AppModuleSelectionState>(context, listen: false)
            .selectedAppModule;
    context.replace('/modules${appModule.homeRoutePath ?? ''}');
  }

  onTapAppModule(
    BuildContext context, {
    required AppModule appModule,
  }) {
    Provider.of<AppModuleSelectionState>(context, listen: false)
        .setSelectedAppModule(appModule: appModule);
  }

  void _onSegmentSelected(Set<Type> newSelection) {
    setState(() {
      isProgramSelected = newSelection.contains(Type.program);
      _pagingController.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModuleSelectionState>(
      builder: (context, dataModuleSelectionState, child) {
        AppModule selectedAppModule =
            dataModuleSelectionState.selectedAppModule;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: selectedAppModule.color,
          child: Scaffold(
            backgroundColor: selectedAppModule.color,
            appBar: AppBar(
              backgroundColor: selectedAppModule.color,
              iconTheme: selectedAppModule.id == ''
                  ? const IconThemeData(color: CustomColor.primaryColor)
                  : const IconThemeData(color: Colors.white),
            ),
            drawer: const NavigationDrawerContainer(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Text(
                      'Select Module',
                      style: const TextStyle().copyWith(
                        color: selectedAppModule.id == ''
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SegmentedButton<Type>(
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 251, 253, 255),
                    foregroundColor: Colors.black,
                    selectedForegroundColor: Colors.white,
                    selectedBackgroundColor: selectedAppModule.color ?? CustomColor.primaryColor,
                  ),
                  segments: const <ButtonSegment<Type>>[
                    ButtonSegment<Type>(
                      value: Type.program,
                      label: Text('Programs'),
                      icon: Icon(Icons.apps),
                    ),
                    ButtonSegment<Type>(
                      value: Type.dataset,
                      label: Text('Datasets'),
                      icon: Icon(Icons.apps),
                    ),
                  ],
                  selected: {isProgramSelected ? Type.program : Type.dataset},
                  onSelectionChanged: _onSegmentSelected,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: PagedListView<int, AppModule>(
                      key: PageStorageKey('module_list'),
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<AppModule>(
                        itemBuilder: (context, appModule, index) {
                          return ModuleSelectionContainer(
                            disabled: !appModule.available,
                            appModule: appModule,
                            isOpen: appModule.id == selectedAppModule.id,
                            onOpen: () => onOpenAppModule(context),
                            onTap: () =>
                                onTapAppModule(context, appModule: appModule),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
