import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cfn_alarm_method_channel.dart';
import 'models/alarm_setting.dart';

abstract class CfnAlarmPlatform extends PlatformInterface {
  /// Constructs a CfnAlarmPlatform.
  CfnAlarmPlatform() : super(token: _token);

  static final Object _token = Object();

  static CfnAlarmPlatform _instance = MethodChannelCfnAlarm();

  /// The default instance of [CfnAlarmPlatform] to use.
  ///
  /// Defaults to [MethodChannelCfnAlarm].
  static CfnAlarmPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CfnAlarmPlatform] when
  /// they register themselves.
  static set instance(CfnAlarmPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<dynamic> scheduleAlarm({required AlarmSetting setting}) {
    throw UnimplementedError('scheduleAlarm() has not been implemented.');
  }

  /// remove schedule notification
  /// ID Means notificationIdentifier
  Future<dynamic> removeScheduleAlarm({required int id}) {
    throw UnimplementedError('removeScheduleAlarm() has not been implemented.');
  }

  Future<dynamic> onNotificationTapListener() {
    throw UnimplementedError('onNotificationTapListener() has not been implemented.');
  }

  Future<dynamic> onNotificationListener() {
    throw UnimplementedError('onNotificationListener() has not been implemented.');
  }
}
