import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     GMSServices.provideAPIKey("AIzaSyBTz22r3t2D_xGxtHz1bCJllgMG22MDLSM") // 👈 Add this
    //  GMSServices.provideAPIKey("AIzaSyBqaKKXQOqiLllF9GF68cW1USiMnnWOKI0") // 👈 Add this
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
