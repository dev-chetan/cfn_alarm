import 'package:cfn_alarm/app_enums.dart';

import 'cfn_alarm_platform_interface.dart';
import 'models/alarm_setting.dart';

class CfnAlarm {
  Future<String?> getPlatformVersion() {
    return CfnAlarmPlatform.instance.getPlatformVersion();
  }

  static Future<dynamic> initScheduleAlarm(
      {required AlarmSetting setting}) async {
    return await CfnAlarmPlatform.instance.scheduleAlarm(setting: setting);
  }

  static Future<dynamic> removeScheduleAlarm({required int id}) async {
    return await CfnAlarmPlatform.instance.removeScheduleAlarm(id: id);
  }

  static Future<AlarmSetting> onNotificationTapListener() async {
    var result = await CfnAlarmPlatform.instance.onNotificationTapListener();
    return AlarmSetting(
        id: result['id'],
        dateTime: result['dateTime'],
        audioPath: result['audioPath'],
        title: result['title'],
        body: result['body'],
        audioType: getAudioType(result['audioType']),
        loopAudio: result['loopAudio'],
        vibrate: result['vibrate'],
        subTitle: result['subTitle'],
        filePath: result['filePath'],
        snoozeStatus: result['snoozeStatus'],
        barrierDismissible: result['barrierDismissible']);
  }

  static Future<AlarmSetting> onNotificationListener() async {
    var result = await CfnAlarmPlatform.instance.onNotificationListener();
    return AlarmSetting(
        id: result['id'],
        dateTime: result['dateTime'],
        audioPath: result['audioPath'],
        title: result['title'],
        body: result['body'],
        audioType: getAudioType(result['audioType']),
        loopAudio: result['loopAudio'],
        vibrate: result['vibrate'],
        subTitle: result['subTitle'],
        filePath: result['filePath'],
        snoozeStatus: result['snoozeStatus'],
        barrierDismissible: result['barrierDismissible']);
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
