import 'package:flutter_test/flutter_test.dart';
import 'package:cfn_alarm/cfn_alarm.dart';
import 'package:cfn_alarm/cfn_alarm_platform_interface.dart';
import 'package:cfn_alarm/cfn_alarm_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCfnAlarmPlatform
    with MockPlatformInterfaceMixin
    implements CfnAlarmPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CfnAlarmPlatform initialPlatform = CfnAlarmPlatform.instance;

  test('$MethodChannelCfnAlarm is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCfnAlarm>());
  });

  test('getPlatformVersion', () async {
    CfnAlarm cfnAlarmPlugin = CfnAlarm();
    MockCfnAlarmPlatform fakePlatform = MockCfnAlarmPlatform();
    CfnAlarmPlatform.instance = fakePlatform;

    expect(await cfnAlarmPlugin.getPlatformVersion(), '42');
  });
}
