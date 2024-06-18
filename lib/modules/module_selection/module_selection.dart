import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:dhis2_flutter_toolkit_demo_app/app_state/db_provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModuleSelection extends StatefulWidget {
  const ModuleSelection({super.key});

  @override
  State<ModuleSelection> createState() => _ModuleSelectionState();
}

class _ModuleSelectionState extends State<ModuleSelection> {
  @override
  Widget build(BuildContext context) {
    // return Consumer<AppModuleSelectionState>(
    //   builder: (context, dataModuleSelectionState, child) {
        // AppModule selectedAppModule =
        //     dataModuleSelectionState.selectedAppModule;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          // color: selectedAppModule.color,
          child: Scaffold(
            // backgroundColor: selectedAppModule.color,
            appBar: AppBar(
              // backgroundColor: selectedAppModule.color,
              // iconTheme: selectedAppModule.id == ''
              //     ? const IconThemeData(color: CustomColor.appColor)
              //     : const IconThemeData(color: Colors.white),
            ),
            // drawer: const NavigationDrawerContainer(),
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
                        // color: selectedAppModule.id == ''
                        //     ? CustomColor.appColor
                        //     : Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      child: Consumer<DBState>(
                        builder: (_, dbState, child) {
                          D2ObjectBox db = dbState.db;

                          // AppModuleSelectionUtil appSelectionUtil =
                          //     AppModuleSelectionUtil(db);

                          // List<AppModule> appModules =
                          //     appSelectionUtil.getAppModuleByType(
                          //         type: AppNavigationType.dataType);

                          // bool allUnavailable =
                          //     !appModules.any((module) => module.available);

                          return Column(
                            children: [
                              Visibility(
                                  visible: true,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: const Text(
                                      'You either do not have access to any of the data modules or form metadata did not download properly.',
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              Visibility(
                                  // visible: allUnavailable,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        // onTapAppModule(context,
                                        //     appModule: appSelectionUtil
                                        //         .getAppModuleById(
                                        //             'metadata-download')!);
                                        // onOpenAppModule(context);
                                      },
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          // color: CustomColor.appColor,
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 10.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 2.5,
                                              ),
                                              child: const Icon(
                                                Icons.arrow_forward,
                                                // color: CustomColor
                                                    // .appBackgroundColor,
                                              ),
                                            ),
                                            Text(
                                              'Open Metadata Download',
                                              style: const TextStyle().copyWith(
                                                // color: CustomColor
                                                //     .appBackgroundColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                              Visibility(
                                  // visible: allUnavailable,
                                  child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16.0))),
                              // ...appModules.map(
                              //   (AppModule appModule) =>
                              //       DataModuleSelectionContainer(
                              //     disabled: !appModule.available,
                              //     appModule: appModule,
                              //     isOpen: appModule.id == selectedAppModule.id,
                              //     onOpen: () => onOpenAppModule(context),
                              //     onTap: () => onTapAppModule(
                              //       context,
                              //       appModule: appModule,
                              //     ),
                              //   ),
                              // ),
                            ],
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
    //   },
    // );
  }
}
