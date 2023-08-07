import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cfn_alarm_platform_interface.dart';
import 'models/alarm_setting.dart';

/// An implementation of [CfnAlarmPlatform] that uses method channels.
class MethodChannelCfnAlarm extends CfnAlarmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cfn_alarm');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<dynamic> scheduleAlarm({required AlarmSetting setting}) async {
    // TODO: Schedule alarm with check permission
    final result = await methodChannel.invokeMethod<dynamic>(
        'scheduleAlarm', setting.toJson());
    return result;
  }

  @override
  Future removeScheduleAlarm({required int id}) async {
    final result =
        await methodChannel.invokeMethod<dynamic>('removeScheduleAlarm', id);
    return result;
  }
}
