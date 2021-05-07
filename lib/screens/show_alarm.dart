import 'package:alarm_app/constancts.dart';
import 'package:alarm_app/models/alarmInfo.dart';
import 'package:alarm_app/services/db_services.dart';
import 'package:alarm_app/services/notificationPlugin.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime _alarmTime;

  AlarmHelper _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>> _alarms;
  List<AlarmInfo> _currentAlarms;

  var date;
  @override
  void initState() {
    _alarmTime = DateTime.now();
    _alarmHelper.initializeDatabase().then((value) {
      print('------database intialized');
      loadAlarms();
    });

    super.initState();
  }

  void loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _alarms,
            builder: (context, AsyncSnapshot<List<AlarmInfo>> snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(width: 0.0);
              }
              print("${snapshot.data}");
              _currentAlarms = snapshot.data;
              return ListView(
                children: snapshot.data.map<Widget>((e) {
                  return Text("${e.title}");
                }).toList(),
              );
            }));
  }

  // saving alarm to data base and add alarm details to notifications

  void deleteAlarm(int id) {
    _alarmHelper.delete(id);

    loadAlarms();
  }

  onNotificationInLowerVersions(RecievedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
  }
}
