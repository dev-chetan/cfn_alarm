import Flutter
import UIKit
import UserNotifications
import AVFoundation
import Foundation
import AudioToolbox


public class CfnAlarmPlugin: NSObject, FlutterPlugin , UNUserNotificationCenterDelegate {

    var player: AVPlayer?
    var result: FlutterResult?
    var call: FlutterMethodCall?
    var vibrate: Bool?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "cfn_alarm", binaryMessenger: registrar.messenger())
        let instance = CfnAlarmPlugin()
        UNUserNotificationCenter.current().delegate = instance
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        self.call = call
        // START WORK FUNCTION :-
        handleChannel()
    }

    // Handle the alarm when the app is in the foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        let audioPath = userInfo["audioPath"] as! String
        let loopAudio = userInfo["loopAudio"] as! Bool
        print("userNotificationCenter")
        vibrate = userInfo["vibrate"] as? Bool
        self.playSongFromFilePath(audioPath: audioPath,loopAudio:loopAudio,vibrate:vibrate!)
        completionHandler([.alert, .sound])
    }

    // Handle the alarm when the user interacts with the notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        player = nil
        completionHandler()
    }

    // PLAY SONG FROM FILE PATH
    func playSongFromFilePath(audioPath: String, loopAudio: Bool, vibrate: Bool) {
        guard let url = URL(string: audioPath) else {
            print("Invalid song URL")
            return
        }

        // Create an AVPlayerItem with the audio URL
        let playerItem = AVPlayerItem(url: url)
        // Initialize the AVPlayer with the playerItem
        player = AVPlayer(playerItem: playerItem)

        if loopAudio {
            // Add observer for AVPlayerItemDidPlayToEndTime notification
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(handlePlayerItemDidReachEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: playerItem)
        }

        player!.play()
        if vibrate {
            // Trigger vibration effect
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }

    // Function to handle repeat playback
    @objc func handlePlayerItemDidReachEnd(notification: Notification) {
        player!.seek(to: CMTime.zero)
        player!.play()

        if vibrate! {
            // Trigger vibration effect
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }

    // CHANNEL LIST DOWN :-
    func handleChannel(){
        if self.call!.method == "getPlatformVersion" {

        } else if self.call!.method == "scheduleAlarm" {
            checkPermissionStatus()
        } else if self.call!.method == "removeScheduleAlarm" {
            self.stopScheduleAlarm()
        } else {
            self.result!(FlutterMethodNotImplemented)
        }
    }

    // STOP PENDING NOTIFICATION
    func stopScheduleAlarm(){
        // GET DATA FORM FLUTTER :-
        let id = self.call!.arguments as! Int
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { (requests) in
            for request in requests {
                if(request.identifier == String(id)){
                    notificationCenter.removePendingNotificationRequests(withIdentifiers: [String(id)])
                    self.result!(self.responseStatus(code:"200",message:"Remove scheduled alarm successfully Identifier : \(id)"))
                    return
                }
            }
            self.result!(self.responseStatus(code:"500",message:"Not found notification with identifier:\(id)"))
        }
    }

    // DEFAULT RETURN STATUS :-
    func responseStatus (code: String, message: String) -> [String: Any] {
        let dictionary: [String: Any] = [
            "code": code,
            "message": message
        ]
        return dictionary
    }

    // CHECK PERMISSION STATUS :-
    func checkPermissionStatus(){
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.permission()
            } else if settings.authorizationStatus == .denied {
                self.result!(self.responseStatus(code:"100",message:"permission denied"))
            } else if settings.authorizationStatus == .authorized {
                self.checkSoundType()
            }
        })
    }

    // PERMISSION REQUEST FOR NOTIFICATION :-
    func permission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                self.checkPermissionStatus()
            } else {
                self.checkPermissionStatus()
            }
        }
    }

    // CHECK AUDIO TYPE  :-
    func checkSoundType(){
        let args = self.call!.arguments as! Dictionary<String, Any>
        let audioType = args["audioType"] as! String
        if audioType == "network" {
            self.downloadAudio()
        } else {
            self.result!("other")
        }
    }

    // AUDIO DOWNLOAD  :-
    func downloadAudio() {
        let args = self.call!.arguments as! Dictionary<String, Any>
        let audioPath = args["audioPath"] as! String

        let urlString = audioPath
        if let sourceURL = URL(string: urlString) {
            if let fileName = URL(string: audioPath)?.lastPathComponent {
                let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(fileName)")
                self.downloadAudioFile(url: sourceURL, destinationURL: destinationURL) { error in
                    if let error = error {
                        self.result!(self.responseStatus(code:"500", message:"Error downloading audio file: \(error)"))
                    } else {
                        self.scheduleAlarm(fileUrl: destinationURL)
                    }
                }
            }
        } else {
            self.result!(self.responseStatus(code:"500",message: "Invalid URL"))
        }
    }

    // SCHEDULE ALARM FUNCTION :-
    func scheduleAlarm(fileUrl: URL) {

        // GET DATA FORM FLUTTER :-
        print("scheduleAlarm(.......){.......}")
        let args = self.call!.arguments as! Dictionary<String, Any>
        let id = args["id"] as! Int
        let dateTime = args["dateTime"] as! String
        let loopAudio = args["loopAudio"] as! Bool
        let vibrate = args["vibrate"] as! Bool
        let title = args["title"] as! String
        let body = args["body"] as! String
        let subTitle = args["subTitle"] as! String
       // let barrierDismissible = args["barrierDismissible"] as! Bool

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: dateTime) {

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body

            content.userInfo = ["audioPath": "\(fileUrl.absoluteString)",
                                "loopAudio":loopAudio,
                                "vibrate":vibrate
            ] as [String : Any]

            if subTitle.isEmpty == false {
                content.subtitle = subTitle
            }

            var dateComponents = DateComponents()
            dateComponents.year = Calendar.current.component(.year, from: date)
            dateComponents.month = Calendar.current.component(.month, from: date)
            dateComponents.day = Calendar.current.component(.day, from: date)

            let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)

            dateComponents.hour = timeComponents.hour
            dateComponents.minute = timeComponents.minute
            dateComponents.second = timeComponents.second
            
            // Create a trigger with the date components
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            

            // Create a notification request
            let request = UNNotificationRequest(identifier: String(id), content: content, trigger: trigger)

            // Schedule the notification request
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    self.result!(self.responseStatus(code:"300", message:"Failed to schedule alarm: \(error.localizedDescription)"))
                } else {
                    self.result!(self.responseStatus(code:"200", message:"Alarm scheduled successfully"))
                }
            }
        } else {
            self.result!(self.responseStatus(code:"300", message:"Invalid date string, Please set this format : yyyy-MM-dd HH:mm:ss"))
        }
    }


    func convertMP3toWAV(inputURL: URL, outputURL: URL) {
        let asset = AVAsset(url: inputURL)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
        exportSession?.outputFileType = AVFileType.wav
        exportSession?.outputURL = outputURL

        exportSession?.exportAsynchronously(completionHandler: {
            switch exportSession?.status {
            case .completed:
                print("Conversion completed.")
            case .failed:
                if let error = exportSession?.error {
                    print("Conversion failed with error: \(error.localizedDescription)")

                }
            case .cancelled:
                print("Conversion cancelled.")
            default:
                break
            }
        })
    }

    // DOWNLOAD AUDIO FILE FROM INTERNET URL
    func downloadAudioFile(url: URL, destinationURL: URL, completion: @escaping (Error?) -> Void) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: destinationURL.path) {
            let error = NSError(domain: "Already Save File", code: -1, userInfo: nil)
            completion(nil)
            return
        }

        let task = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let tempURL = tempURL else {
                let error = NSError(domain: "Download Error", code: -1, userInfo: nil)
                completion(error)
                return
            }

            do {
                try fileManager.moveItem(at: tempURL, to: destinationURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }

        task.resume()
    }

}
