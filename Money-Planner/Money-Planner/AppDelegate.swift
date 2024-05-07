//
//  AppDelegate.swift
//  Money-Planner
//
//  Created by 유철민 on 1/5/24.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: -7), for: .default)
        let backButtonImage = UIImage(named: "btn_arrow_big")?.withRenderingMode(.alwaysOriginal)
        backButtonImage?.resizeImage(size: CGSize(width: 36, height: 36))
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        
        application.registerForRemoteNotifications()
                
        FirebaseApp.configure()
                
        Messaging.messaging().delegate = self
                
        UNUserNotificationCenter.current().delegate = self
                
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("알림 등록 완료")
            } else {
                print("알림 등록 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
            }
        }
                
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }
            else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
        
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        print("messaging.messaging()")
    }
    


    // foreground 상에서 알림이 보이게끔 해준다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("메시지 수신")
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("토큰: \(fcmToken)")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        
        // 서버로 fcm 토큰 보내기
        if let fcmToken = fcmToken {
            print("\n\nUnwrapped token: \(fcmToken)")
            UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        } else {
            print("fcmToken을 upwrapping 할 수 없습니다.")
        }
        
//        performSendToken()
//        performPatchToken()

    }
    
    func performPatchToken() {
        let token = UserDefaults.standard.value(forKey: "fcmToken") as! String
        NotificationRepository.shared.patchToken(token: token) { result in
            switch result {
            case .success(let data):
                print("패치 성공 \(data)")
            case .failure(let error):
                print("패치 실패 \(error)")
            }
        }
    }
    
    func performSendToken() {
        let token = UserDefaults.standard.value(forKey: "fcmToken") as! String
        NotificationRepository.shared.sendToken(token: token) { result in
            switch result {
            case .success(let data):
                print("보내기 성공 \(data)")
            case .failure(let error):
                print("보내기 실패 \(error)")
            }
        }
    }
}
