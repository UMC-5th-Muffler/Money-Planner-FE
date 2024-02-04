//
//  SceneDelegate.swift
//  Money-Planner
//
//  Created by 유철민 on 1/5/24.
//

import UIKit
import RxSwift
import RxMoya
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var needsLogin : Bool = true // false로 나중에 수정
    
    //기존 storyboard 대신 진입점(rootViewController) 설정
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        //카카오 로그인 필요성 확인
        // Class member property
        let disposeBag = DisposeBag()
                            
        if (AuthApi.hasToken()) {
            UserApi.shared.rx.accessTokenInfo()
                .subscribe(onSuccess:{ (accessTokenInfo) in
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    print("accessTokenInfo() success.")
                    
                    //do something
                    
                    self.needsLogin = false
                    _ = accessTokenInfo
                    
                }, onFailure: {error in
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        self.needsLogin = true
                    }
                    else {
                        //기타 에러
                        print(error)
                    }
                })
                .disposed(by: disposeBag)
        }
        else {
            //로그인 필요
            self.needsLogin = true
        }
        
        // vc 제작
        
        if needsLogin {
            let loginVC = UINavigationController(rootViewController: LoginViewController())
            window?.rootViewController = loginVC
        }else{
            let tabBarController = CustomTabBarController()
            
            let homeVC = UINavigationController(rootViewController: HomeViewController())
            let goalVC = UINavigationController(rootViewController: GoalMainViewController())
            let battleVC = UINavigationController(rootViewController: BattleViewController())
            let settingVC = UINavigationController(rootViewController: SettingsViewController())
            
            
            homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
            goalVC.tabBarItem = UITabBarItem(title: "목표", image: UIImage(systemName: "list.clipboard"), tag: 1)
            battleVC.tabBarItem = UITabBarItem(title: "소비 배틀", image: UIImage(systemName: "person"), tag: 2)
            settingVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), tag: 3)
            
            tabBarController.setViewControllers([homeVC, goalVC, battleVC, settingVC], animated: true)
            
            window?.rootViewController = tabBarController
        }
        
        window?.makeKeyAndVisible()
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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
    
    //kakao 권한용
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
    
    
}

