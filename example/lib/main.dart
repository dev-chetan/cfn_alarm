import 'package:cfn_alarm/app_enums.dart';
import 'package:flutter/material.dart';

import 'package:cfn_alarm/cfn_alarm.dart';
import 'package:cfn_alarm/models/alarm_setting.dart';
import 'package:intl/intl.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _cfnAlarmPlugin = CfnAlarm();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  /// NOTE : DATE TIME SET THIS FORMAT : yyyy-MM-dd HH:mm:ss
  Future<void> initPlatformState() async {
    var initScheduleAlarm = await CfnAlarm.initScheduleAlarm(
        setting: AlarmSetting(
            id: 0000,
            dateTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(DateTime.now().copyWith(second: 0, minute: 36)),
            audioPath: "https://samplelib.com/lib/preview/mp3/sample-15s.mp3",
            title: "Notification",
            // loopAudio: true,
            // vibrate: false,
            body: "Notification body",
            audioType: AudioType.network));
    setState(() {
      _platformVersion = initScheduleAlarm!.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
