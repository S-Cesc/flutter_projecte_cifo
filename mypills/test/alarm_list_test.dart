// filepath: /home/cesc/Documents/cursos/flutter/flutter_projecte_cifo/mypills/test/widgets/alarm_list_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mypills/widgets/alarm_list.dart';
import 'package:mypills/model/alarm.dart';
import 'package:mypills/model/meal_pillmealtime_pair.dart';
import 'package:mypills/l10n/app_localizations.dart';

void main() {
  group('AlarmList Widget Tests', () {
    late List<Alarm> alarms;
    late Future<void> Function(int) deleteAlarm;
    late Future<void> Function() restoreAlarms;
    late Future<void> Function() saveAlarms;

    setUp(() {
      alarms = [
        Alarm(12),
        Alarm(25),
      ];
      deleteAlarm = (int id) async {};
      restoreAlarms = () async {};
      saveAlarms = () async {};
    });

    testWidgets('renders AlarmList widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AlarmList(
            alarms: alarms,
            deleteAlarm: deleteAlarm,
            restoreAlarms: restoreAlarms,
            saveAlarms: saveAlarms,
          ),
        ),
      );

      expect(find.byType(AlarmList), findsOneWidget);
    });

    testWidgets('displays list of alarms', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AlarmList(
            alarms: alarms,
            deleteAlarm: deleteAlarm,
            restoreAlarms: restoreAlarms,
            saveAlarms: saveAlarms,
          ),
        ),
      );
      final t = await AppLocalizations.delegate.load((WidgetsBinding.instance.platformDispatcher.locale));
      expect(find.text(MealPillmealtimePair.getPairNameFromId(t,12)), findsOneWidget);
      expect(find.text(MealPillmealtimePair.getPairNameFromId(t,25)), findsOneWidget);
    });

    testWidgets('delete button works', (WidgetTester tester) async {
      bool deleteCalled = false;
      deleteAlarm = (int id) async {
        deleteCalled = true;
      };

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AlarmList(
            alarms: alarms,
            deleteAlarm: deleteAlarm,
            restoreAlarms: restoreAlarms,
            saveAlarms: saveAlarms,
          ),
        ),
      );

      // Assuming there is a delete button with a specific key or icon
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pump();

      expect(deleteCalled, isTrue);
    });

    testWidgets('restore button works', (WidgetTester tester) async {
      bool restoreCalled = false;
      restoreAlarms = () async {
        restoreCalled = true;
      };

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AlarmList(
            alarms: alarms,
            deleteAlarm: deleteAlarm,
            restoreAlarms: restoreAlarms,
            saveAlarms: saveAlarms,
          ),
        ),
      );

      final t = await AppLocalizations.delegate.load((WidgetsBinding.instance.platformDispatcher.locale));

      // Assuming there is a restore button with a specific key or text
      await tester.tap(find.text(t.undoChanges));
      await tester.pump();

      expect(restoreCalled, isTrue);
    });

    testWidgets('save button works', (WidgetTester tester) async {
      bool saveCalled = false;
      saveAlarms = () async {
        saveCalled = true;
      };

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AlarmList(
            alarms: alarms,
            deleteAlarm: deleteAlarm,
            restoreAlarms: restoreAlarms,
            saveAlarms: saveAlarms,
          ),
        ),
      );

      final t = await AppLocalizations.delegate.load((WidgetsBinding.instance.platformDispatcher.locale));

      // Assuming there is a save button with a specific key or text
      await tester.tap(find.text(t.saveChanges));
      await tester.pump();

      expect(saveCalled, isTrue);
    });
  });
}
