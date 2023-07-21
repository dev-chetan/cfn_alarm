#ifndef FLUTTER_PLUGIN_CFN_ALARM_PLUGIN_H_
#define FLUTTER_PLUGIN_CFN_ALARM_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace cfn_alarm {

class CfnAlarmPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  CfnAlarmPlugin();

  virtual ~CfnAlarmPlugin();

  // Disallow copy and assign.
  CfnAlarmPlugin(const CfnAlarmPlugin&) = delete;
  CfnAlarmPlugin& operator=(const CfnAlarmPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace cfn_alarm

#endif  // FLUTTER_PLUGIN_CFN_ALARM_PLUGIN_H_
