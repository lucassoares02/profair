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
import Firebase               // 1. importar Firebase
import UserNotifications      // 2. importar UserNotifications para delegate de notificações

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ⚙️  Inicializa o Firebase (lê o GoogleService-Info.plist automaticamente)
    FirebaseApp.configure()
    
    // 🔔  Define este AppDelegate como delegate de notificações
    UNUserNotificationCenter.current().delegate = self
    
    // 📲  Registra o app para receber notificações remotas via APNs
    application.registerForRemoteNotifications()
    
    // ☁️  Registra plugins do Flutter (mantém depois do Firebase configurado)
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // 👉 Este método é chamado quando o iOS obtém o token APNs
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // Encaminha o token APNs para o Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // 🚨 Captura eventual falha ao registrar no APNs
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ Falha ao registrar APNs: \(error)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  // (Opcional) Tratar notificações recebidas em foreground
  // Só se quiser customizar alerta/ví­bração quando a app estiver aberta
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Exibe banner, badge e toca som mesmo com app em foreground
    completionHandler([.alert, .badge, .sound])
  }
}
