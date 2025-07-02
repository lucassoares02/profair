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
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1️⃣ Registra plugins Flutter primeiro
    GeneratedPluginRegistrant.register(with: self)

    // 2️⃣ Inicializa o Firebase (se ainda não inicializado)
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }

    // 3️⃣ Define os delegates de notificação e messaging
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self

    // 4️⃣ Registra APNs
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // encaminha o token APNs pro Firebase
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ Falha ao registrar APNs: \(error)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
}

// MARK: - UNUserNotificationCenterDelegate e MessagingDelegate
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

  // iOS: exibe notificações mesmo com app em foreground
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.alert, .badge, .sound])
  }

  // Firebase Messaging: recebe novo token FCM (registro e refresh)
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let token = fcmToken else { return }
    print("🔄 Novo token FCM: \(token)")
    // aqui você pode enviar para o seu servidor
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
