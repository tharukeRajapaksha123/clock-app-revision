import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initializationSettings;
  //object fro notifications
  final BehaviorSubject<RecievedNotification> didReceiveNotificationSubject =
      BehaviorSubject<RecievedNotification>();

  NotificationPlugin._() {
    init();
  }

  void init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  //this function is only for android not for the ios
  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  //initalize the platforms
  initializePlatformSpecifics() {
    var initializationSettingsAndroid = AndroidInitializationSettings(
      'notification_logo',
    );
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // your call back to the UI
        RecievedNotification receivedNotification = RecievedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceiveNotificationSubject.add(receivedNotification);
      },
    );
    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        print("___ oayload is $payload");
      },
    );
  }

  Future<void> showNotification() async {
    var testTime = DateTime.now().add(Duration(seconds: 5));
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      timeoutAfter: 5000,
      sound: RawResourceAndroidNotificationSound("a_long_cold_sting"),
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails(
      sound: "a_long_cold_sting",
    );
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Test Title',
      'Test Body', //null
      testTime, platformChannelSpecifics,
      payload: 'New Payload',
    );
  }

  Future<bool> setWeeklyAtDayTime(int hour, int minute, String alarmName,
      String alarmDescription, int id, Day day) async {
    try {
      var time = Time(
        hour,
        minute,
        0,
      );
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description',
        sound: RawResourceAndroidNotificationSound("a_long_cold_sting"),
        importance: Importance.Max,
        priority: Priority.High,
        styleInformation: DefaultStyleInformation(true, true),
        timeoutAfter: 60000,
      );
      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: "a_long_cold_sting",
        presentSound: true,
      );
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
          id, // has to change
          '$alarmName',
          '$alarmDescription',
          day,
          time,
          platformChannelSpecifics,
          payload: "My Alarm");
      print("alarm added sucussfully");
      return true;
    } catch (e) {
      print("Set alarm failed $e");
      return false;
    }
  }

  void setRecorringAlarm(
    int hour,
    int minute,
    String alarmName,
    String alarmDescription,
    int id,
    List<int> dayList,
  ) {
    print("day list data length is ${dayList.length}");

    if (dayList.contains(1)) {
      notificationPlugin.setWeeklyAtDayTime(
        hour,
        minute,
        "String alarmName",
        "String alarmDescription",
        1,
        Day.Monday,
      );
    }
    if (dayList.contains(2)) {
      notificationPlugin.setWeeklyAtDayTime(
        hour,
        03,
        "String alarmName",
        "String alarmDescription",
        2,
        Day.Tuesday,
      );
    }
    if (dayList.contains(3)) {
      notificationPlugin.setWeeklyAtDayTime(
        hour,
        minute,
        "String alarmName",
        "String alarmDescription",
        3,
        Day.Wednesday,
      );
    }
    if (dayList.contains(4)) {
      notificationPlugin.setWeeklyAtDayTime(
        hour,
        minute,
        "String alarmName",
        "String alarmDescription",
        4,
        Day.Thursday,
      );
    }
    if (dayList.contains(5)) {
      notificationPlugin.setWeeklyAtDayTime(
        hour,
        minute,
        "String alarmName",
        "String alarmDescription",
        5,
        Day.Friday,
      );
    }
    if (dayList.contains(6)) {
      notificationPlugin.setWeeklyAtDayTime(
        hour,
        minute,
        "String alarmName",
        "String alarmDescription",
        6,
        Day.Saturday,
      );
    }
    if (dayList.contains(7)) {
      notificationPlugin.setWeeklyAtDayTime(
        hour,
        minute,
        "String alarmName",
        "String alarmDescription",
        7,
        Day.Sunday,
      );
    }
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class RecievedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  RecievedNotification({this.id, this.title, this.body, this.payload});
}
