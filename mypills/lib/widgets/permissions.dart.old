import 'dart:async';
import 'dart:io' show exit;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  static Future<void> checkPermissions() async {

  }

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

/*

Map<Permission, PermissionStatus> statuses = await [
  Permission.location,
  Permission.storage,
].request();

//Just for only one permission:
if (await Permission.contacts.request().isGranted) {
  // Either the permission was already granted before or the user just granted it.
}

*/

class _MyWidgetState extends State<MyWidget> {
  PermissionStatus _exactAlarmPermissionStatus = PermissionStatus.granted;

  @override
  void initState() {
    super.initState();
    unawaited(_checkExactAlarmPermission());
  }

  Future<void> _checkExactAlarmPermission() async {
    final currentStatus = await Permission.scheduleExactAlarm.status;
    setState(() {
      _exactAlarmPermissionStatus = currentStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (_exactAlarmPermissionStatus.isGranted)
            Text(
              'SCHEDULE_EXACT_ALARM is granted\n\nAlarms scheduling is available',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            )
          else if (_exactAlarmPermissionStatus.isPermanentlyDenied)
            Text(
              'SCHEDULE_EXACT_ALARM is permanently denied\n\nAlarms scheduling is not available',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            )
          else
            Text(
              'SCHEDULE_EXACT_ALARM is denied\n\nAlarms scheduling is not available',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          const SizedBox(height: 32),
          if (_exactAlarmPermissionStatus.isPermanentlyDenied)
            ElevatedButton(
              onPressed: _exactAlarmPermissionStatus.isDenied
                  ? () async {
                      await openAppSettings().then((opened) {
                        // en realitat l'usuari encara no ha canviat el valor...
                        if (opened) {
                          _checkExactAlarmPermission();
                        } else {
                          throw Exception('A permanently denied permission must be granted using application settings');
                        }
                      }).catchError(exit(1));
                    }
                  : null,
              child: const Text('Change alarm permission configuration'),
            )
          else
            ElevatedButton(
              onPressed: _exactAlarmPermissionStatus.isDenied
                  ? () async {
                      await Permission.scheduleExactAlarm
                          .onGrantedCallback(() => setState(() {
                                _exactAlarmPermissionStatus =
                                    PermissionStatus.granted;
                              }))
                          .request();
                    }
                  : null,
              child: const Text('Request exact alarm permission'),
            ),
        ],
      ),
    );
  }
}
