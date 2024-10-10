import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard let GoogleMapsApiKey = (Bundle.main.object(forInfoDictionaryKey: "GoogleMapsApiKey") as? String) else {
        fatalError("GOOGLE_MAPS_IOS_API_KEY not found in environment")
    }

    GMSServices.provideAPIKey(GoogleMapsApiKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
