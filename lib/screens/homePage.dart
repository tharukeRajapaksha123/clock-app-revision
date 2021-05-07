import 'package:alarm_app/models/alarmInfo.dart';
import 'package:alarm_app/screens/show_alarm.dart';
import 'package:alarm_app/services/db_services.dart';
import 'package:alarm_app/services/notificationPlugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _time;
  List<int> days = [];
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle:
              true, /* actions: [
          TextButton(
              child: Text("See alarms",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {
                Get.to(() => AlarmPage());
              })
        ]*/
        ),
        body: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Select Time",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.pink.withOpacity(0.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      (_time == null)
                          ? "${DateFormat("HH:mm").format(DateTime.now())}"
                          : "$_time",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                      )),
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      var time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      print("${time.hour}:${time.minute}");
                      setState(() {
                        _time = "${time.hour}:${time.minute}";
                      });
                    },
                  )
                ],
              ),
            ),
            Text(
              "Recurring",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
              ),
            ),
            Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildMaterialButton(context, "M", 1),
                      buildMaterialButton(context, "T", 2),
                      buildMaterialButton(context, "W", 3),
                      buildMaterialButton(context, "T", 4),
                    ]),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildMaterialButton(context, "F", 5),
                      buildMaterialButton(context, "S", 6),
                      buildMaterialButton(context, "S", 7),
                    ]),
              ],
            ),
            MaterialButton(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 15.0,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
              onPressed: () {
                print("${days.length}");
                /**/
                showSaveAlarmDialog();
              },
            )
          ],
        )));
  }

  MaterialButton buildMaterialButton(BuildContext context, String day, int d) {
    return MaterialButton(
      onPressed: () {
        setState(() {
          days.add(d);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color:
                (days.contains(d)) ? Colors.red : Colors.blue.withOpacity(0.5),
            shape: BoxShape.circle),
        width: MediaQuery.of(context).size.width / 8,
        height: MediaQuery.of(context).size.width / 8,
        alignment: Alignment.center,
        child: Text(
          "$day",
          style: TextStyle(color: Colors.black, fontSize: 25.0),
        ),
      ),
    );
  }

  TextEditingController name = TextEditingController();
  void showSaveAlarmDialog() {
    Get.dialog(
      Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.7,
          height: MediaQuery.of(context).size.height / 4,
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    validator: (val) =>
                        val.isBlank ? "Please give a name to alarm" : null,
                    controller: name,
                  ),
                ),
                FloatingActionButton.extended(
                  label: Text("Save"),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      if ((_time != null) &&
                          (days.length > 0) &&
                          name.text != null) {
                        notificationPlugin.setRecorringAlarm(
                          int.parse(_time.split(":")[0]),
                          int.parse(_time.split(":")[1]),
                          name.text,
                          "String alarmDescription",
                          100,
                          days,
                        );
                        print("---- name is    ${name.text}");

                        //Get.to(() => AlarmPage());
                      } else {
                        Get.dialog(AlertDialog(
                            title: Text("Olease fill all the forms")));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AlarmHelper _alarmHelper = AlarmHelper();
  void onSaveAlarm(int hour, int minute, String alarmName,
      String alarmDescription, bool isAlarm, DateTime t) {
    var alarmInfo = AlarmInfo(
      alarmDateTime: t,
      title: '$alarmName',
    );
    _alarmHelper.insertAlarm(alarmInfo);
    _alarmHelper.getAlarms().then((value) {
      for (int i = 0; i < value.length; i++) {
        if (alarmInfo.alarmDateTime == value[i].alarmDateTime) {}
      }
    });
    //scheduleAlarm(scheduleAlarmDateTime, alarmInfo);
    Navigator.pop(context);
  }
}
