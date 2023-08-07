//
//  EventChannelPlugin.swift
//  cfn_alarm
//
//  Created by Chetan Raval on 03/08/23.
//

import Foundation

import Flutter

class EventChannelPlugin: NSObject, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterEventChannel(name: "your_event_channel_name",
                                          binaryMessenger: registrar.messenger())
        let instance = EventChannelPlugin()
        channel.setStreamHandler(instance)
    }
}

extension EventChannelPlugin: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        // Implement the logic to send events to Flutter
        // For example, you can listen to a notification center or some other platform-specific event.
        // Send events using 'events' closure.

        // Example: Send an event every 2 seconds
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            events("Event from iOS: \(Date())")
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        // Cleanup logic if necessary
        return nil
    }
}
