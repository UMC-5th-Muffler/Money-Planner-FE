//
//  SceneDelegate.swift
//  Money-Planner
//
//  Created by 유철민 on 1/5/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    //기존 storyboard 대신 진입점(rootViewController) 설정
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        ///userdefaults 안에서 이전 로그인 여부 파악하고 자동로그인.
        ///없으면 로그인 화면으로 이동
        let tabBarController = CustomTabBarController()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let consumeVC = UINavigationController(rootViewController: GoalMainViewController())
        let battleVC = UINavigationController(rootViewController: BattleViewController())
        let settingVC = UINavigationController(rootViewController: SettingsViewController())
        
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        
        // 아직 목표 페이지가 없어서 임으로 해두었습니다! 나중에 목표페이지 생기면 바꿔서 넣으면됩니다!
        consumeVC.tabBarItem = UITabBarItem(title: "목표", image: UIImage(systemName: "person"), tag: 1)
        battleVC.tabBarItem = UITabBarItem(title: "소비 배틀", image: UIImage(systemName: "person"), tag: 2)
        settingVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), tag: 3)
        
        tabBarController.setViewControllers([homeVC, consumeVC, battleVC, settingVC], animated: true)
        
//        window?.rootViewController = GoalMainViewController()
////        window?.rootViewController = GoalPeriodViewController()
//        window?.makeKeyAndVisible()
        
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
    
    
}

