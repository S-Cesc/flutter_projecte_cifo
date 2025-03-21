// ignore_for_file: unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Meues Pastis';

  @override
  String get notificationTitle => 'Pren-te les pastilles!';

  @override
  String get notificationText1 => 'T\'has de prendre les pastilles.';

  @override
  String get notificationText2 => 'Si us plau, toca per a obrir l\'app';

  @override
  String get initializing => 'Iniciant...';

  @override
  String get loadingParameters => 'Carregant paràmetres...';

  @override
  String get settingConfiguration => 'Establint la configuració...';

  @override
  String get requiredPermissions => 'Verificant els permissos necessaris...';

  @override
  String get initializingServices => 'Iniciant serveis...';

  @override
  String get failedPermissions => 'No heu concedit els permissos necessaris';

  @override
  String get informationLoaded => 'Preparat!';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get saveChanges => 'Desa';

  @override
  String get undoChanges => 'Desfés';

  @override
  String get cancel => 'Cancel·la';

  @override
  String get discard => 'Descarta';

  @override
  String get saved => 'S\'ha desat';

  @override
  String get added => 'S\'ha afegit l\'element';

  @override
  String get pendingChanges => 'Canvis pendents';

  @override
  String get pendingChangesMessage => 'N\'hi ha canvis pendents.';

  @override
  String get pendingChangesDiscardQuestion => 'Voleu descartar els canvis pendents?';

  @override
  String get pendingChangesDiscarded => 'S\'han descartat els canvis pendents.';

  @override
  String get notSavedCauseOfError => 'Error; no s\'ha desat';

  @override
  String get notAddedExisting => 'No s\'ha afegit: ja existeix';

  @override
  String get confirm => 'Confirmeu';

  @override
  String confirmDeletion(num count, String gender) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'f': 'les',
        'other': 'els',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      gender,
      {
        'f': 'la',
        'other': 'el',
      },
    );
    String _temp2 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$_temp0 (\$count)',
      one: '$_temp1',
    );
    return 'Segur que $_temp2 voleu eliminar?';
  }

  @override
  String get exitApplication => 'Sortir';

  @override
  String get restartApplication => 'Reinicia';

  @override
  String get askExitApplication => 'Sortir de l\'aplicació?';

  @override
  String get changeAlarmPermissions => 'Canviar la configuració de permisos d\'alarma';

  @override
  String get emptyDaysetError => 'No poden definir-se menjades si no s\'indica per a quins dies.';

  @override
  String get timeTableModifiedWarning => 'S\'han modificat les hores per mantenir la coherència.';

  @override
  String get snooze => 'Retarda';

  @override
  String get missedAlarm => 'Alarma perduda';

  @override
  String get stoppedAlarm => 'Alarma detinguda';

  @override
  String get snoozedAlarm => 'Alarma retardada';

  @override
  String get once => 'Una vegada';

  @override
  String get onceADay => 'Una vegada al dia (24h)';

  @override
  String get twiceADay => 'Dues vegades al dia (12h)';

  @override
  String get threeTimesADay => 'Tres vegades al dia (8h)';

  @override
  String get fourTimesADay => 'Quatre vegades al dia (6h)';

  @override
  String get weekly => 'Una vegada a la setmana';

  @override
  String get everyTwoWeeks => 'Cada dues setmanes';

  @override
  String get fortnightly => 'Cada quinze dies (dues vegades al mes)';

  @override
  String get everyFourWeeks => 'Cada quatre setmanes';

  @override
  String get monthly => 'Una vegada al mes';

  @override
  String get once_tooltip => 'Prendre les pastilles una vegada, només una vegada.';

  @override
  String get onceADay_tooltip => 'Prendre les pastilles diàriament, cada 24h.';

  @override
  String get twiceADay_tooltip => 'Prendre les pastilles dues vegades al dia, cada 12h.';

  @override
  String get threeTimesADay_tooltip => 'Prendre les pastilles tres vegades al dia, cada 8h.';

  @override
  String get fourTimesADay_tooltip => 'Prendre les pastilles quatre vegades al dia, cada 6h.';

  @override
  String get weekly_tooltip => 'Prendre les pastilles setmanalment, una vegada a la setmana, sempre el mateix dia de la setmana.';

  @override
  String get everyTwoWeeks_tooltip => 'Prendre les pastilles cada dues setmanes, sempre el mateix dia de la setmana.';

  @override
  String get fortnightly_tooltip => 'Prendre pastilles cada quinze dies, dues vegades al mes, sempre el mateix dia del mes.';

  @override
  String get everyFourWeeks_tooltip => 'Prendre les pastilles cada quatre setmanes, sempre el mateix dia de la setmana.';

  @override
  String get monthly_tooltip => 'Prendre les pastilles una vegada al mes, sempre el mateix dia del mes.';

  @override
  String get alarmSettings => 'Configuració d\'alarmes';

  @override
  String get alarmRepeatTimes => 'Repeticions';

  @override
  String get alarmDurationSeconds => 'Durada en segons';

  @override
  String get alarmSnoozeSeconds => 'Segons fins a la repetició';

  @override
  String get minutesToDealWithAlarm => 'Minuts per a atendre l\'alarma';

  @override
  String get tooltipAlarmRepeatTimes => 'Nombre de vegades que sona l\'alarma fins que es considera perduda';

  @override
  String get tooltipSnoozeSeconds => 'Segons des de que acaba de sonar l\'alarma sense haver-la aturat fins que es repeteix automàticament';

  @override
  String get tooltipAlarmDurationSeconds => 'Segons que l\'alarma està sonant si no s\'atura';

  @override
  String get tooltipMinutesToDealWithAlarm => 'Minuts que transcorren com a màxim des de que s\'accepta l\'alarma fins a indicar que s\'han pres les pastilles';

  @override
  String get timeSettings => 'Minuts abans/després';

  @override
  String get minutesLongBefore => 'Minuts molt abans';

  @override
  String get minutesBefore => 'Minuts abans';

  @override
  String get minutesAfter => 'Minuts després';

  @override
  String get minutesLongAfter => 'Minuts molt després';

  @override
  String get tooltipLongBefore => 'Minuts d\'ençà que es prenen les pastilles entre menjades fins a menjar. Es combina amb el valor indicat per a molt després de l\'anterior menjada. Aplica si prens pastilles entre menjades.';

  @override
  String get tooltipBefore => 'Minuts abans dels menjars que avisa per a prendre pastilles abans dels menjars. Aplica si prens pastilles abans dels menjars.';

  @override
  String get tooltipAfter => 'Minuts que se sumen al temps per a menjar. Aplica si prens pastilles després dels menjars.';

  @override
  String get tooltipLongAfter => 'Minuts que han de passar després dels menjars per a prendre pastilles entre menjades. Aplica si prens pastilles entre menjades.';

  @override
  String get timeEating => 'Temps per a menjar';

  @override
  String get timeEatingTooltip => 'Temps que dediques a cada menjar. Només has d\'establir valors per als menjars que realitzes. Es diferencien valors «ràpids» i «lents».';

  @override
  String get bkfDuration => 'Durada del desdejuni, en minuts.';

  @override
  String get elevensesDuration => 'Durada del cafè de mig matí, en minuts.';

  @override
  String get brunchDuration => 'Durada de l\'esmorzar, en minuts.';

  @override
  String get lunchDuration => 'Durada del dinar, en minuts.';

  @override
  String get teaDuration => 'Durada del cafè, en minuts.';

  @override
  String get highTeaDuration => 'Durada del berenar, en minuts.';

  @override
  String get dinnerDuration => 'Durada del sopar, en minuts.';

  @override
  String get supperDuration => 'Durada del ressopó, en minuts.';

  @override
  String get meal => 'Menjar';

  @override
  String get breakfast => 'desdejuni';

  @override
  String get elevenses => 'cafè de mig matí';

  @override
  String get brunch => 'esmorzar';

  @override
  String get lunch => 'dinar';

  @override
  String get tea => 'cafè';

  @override
  String get highTea => 'berenar';

  @override
  String get dinner => 'sopar';

  @override
  String get supper => 'ressopó';

  @override
  String get longBefore => 'molt abans';

  @override
  String get before => 'abans';

  @override
  String get at => 'durant';

  @override
  String get after => 'després';

  @override
  String get longAfter => 'molt després';

  @override
  String get slowLabel => 'Lent';

  @override
  String get mediumLabel => 'Normal';

  @override
  String get fastLabel => 'Ràpid';

  @override
  String get weeklyTimetable => 'Rutina setmanal';

  @override
  String get weeklyDefaultTimetable => 'Usual';

  @override
  String get weeklyAltTimetable1 => 'Alt-1';

  @override
  String get weeklyAltTimetable2 => 'Alt-2';

  @override
  String get weeklyAltTimetable3 => 'Alt-3';

  @override
  String get defaultWeeklyTimetable => 'Menjars que feu habitualment i a quina hora';

  @override
  String get specialWeeklyTimetable => 'Menjars i hora en els dies determinats';

  @override
  String get notFullyDefined => 'S\'ha de definir';

  @override
  String get configMealsTooltip => 'Han de definir-se els menjars de cada dia, perquè el sistema pugui conèixer els intervals de temps entre menjars. A més, opcionalment, es poden definir fins a altres tres rutines alternatives per a dies concrets de la setmana.';

  @override
  String get mealsForPills => 'Menjades per a pastilles';

  @override
  String get alarmList => 'Llista d\'alarmes';

  @override
  String get alarms => 'Alarmes';

  @override
  String get createNewAlarm => 'Crear nova alarma';

  @override
  String get pillsLongBeforeBreakfast => 'pastilles del matí';

  @override
  String get pillsBeforeBreakfast => 'pastilles d\'abans del desdejuni';

  @override
  String get pillsAtBreakfast => 'pastilles del desdejuni';

  @override
  String get pillsAfterBreakfast => 'pastilles de després del desdejuni';

  @override
  String get pillsLongBeforeElevenses => 'pastilles de molt abans del cafè de mig matí';

  @override
  String get pillsBeforeElevenses => 'pastilles d\'abans del cafè de mig matí';

  @override
  String get pillsAtElevenses => 'pastilles del cafè de mig matí';

  @override
  String get pillsAfterElevenses => 'pastilles després del cafè de mig matí';

  @override
  String get pillsLongBeforeBrunch => 'pastilles de molt abans d\'esmorzar';

  @override
  String get pillsBeforeBrunch => 'pastilles d\'abans d\'esmorzar';

  @override
  String get pillsAtBrunch => 'pastilles de l\'esmorzar';

  @override
  String get pillsAfterBrunch => 'pastilles de després d\'esmorzar';

  @override
  String get pillsLongBeforeLunch => 'pastilles de molt abans de dinar';

  @override
  String get pillsBeforeLunch => 'pastilles d\'abans de dinar';

  @override
  String get pillsAtLunch => 'pastilles de dinar';

  @override
  String get pillsAfterLunch => 'pastilles de després dinar';

  @override
  String get pillsLongBeforeTea => 'pastilles de molt abans de l\'hora del cafè';

  @override
  String get pillsBeforeTea => 'pastilles d\'abans de l\'hora del cafè';

  @override
  String get pillsAtTea => 'pastilles de l\'hora del cafè';

  @override
  String get pillsAfterTea => 'pastilles de després de l\'hora del cafè';

  @override
  String get pillsLongBeforeHighTea => 'pastilles de molt abans de berenar';

  @override
  String get pillsBeforeHighTea => 'pastilles d\'abans de berenar';

  @override
  String get pillsAtHighTea => 'pastilles del berenar';

  @override
  String get pillsAfterHighTea => 'pastilles de després de berenar';

  @override
  String get pillsLongBeforeDinner => 'pastilles de molt abans de sopar';

  @override
  String get pillsBeforeDinner => 'pastilles d\'abans de sopar';

  @override
  String get pillsAtDinner => 'pastilles de sopar';

  @override
  String get pillsAfterDinner => 'pastilles de després de sopar';

  @override
  String get pillsLongBeforeSupper => 'pastilles de molt abans del ressopó';

  @override
  String get pillsBeforeSupper => 'pastilles d\'abans del ressopó';

  @override
  String get pillsAtSupper => 'pastilles del ressopó';

  @override
  String get pillsAfterSupper => 'pastilles de després del ressopó';

  @override
  String get pillsLongAfterSupper => 'pastilles de la nit';
}
