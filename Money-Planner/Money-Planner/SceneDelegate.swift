//
//  SceneDelegate.swift
//  Money-Planner
//
//  Created by 유철민 on 1/5/24.
//

import UIKit
import KakaoSDKAuth
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
     
     // 앱이 시작될 때 초기 화면 설정
     func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
         
         // UIWindowScene 유효성 검사
         guard let windowScene = (scene as? UIWindowScene) else { return }
         window = UIWindow(windowScene: windowScene)
         
         let defaults = UserDefaults.standard
         let viewModel = LoginViewModel()
         
//         defaults.removeObject(forKey: "accessToken")
//         defaults.removeObject(forKey: "refreshToken")
//         
         print("____________")
         print(defaults.string(forKey: "accessToken"))
         print(defaults.string(forKey: "refreshToken"))
         print("____________")
         // 임시 토큰 초기 세팅
//         if let accessToken = defaults.string(forKey: "accessToken"){
//             
//         }else{
//             print("엑세스 초기 세팅 완")
//             UserDefaults.standard.set("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMzI0NjEzNzk1IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MTAzMzUxNzF9.JItaIW7T6zZytxAt1BumHJ-FiiVJjWw9WHPRogwJ36Q", forKey: "accessToken")
//         }
//         
//         if let refreshToken = defaults.string(forKey: "refreshToken"){
//             
//         }else{
//             print("리프레쉬 초기 세팅 완")
//             UserDefaults.standard.set("eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MTI4NDA3NzF9.qtPQBdgkOKou1aTepPhJAT7p2izfSir2rfAGmono_u4", forKey: "refreshToken")
//         }
       
         UserDefaults.standard.set("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMzI4NzI1NjQyIiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MTAzNDIxMjV9.P6QY1YMDuKN357cFhcrHZrFahRtU8vwOaNZmx3ibBkY", forKey: "accessToken")
         
         UserDefaults.standard.set("eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MTI4NDc3MjV9.Dhz3k-0Ml54v7jhmeLJweydO7MXtxDMLeRJzYK-SZT0", forKey: "refreshToken")
        
        // 엑세스 토큰이 있는 경우
         if let accessToken = defaults.string(forKey: "accessToken"){
             
             viewModel.isLoginEnabled { isEnabled in
                 if isEnabled {
                     // 로그인 가능한 경우
                     print("로그인 가능합니다. - 현재 가지고 있는 엑세스 토큰이 유효함")
                     print(defaults.string(forKey: "accessToken"))
                     self.setupMainInterface()
                 } else {
                     // 로그인 불가능한 경우
                     print("로그인이 불가능합니다.- 엑세스 토큰을 가지고 있으나 기간 만료 (갱신 필요)")
                     if let refreshToken = defaults.string(forKey: "refreshToken"){
                         //리프레쉬 토큰이 있는 경우
                         print("리프레쉬 토큰 존재함")
                         print(defaults.string(forKey: "refreshToken"))
                         viewModel.refreshAccessTokenIfNeeded()
                     }
                 }
             }
         }else{
            window?.rootViewController = LoginViewController()
         }
    
         // UserDefaults를 사용하여 이전 로그인 여부 확인 및 자동 로그인 처리
         // 예시 코드로, 실제 앱에서는 로그인 상태를 관리하는 더 안전한 방법을 사용해야 합니다.
         let isLoggedIn = defaults.bool(forKey: "isLoggedIn")
         if isLoggedIn {
             print("로그인 상태입니다")
             if let refreshToken = defaults.string(forKey: "refreshToken"){
                 //리프레쉬 토큰이 있는 경우
                 let viewModel = LoginViewModel()
                 viewModel.refreshAccessTokenIfNeeded()

             }

             // 로그인 상태이면 메인 화면으로 이동
             setupMainInterface()
         } else {
             // 로그인 상태가 아니면 로그인 화면으로 이동
             print("로그인 상태가 아닙니다.")
             window?.rootViewController = LoginViewController()
         }
         window?.makeKeyAndVisible()
     }
     
     // 메인 인터페이스 설정
     func setupMainInterface() {
         let tabBarController = CustomTabBarController()
         tabBarController.tabBar.tintColor = .mpMainColor

         let homeVC = UINavigationController(rootViewController: HomeViewController())
         let goalVC = UINavigationController(rootViewController: GoalMainViewController())
         let consumeVC = UINavigationController(rootViewController: ConsumeViewController())
         let battleVC = UINavigationController(rootViewController: BattleViewController())
         let settingVC = UINavigationController(rootViewController: MyPageViewController())
         
         homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), tag: 0)
         goalVC.tabBarItem = UITabBarItem(title: "목표", image: UIImage(named: "btn_goal_on"), tag: 1)
         consumeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "btn_add_new")?.withRenderingMode(.alwaysOriginal), selectedImage: nil)
         battleVC.tabBarItem = UITabBarItem(title: "소비 배틀", image: UIImage(named: "btn_battle_on"), tag: 3)
         settingVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "btn_mypage_on"), tag: 4)

         tabBarController.viewControllers = [homeVC, goalVC, consumeVC, battleVC, settingVC]
         tabBarController.selectedIndex = 0 // 홈을 기본 선택 탭으로 설정

         window?.rootViewController = tabBarController
     }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // 애플 Id 확인
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let defaults = UserDefaults.standard
//        if let userID = defaults.string(forKey: "userIdentifier"){
//            appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
//                switch credentialState {
//                    case .authorized:
//                       print("authorized")
//                       // The Apple ID credential is valid.
//                       DispatchQueue.main.async {
//                         //authorized된 상태이므로 바로 로그인 완료 화면으로 이동
//                           self.setupMainInterface()
//                       }
//                    case .revoked:
//                       print("revoked")
//                    case .notFound:
//                       // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
//                       print("notFound")
//                           
//                    default:
//                        break
//                }
//            }
//            
//        }
//
//        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

