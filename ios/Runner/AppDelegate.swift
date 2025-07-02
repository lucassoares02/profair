// import UIKit
// import Flutter

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1️⃣ Inicializa o Firebase
    FirebaseApp.configure()

    // 2️⃣ Define este AppDelegate como delegate de notificações
    UNUserNotificationCenter.current().delegate = self

    // 3️⃣ Registra o app para receber notificações APNs
    application.registerForRemoteNotifications()

    // 4️⃣ Registra plugins do Flutter
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 📲 Recebe o deviceToken do APNs e repassa ao Firebase Messaging
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // 🚨 Captura falha no registro APNs
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ Falha ao registrar APNs: \(error)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  // 🔔 Exibe notificações em foreground (iOS 10+)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // mostra alerta, badge e som mesmo com o app aberto
    completionHandler([.alert, .badge, .sound])
  }
}
