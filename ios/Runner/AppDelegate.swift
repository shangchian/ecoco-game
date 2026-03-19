import UIKit
import Flutter
import GoogleMaps
import Intents
import IntentsUI

@main
@objc class AppDelegate: FlutterAppDelegate, INUIAddVoiceShortcutViewControllerDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDyX0ZgoDLpATp8zfJBFMymRw3icVP3hC4")
    GeneratedPluginRegistrant.register(with: self)

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let siriChannel = FlutterMethodChannel(name: "com.dream.ECOCO", binaryMessenger: controller.binaryMessenger)
        
    siriChannel.setMethodCallHandler { (call, result) in
        if call.method == "addToSiri" {
            if let args = call.arguments as? [String: Any],
                let title = args["title"] as? String,
                let id = args["id"] as? String,
                let invocationPhrase = args["invocationPhrase"] as? String {
                self.addToSiri(title: title, id: id, invocationPhrase: invocationPhrase)
                result(nil)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            }
        } else {
          result(FlutterMethodNotImplemented)
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "com.dream.ECOCO",
      binaryMessenger: controller.binaryMessenger
    )
        
    // 檢查 activityType
    if userActivity.activityType == "com.dream.ECOCO" {
      channel.invokeMethod("handleShortcut", arguments: [
        "type": "openApp",
        "activityType": userActivity.activityType
      ])
      return true
    } else if userActivity.activityType == "open_station" {
      channel.invokeMethod("handleShortcut", arguments: [
        "type": "station",
        "activityType": userActivity.activityType,
      ])
      return true
    }
    return true
  }

  /// 開啟 Siri 捷徑設定畫面
  func addToSiri(title: String, id: String, invocationPhrase: String) {
    let activity = NSUserActivity(activityType: id)
    activity.title = title
    activity.suggestedInvocationPhrase = invocationPhrase
    activity.isEligibleForSearch = true
    activity.isEligibleForPrediction = true
    activity.persistentIdentifier = "stations"

    let shortcut = INShortcut(userActivity: activity)

    let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
    viewController.delegate = self

    if let rootVC = window?.rootViewController {
      rootVC.present(viewController, animated: true, completion: nil)
    }
  }

  /// Siri 捷徑新增完成後的回調
  func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }

  /// 使用者取消 Siri 捷徑設定的回調
  func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}
