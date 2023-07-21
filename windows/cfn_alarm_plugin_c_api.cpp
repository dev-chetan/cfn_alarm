#include "include/cfn_alarm/cfn_alarm_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "cfn_alarm_plugin.h"

void CfnAlarmPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  cfn_alarm::CfnAlarmPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
