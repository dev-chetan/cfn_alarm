//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <cfn_alarm/cfn_alarm_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) cfn_alarm_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "CfnAlarmPlugin");
  cfn_alarm_plugin_register_with_registrar(cfn_alarm_registrar);
}
