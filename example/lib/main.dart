import 'package:cfn_alarm/app_enums.dart';
import 'package:flutter/material.dart';

import 'package:cfn_alarm/cfn_alarm.dart';
import 'package:cfn_alarm/models/alarm_setting.dart';
import 'package:intl/intl.dart';

void main() {


  WidgetsFlutterBinding.ensureInitialized();

  CfnAlarm.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _platformVersion1 = 'Unknown';

  @override
  void initState() {
    super.initState();
    initCallBack();


    initPlatformState();
  }

  /// NOTE : DATE TIME SET THIS FORMAT : yyyy-MM-dd HH:mm:ss
  Future<void> initPlatformState() async {
    var initScheduleAlarm = await CfnAlarm.initScheduleAlarm(
        setting: AlarmSetting(
            id: 123,
            dateTime: DateFormat('yyyy-MM-dd HH:mm:ss')
                .format(DateTime.now().copyWith(second: 0, minute: 6)),
            audioPath: "https://samplelib.com/lib/preview/mp3/sample-15s.mp3",
            title: "Notification",
            body: "Notification body",
            audioType: AudioType.network));
    setState(() {
      _platformVersion = initScheduleAlarm!.toString();
    });
  }

  @override
  void dispose() {
    CfnAlarm.onCancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            const SizedBox(height: 35),
            TextButton(
                onPressed: () async {
                  // var s = await CfnAlarm.getPlatformVersion();
                  // debugPrint('DATA : $s');
                  var initScheduleAlarm =
                      await CfnAlarm.removeScheduleAlarm(id: 123);
                  setState(() {
                    _platformVersion1 = initScheduleAlarm!.toString();
                  });
                },
                child: Text("Stop Schedule Alarm : $_platformVersion1"))
          ],
        )),
      ),
    );
  }

  Future<void> initCallBack() async {
    CfnAlarm.onReceived.stream.listen((event) {
      print("event.id : ${event.id}");
    });

    CfnAlarm.onTapReceived.stream.listen((event) {
      print("onTapReceived.id : ${event.id}");
    });
  }
}
