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
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1️⃣ Registra plugins do Flutter
    GeneratedPluginRegistrant.register(with: self)

    // 2️⃣ Inicializa o Firebase se necessário
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }

    // 3️⃣ Configure delegates
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self

    // 4️⃣ Registra APNs
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 📲 APNs trouxe o deviceToken —> encaminha para o Firebase Messaging
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // 🚨 Falha ao registrar no APNs
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
    completionHandler([.alert, .badge, .sound])
  }

  // 🔄 Recebe novo token FCM (registro e refresh)
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let token = fcmToken else { return }
    print("🔄 Novo token FCM: \(token)")
    // Aqui você pode enviar o token para o seu servidor
  }
}


// import UIKit
// import Flutter

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     // 1️⃣ registra plugins do Flutter
//     GeneratedPluginRegistrant.register(with: self)
    
//     // 2️⃣ registra para receber notificações via APNs
//     application.registerForRemoteNotifications()
    
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
