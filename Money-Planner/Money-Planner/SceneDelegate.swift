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
        let tabBarController = CustomTabBarController()
        tabBarController.tabBar.tintColor = .mpMainColor

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let goalVC = UINavigationController(rootViewController: EditGoalViewController())
        let consumeVC = UINavigationController(rootViewController: ConsumeViewController())
        let battleVC = UINavigationController(rootViewController: BattleViewController())
        let settingVC = UINavigationController(rootViewController: MyPageViewController())

        consumeVC.isNavigationBarHidden = false
        
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "btn_home_on"), tag: 0)
        goalVC.tabBarItem = UITabBarItem(title: "목표", image: UIImage(named: "btn_goal_on"), tag: 1)
        consumeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "btn_add_new")?.withRenderingMode(.alwaysOriginal), selectedImage: nil)
        consumeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0) // 아이콘을 중앙에 배치
        battleVC.tabBarItem = UITabBarItem(title: "소비 배틀", image: UIImage(named: "btn_battle_on"), tag: 3)
        settingVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "btn_mypage_on"), tag: 4)

        tabBarController.viewControllers = [homeVC, goalVC, consumeVC, battleVC, settingVC]
        tabBarController.selectedIndex = 2 // 중앙에 버튼이 추가될 컨트롤러의 인덱스

        window?.rootViewController = tabBarController
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
    
    
}

