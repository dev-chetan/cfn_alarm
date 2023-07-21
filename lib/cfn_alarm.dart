
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
}
