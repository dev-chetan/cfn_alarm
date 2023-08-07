import 'dart:async';

import 'package:cfn_alarm/app_enums.dart';
import 'package:flutter/services.dart';

import 'cfn_alarm_platform_interface.dart';
import 'models/alarm_setting.dart';

class CfnAlarm {
  static final StreamController<AlarmSetting> onReceived =
      StreamController<AlarmSetting>();

  static final StreamController<AlarmSetting> onTapReceived =
      StreamController<AlarmSetting>();

  static Future<String?> getPlatformVersion() {
    return CfnAlarmPlatform.instance.getPlatformVersion();
  }

  static onCancel() {
    onReceived.onCancel!();
    onTapReceived.onCancel!();
  }

  static init() {
    const eventChannel = EventChannel("dev_chetan_onReceived");
    eventChannel.receiveBroadcastStream().listen((dynamic event) {

      print(event);

      var callBack = event['onReceived'];
      var callBackTap = event['onTapReceived'];

      if (callBack != null) {
        var alarmSetting = AlarmSetting(
            id: callBack['id'],
            dateTime: callBack['dateTime'],
            audioPath: callBack['audioPath'],
            title: callBack['title'],
            body: callBack['body'],
            audioType: getAudioType(callBack['audioType']),
            loopAudio: callBack['loopAudio'],
            vibrate: callBack['vibrate'],
            subTitle: callBack['subTitle'],
            filePath: callBack['filePath'],
            snoozeStatus: callBack['snoozeStatus'],
            barrierDismissible: callBack['barrierDismissible']);
        onReceived.sink.add(alarmSetting);
      }

      if (callBackTap != null) {
        var alarmSetting = AlarmSetting(
            id: callBackTap['id'],
            dateTime: callBackTap['dateTime'],
            audioPath: callBackTap['audioPath'],
            title: callBackTap['title'],
            body: callBackTap['body'],
            audioType: getAudioType(callBackTap['audioType']),
            loopAudio: callBackTap['loopAudio'],
            vibrate: callBackTap['vibrate'],
            subTitle: callBackTap['subTitle'],
            filePath: callBackTap['filePath'],
            snoozeStatus: callBackTap['snoozeStatus'],
            barrierDismissible: callBackTap['barrierDismissible']);
        onTapReceived.sink.add(alarmSetting);
      }
    });
  }

  static Future<dynamic> initScheduleAlarm(
      {required AlarmSetting setting}) async {
    return await CfnAlarmPlatform.instance.scheduleAlarm(setting: setting);
  }

  static Future<dynamic> removeScheduleAlarm({required int id}) async {
    return await CfnAlarmPlatform.instance.removeScheduleAlarm(id: id);
  }

  static AudioType getAudioType(result) {
    if (result == "network") {
      return AudioType.network;
    } else if (result == "assetsFromProject") {
      return AudioType.assetsFromProject;
    } else {
      return AudioType.audioFileFromMobileGallery;
    }
  }
}
