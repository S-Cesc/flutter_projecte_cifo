// ignore_for_file: unused_local_variable

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mis Pastis';

  @override
  String get notificationTitle => 'Tómate las pastillas!';

  @override
  String get notificationText1 => 'Te has de tomar las pastillas.';

  @override
  String get notificationText2 => 'Por favor, toque para abrir la app';

  @override
  String get initializing => 'Iniciando...';

  @override
  String get loadingParameters => 'Cargando parámetros...';

  @override
  String get settingConfiguration => 'Estableciendo la configuración...';

  @override
  String get requiredPermissions => 'Verificando los permisos necesarios...';

  @override
  String get initializingServices => 'Iniciando servicios...';

  @override
  String get failedPermissions => 'No se han concedido los permisos necesarios';

  @override
  String get informationLoaded => 'Listo!';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get saveChanges => 'Salvar';

  @override
  String get undoChanges => 'Deshacer';

  @override
  String get cancel => 'Cancelar';

  @override
  String get discard => 'Descartar';

  @override
  String get saved => 'Datos guardados';

  @override
  String get added => 'Elemento agregado';

  @override
  String get pendingChanges => 'Cambios pendientes';

  @override
  String get pendingChangesMessage => 'Hay cambios pendientes.';

  @override
  String get pendingChangesDiscardQuestion => '¿Quiere descartar los cambios pendientes?';

  @override
  String get pendingChangesDiscarded => 'Se han descartado los cambios pendientes.';

  @override
  String get notSavedCauseOfError => 'Error. No se ha salvado';

  @override
  String get notAddedExisting => 'No se ha agregado: ya existía';

  @override
  String get confirm => 'Confirmar';

  @override
  String confirmDeletion(num count, String gender) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.selectLogic(
      gender,
      {
        'f': 'las',
        'other': 'los',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      gender,
      {
        'f': 'la',
        'other': 'lo',
      },
    );
    String _temp2 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$_temp0',
      one: '$_temp1',
    );
    return '¿Seguro que quiere eliminar$_temp2?';
  }

  @override
  String get exitApplication => 'Salir';

  @override
  String get restartApplication => 'Reinicia';

  @override
  String get askExitApplication => '¿Salir de la aplicación?';

  @override
  String get changeAlarmPermissions => 'Cambiar la configuración de permisos de alarma';

  @override
  String get emptyDaysetError => 'No pueden definirse comidas si no se indica para qué días.';

  @override
  String get timeTableModifiedWarning => 'Se han modificado las horas para mantener la coherencia.';

  @override
  String get snooze => 'Retardar';

  @override
  String get missedAlarm => 'Alarma perdida';

  @override
  String get stoppedAlarm => 'Alarma detenida';

  @override
  String get snoozedAlarm => 'Alarma retrasada';

  @override
  String get once => 'Una vez';

  @override
  String get onceADay => 'Una vez al día (24h)';

  @override
  String get twiceADay => 'Dos veces al día (12h)';

  @override
  String get threeTimesADay => 'Tres veces al día (8h)';

  @override
  String get fourTimesADay => 'Cuatro veces al día (6h)';

  @override
  String get weekly => 'Una vez a la semana';

  @override
  String get everyTwoWeeks => 'Cada dos semanas';

  @override
  String get fortnightly => 'Cada quince días (dos veces al mes)';

  @override
  String get everyFourWeeks => 'Cada cuatro semanas';

  @override
  String get monthly => 'Una vez al mes';

  @override
  String get once_tooltip => 'Tomar las pastillas una vez, sólo una vez.';

  @override
  String get onceADay_tooltip => 'Tomar las pastillas diariamente, cada 24h.';

  @override
  String get twiceADay_tooltip => 'Tomar las pastillas dos veces al día, cada 12h.';

  @override
  String get threeTimesADay_tooltip => 'Tomar las pastillas tres veces al día, cada 8h.';

  @override
  String get fourTimesADay_tooltip => 'Tomar las pastillas cuatro veces al día, cada 6h.';

  @override
  String get weekly_tooltip => 'Tomar las pastillas semanalmente, una vez a la semana, siempre el mismo día de la semana.';

  @override
  String get everyTwoWeeks_tooltip => 'Tomar las pastillas cada dos semanas, siempre el mismo día de la semana.';

  @override
  String get fortnightly_tooltip => 'Tomar pastillas cada quince días, dos veces al mes, siempre el mismo día del mes.';

  @override
  String get everyFourWeeks_tooltip => 'Tomar las pastillas cada cuatro semanas, siempre el mismo día de la semana.';

  @override
  String get monthly_tooltip => 'Tomar las pastillas una vez al mes, siempre el mismo día del mes.';

  @override
  String get alarmSettings => 'Configuración de las alarmas';

  @override
  String get alarmRepeatTimes => 'Repeticiones';

  @override
  String get alarmDurationSeconds => 'Duración en segundos';

  @override
  String get alarmSnoozeSeconds => 'Segundos hasta la repetición';

  @override
  String get minutesToDealWithAlarm => 'Minutos para atender la alarma';

  @override
  String get tooltipAlarmRepeatTimes => 'Número veces que suena la alarma hasta que se da por perdida';

  @override
  String get tooltipSnoozeSeconds => 'Segundos desde que termina de sonar la alarma sin haberla detenido hasta que se repite automáticamente';

  @override
  String get tooltipAlarmDurationSeconds => 'Segundos que suena la alarma si no se detiene';

  @override
  String get tooltipMinutesToDealWithAlarm => 'Minutos que como máximo transcurren desde que se acepta la alarma hasta indicar que se han tomado las pastillas';

  @override
  String get timeSettings => 'Minutos antes/después';

  @override
  String get minutesLongBefore => 'Minutos mucho antes';

  @override
  String get minutesBefore => 'Minutos antes';

  @override
  String get minutesAfter => 'Minutos después';

  @override
  String get minutesLongAfter => 'Minutos mucho después';

  @override
  String get tooltipLongBefore => 'Minutos desde que se toman las pastillas entre comidas hasta comer. Se combina con el valor indicado para mucho después de la anterior comida. Aplica si toma pastillas entre comidas.';

  @override
  String get tooltipBefore => 'Minutos antes de las comidas que se le notifica para tomar las pastillas antes de las comidas. Aplica si toma pastillas antes de las comidas.';

  @override
  String get tooltipAfter => 'Minutos que se suman al tiempo usado para comer. Aplica si toma pastillas después de las comidas.';

  @override
  String get tooltipLongAfter => 'Minutos que tienen que pasar después de las comidas para tomar las pastillas entre comidas. Aplica si toma pastillas entre comidas.';

  @override
  String get timeEating => 'Tiempo para comer';

  @override
  String get timeEatingTooltip => 'Tiempo que dedica a cada comida. Sólo tiene que establecer valores para las comidas que realiza. Se diferencian valores «rápidos» y «lentos».';

  @override
  String get bkfDuration => 'Duración del desayuno, en minutos.';

  @override
  String get elevensesDuration => 'Duración del café de media mañana, en minutos.';

  @override
  String get brunchDuration => 'Duración del almuerzo, en minutos.';

  @override
  String get lunchDuration => 'Duración de la comida, en minutos.';

  @override
  String get teaDuration => 'Duración del café, en minutos.';

  @override
  String get highTeaDuration => 'Duración de la merienda, en minutos.';

  @override
  String get dinnerDuration => 'Duración de la cena, en minutos.';

  @override
  String get supperDuration => 'Duración del resopón, en minutos.';

  @override
  String get meal => 'Comida';

  @override
  String get breakfast => 'desayuno';

  @override
  String get elevenses => 'café de media mañana';

  @override
  String get brunch => 'almuerzo';

  @override
  String get lunch => 'comida';

  @override
  String get tea => 'café';

  @override
  String get highTea => 'merienda';

  @override
  String get dinner => 'cena';

  @override
  String get supper => 'resopón';

  @override
  String get longBefore => 'mucho antes';

  @override
  String get before => 'antes';

  @override
  String get at => 'durante';

  @override
  String get after => 'después';

  @override
  String get longAfter => 'mucho después';

  @override
  String get slowLabel => 'Lento';

  @override
  String get mediumLabel => 'Normal';

  @override
  String get fastLabel => 'Rápido';

  @override
  String get alarmList => 'Lista de alarmas';

  @override
  String get alarms => 'Alarmas';

  @override
  String get weeklyTimetable => 'Rutina semanal';

  @override
  String get mealsForPills => 'Comidas para pastillas';

  @override
  String get weeklyDefaultTimetable => 'Usual';

  @override
  String get weeklyAltTimetable1 => 'Alt-1';

  @override
  String get weeklyAltTimetable2 => 'Alt-2';

  @override
  String get weeklyAltTimetable3 => 'Alt-3';

  @override
  String get defaultWeeklyTimetable => 'Comidas que realiza habitualmente y a qué hora';

  @override
  String get specialWeeklyTimetable => 'Comidas y su hora en los días determinados';

  @override
  String get configMealsTooltip => 'Deben definirse las comidas de cada día, para que el sistema pueda conocer los intervalos de tiempo entre comidas. Además se pueden definir otras tres rutinas alternativas para días concretos de la semana.';

  @override
  String get createNewAlarm => 'Crear nueva alarma';

  @override
  String get pillsLongBeforeBreakfast => 'pastillas de la mañana';

  @override
  String get pillsBeforeBreakfast => 'pastillas de antes de desayunar';

  @override
  String get pillsAtBreakfast => 'pastillas del desayuno';

  @override
  String get pillsAfterBreakfast => 'pastillas de después del desayuno';

  @override
  String get pillsLongBeforeElevenses => 'pastillas de mucho antes del café de media mañana';

  @override
  String get pillsBeforeElevenses => 'pastillas de antes del café de media mañana';

  @override
  String get pillsAtElevenses => 'pastillas del café de media mañana';

  @override
  String get pillsAfterElevenses => 'pastillas després del café de media mañana';

  @override
  String get pillsLongBeforeBrunch => 'pastillas de mucho antes del almuerzo';

  @override
  String get pillsBeforeBrunch => 'pastillas de antes del almuerzo';

  @override
  String get pillsAtBrunch => 'pastillas del almuerzo';

  @override
  String get pillsAfterBrunch => 'pastillas de después del almuerzo';

  @override
  String get pillsLongBeforeLunch => 'pastillas de mucho antes de la comida';

  @override
  String get pillsBeforeLunch => 'pastillas de antes de la comida';

  @override
  String get pillsAtLunch => 'pastillas de la comida';

  @override
  String get pillsAfterLunch => 'pastillas de después la comida';

  @override
  String get pillsLongBeforeTea => 'pastillas de mucho antes de la hora del café';

  @override
  String get pillsBeforeTea => 'pastillas de antes de la hora del café';

  @override
  String get pillsAtTea => 'pastillas de la hora del café';

  @override
  String get pillsAfterTea => 'pastillas de después de la hora del café';

  @override
  String get pillsLongBeforeHighTea => 'pastillas de mucho antes de merendar';

  @override
  String get pillsBeforeHighTea => 'pastillas de antes de merendar';

  @override
  String get pillsAtHighTea => 'pastillas de merendar';

  @override
  String get pillsAfterHighTea => 'pastillas de después de merendar';

  @override
  String get pillsLongBeforeDinner => 'pastillas de mucho antes de cenar';

  @override
  String get pillsBeforeDinner => 'pastillas de antes de cenar';

  @override
  String get pillsAtDinner => 'pastillas de cenar';

  @override
  String get pillsAfterDinner => 'pastillas de después de cenar';

  @override
  String get pillsLongBeforeSupper => 'pastillas de mucho antes del resopón';

  @override
  String get pillsBeforeSupper => 'pastillas de antes del resopón';

  @override
  String get pillsAtSupper => 'pastillas del resopón';

  @override
  String get pillsAfterSupper => 'pastillas de después del resopón';

  @override
  String get pillsLongAfterSupper => 'pastillas de la noche';
}
