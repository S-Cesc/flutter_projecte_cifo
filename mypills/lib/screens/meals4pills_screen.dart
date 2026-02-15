import 'package:flutter/material.dart';
// Localizations
import '../l10n/app_localizations.dart';
// Project files
import '../common/global_constants.dart';
import '../common/global_functions.dart';
import '../styles/app_styles.dart';
import '../widgets/custom_back_button.dart';

/// Screen to set meals binded to pills
class Meals4pillsScreen extends StatefulWidget {
  /// Ctor
  const Meals4pillsScreen({super.key});

  @override
  State<Meals4pillsScreen> createState() => _Meals4pillsScreenState();
} // Meals4pillsScreen

class _Meals4pillsScreenState extends State<Meals4pillsScreen> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Builder(
      builder: (context) {
        return SafeArea(
          child: DefaultTabController(
            length: 4,
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: AppStyles.colors.mantis,
                appBar: AppBar(
                  backgroundColor: AppStyles.colors.ochre[700],
                  leading: CustomBackButton(
                    // Flutter error: context is not included in the clousure
                    // so, you can't pass areThereChanges func as a parameter
                    // because it depends on a provider defined in context
                    // It seems that context has its own rules
                    // Riverpod does not use the context!
                    areThereChanges: null,
                    /*
                        areThereChanges(
                              context.watch<EditProviderWeeklyTimeTable>(),
                            )
                            ? () => true
                            : null,
                    */                    
                    discardChanges: null,
                    /*
                        () => discard(
                          context.read<EditProviderWeeklyTimeTable>(),
                        ),
                    */
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Stack(
                      children: [
                        TabBar(
                          isScrollable: true,
                          tabs: [
                            Center(
                              child: Text(
                                GlobalFunctions.partitionNames(t).$1,
                                style: AppStyles.constFonts.display,
                              ),
                            ),
                            Center(
                              child: Text(
                                GlobalFunctions.partitionNames(t).$2[0],
                                style: AppStyles.constFonts.labelLarge,
                              ),
                            ),
                            Center(
                              child: Text(
                                GlobalFunctions.partitionNames(t).$2[1],
                                style: AppStyles.constFonts.labelLarge,
                              ),
                            ),
                            Center(
                              child: Text(
                                GlobalFunctions.partitionNames(t).$2[2],
                                style: AppStyles.constFonts.labelLarge,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Tooltip(
                            message: t.configMealsTooltip,
                            triggerMode: TooltipTriggerMode.tap,
                            showDuration: GlobalConstants.tooltipDuration(
                              // TODO: text
                              t.configMealsTooltip.length,
                            ),
                            child: Icon(
                              Icons.help,
                              color: AppStyles.colors.ochre,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  elevation: 4,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {},
                      /*
                          areThereChanges(
                                context.watch<EditProviderWeeklyTimeTable>(),
                              )
                              ? () async {
                                developer.log(
                                  "Undo button clicked! ",
                                  level: Level.FINER.value,
                                );
                                await requery(
                                  context.read<EditProviderWeeklyTimeTable>(),
                                );
                              }
                              : null,
                        */
                      style: AppStyles.textButtonstyle,
                      icon: const Icon(Icons.undo),
                    ),
                    TextButton(
                      onPressed: () {},
                        /*
                          areThereChanges(
                                context.watch<EditProviderWeeklyTimeTable>(),
                              )
                              ? () async {
                                developer.log(
                                  "Save button clicked! ",
                                  level: Level.FINER.value,
                                );
                                await saveValues(
                                  context.read<EditProviderWeeklyTimeTable>(),
                                );
                              }
                              : null,
                        */
                      style: AppStyles.textButtonstyle,
                      child: const Icon(Icons.archive),
                    ),
                  ],
                ),
            
                body: TabBarView(
                  children: [
                  ],
                ),
            ),
          ),
        );
      },
    ); // Builder
  } // build
} // _Meals4pillsScreenState
