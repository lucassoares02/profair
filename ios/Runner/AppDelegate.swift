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


// import UIKit
// import Flutter
// import Firebase

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

// import UIKit
// import Flutter
// import flutter_local_notifications

// @main
// @objc class AppDelegate: FlutterAppDelegate {

//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     // This is required to make any communication available in the action isolate.
//     FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
//         GeneratedPluginRegistrant.register(with: registry)
//     }

//     if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
//     }

//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }


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



import UIKit
import Flutter
import flutter_local_notifications
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
  // 1️⃣ Inicializa o plugin de notificações locais no isolate de background
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }
    
    // 2️⃣ Registrar plugins do Flutter
    GeneratedPluginRegistrant.register(with: self)
    
    // 3️⃣ Inicializa o Firebase
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    
    // 4️⃣ Configura e pede permissão de notificações (iOS 10+)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { granted, error in
          if let error = error {
            print("❌ Erro ao solicitar permissão de notificação:", error)
          } else {
            print("🎉 Permissão de notificação concedida? \(granted)")
          }
        }
      )
    }
    
    // 5️⃣ Registra o app no APNs
    application.registerForRemoteNotifications()
    
    // 6️⃣ Define o delegate do Messaging para receber o callback de refresh de token
    Messaging.messaging().delegate = self
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 7️⃣ Recebe o deviceToken do APNs e repassa ao Firebase Messaging
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // 8️⃣ Captura falha ao registrar no APNs
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ Falha ao registrar no APNs: \(error)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
}

// MARK: - UNUserNotificationCenterDelegate, MessagingDelegate
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
  
  // 9️⃣ Exibe notificações em foreground
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.alert, .badge, .sound])
  }
  
  // 🔄 Callback de novo token FCM (registro e refresh)
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let token = fcmToken else { return }
    print("🔄 Novo token FCM: \(token)")
    // Envie esse token para o seu servidor aqui
  }
}