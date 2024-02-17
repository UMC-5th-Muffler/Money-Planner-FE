//
//  CustomTabBarController.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/17.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        self.delegate = self // 소비등록 화면

    }

    // tabBar에 그림자 적용하기
    func setupStyle() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController is ConsumeViewController {
            
            // ConsumeViewController를 모달로 표시
            let consumeVC = ConsumeViewController()
            consumeVC.modalPresentationStyle = .overFullScreen
            //let navigationController = UINavigationController(rootViewController: consumeVC)
            tabBarController.present(consumeVC, animated: true, completion: nil)
        }
       }
}
