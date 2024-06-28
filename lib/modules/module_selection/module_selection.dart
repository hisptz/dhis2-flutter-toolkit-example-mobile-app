import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/module_selection/module_selection.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/components/navigation_drawer/navigation_drawer_container.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/app_navigation_type.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/constants/custom_color.dart';
import 'package:dhis2_flutter_toolkit_demo_app/core/utils/app_module_selection_util.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/app_module.dart';
import 'package:dhis2_flutter_toolkit_demo_app/models/base_app_module_data.dart';
import 'package:dhis2_flutter_toolkit_demo_app/modules/module_selection/components/module_selection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ModuleSelection extends StatefulWidget {
  const ModuleSelection({super.key});

  @override
  State<ModuleSelection> createState() => _ModuleSelectionState();
}

class _ModuleSelectionState extends State<ModuleSelection> {
 final PagingController<int, AppModule> _pagingController = PagingController(firstPageKey: 0);
  static const int pageSize = 20;
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
      List<D2Program> programs = await appSelectionUtil.getPrograms(
        offset: pageKey * pageSize,
        limit: pageSize,
      );

      List<AppModule> appModules = programs.map((program) {
        return AppModule(
          title: program.name  ,
          countLabel: 'Number of Events',
          description: program.programType == 'WITH_REGISTRATION' ? 'Tracker Program' : 'Event Program',
          type: AppNavigationType.dataType,
          programs: [program.uid],
          dataType: program.programType == 'WITH_REGISTRATION' ? ModuleDataType.tracker : ModuleDataType.event,
          color: program.dartColor ?? CustomColor.primaryColor,
          homeRoutePath: '/program/${program.uid}',
          db: db,
        );
      }).toList();

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
                    selectedBackgroundColor: CustomColor.primaryColor,
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
                  onSelectionChanged: _onSegmentSelected,),
                 Expanded(
                  child: PagedListView<int, AppModule>(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<AppModule>(
                      itemBuilder: (context, appModule, index) {
                        return ModuleSelectionContainer(
                          disabled: !appModule.available,
                          appModule: appModule,
                          isOpen: appModule.id == selectedAppModule.id,
                          onOpen: () => onOpenAppModule(context),
                          onTap: () => onTapAppModule(
                            context,
                            appModule: appModule,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //         vertical: 10.0,
                //         horizontal: 10.0,
                //       ),
                //       child: Consumer<DBState>(
                //         builder: (_, dbState, child) {
                //           D2ObjectBox db = dbState.db;

                //           AppModuleSelectionUtil appSelectionUtil =
                //               AppModuleSelectionUtil(db);

                //           List<AppModule> appModules =
                //               appSelectionUtil.getAppModuleByType(
                //                   type: AppNavigationType.dataType);

                //           bool allUnavailable =
                //               !appModules.any((module) => module.available);

                //           return Column(
                //             children: [
                //               Visibility(
                //                   visible: allUnavailable,
                //                   child: Container(
                //                     padding: const EdgeInsets.symmetric(
                //                         vertical: 8.0),
                //                     child: const Text(
                //                       'You either do not have access to any of the data modules or form metadata did not download properly.',
                //                       textAlign: TextAlign.center,
                //                     ),
                //                   )),
                //               Visibility(
                //                   visible: allUnavailable,
                //                   child: Center(
                //                     child: InkWell(
                //                       onTap: () {
                //                         onTapAppModule(context,
                //                             appModule: appSelectionUtil
                //                                 .getAppModuleById(
                //                                     'metadata-download')!);
                //                         onOpenAppModule(context);
                //                       },
                //                       borderRadius:
                //                           BorderRadius.circular(100.0),
                //                       child: Container(
                //                         width: double.infinity,
                //                         decoration: BoxDecoration(
                //                           borderRadius:
                //                               BorderRadius.circular(100.0),
                //                           // color: CustomColor.appColor,
                //                         ),
                //                         alignment: Alignment.center,
                //                         padding: const EdgeInsets.symmetric(
                //                           vertical: 10.0,
                //                           horizontal: 10.0,
                //                         ),
                //                         child: Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.center,
                //                           children: [
                //                             Container(
                //                               margin:
                //                                   const EdgeInsets.symmetric(
                //                                 horizontal: 2.5,
                //                               ),
                //                               child: const Icon(
                //                                 Icons.arrow_forward,
                //                                 // color: CustomColor
                //                                 // .appBackgroundColor,
                //                               ),
                //                             ),
                //                             Text(
                //                               'Open Metadata Download',
                //                               style: const TextStyle().copyWith(
                //                                 // color: CustomColor
                //                                 //     .appBackgroundColor,
                //                                 fontWeight: FontWeight.w500,
                //                                 fontSize: 14.0,
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   )),
                //               Visibility(
                //                   visible: allUnavailable,
                //                   child: const Padding(
                //                       padding: EdgeInsets.symmetric(
                //                           vertical: 16.0))),
                //               ...appModules.map(
                //                 (AppModule appModule) =>
                //                     ModuleSelectionContainer(
                //                   disabled: !appModule.available,
                //                   appModule: appModule,
                //                   isOpen: appModule.id == selectedAppModule.id,
                //                   onOpen: () => onOpenAppModule(context),
                //                   onTap: () => onTapAppModule(
                //                     context,
                //                     appModule: appModule,
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
enum Type { program, dataset }