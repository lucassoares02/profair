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
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1️⃣ Registra plugins do Flutter
    GeneratedPluginRegistrant.register(with: self)
    
    // 2️⃣ Inicializa o Firebase
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    
    // 3️⃣ Define o delegate do Messaging para receber o token
    Messaging.messaging().delegate = self
    
    // 4️⃣ Registra para receber notificações APNs (necessário para gerar o token)
    application.registerForRemoteNotifications()
    
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

  // 🔄 Callback FCM: aqui chega o token (registro inicial e refresh)
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    guard let token = fcmToken else { return }
    print("✅ FCM token: \(token)")
    // envie para o seu servidor, armazene em prefs, etc.
  }
}
