import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cfn_alarm/cfn_alarm_method_channel.dart';

void main() {
  MethodChannelCfnAlarm platform = MethodChannelCfnAlarm();
  const MethodChannel channel = MethodChannel('cfn_alarm');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
