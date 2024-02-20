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
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            // consumeVC가 선택되었는지 확인
            if viewController is UINavigationController && (viewController as! UINavigationController).viewControllers.first is ConsumeViewController {
                
                let vc = WhichAddModalViewController()
                vc.delegate = self
                self.present(vc, animated: true)
                return false
            }
            
            // 다른 탭은 정상적으로 선택되게 합니다.
            return true
        }
}

extension CustomTabBarController : WhichAddModalDelegate{
    func moveToView(index: Int) {
        if(index == 0){
            // 여기에서 모달 뷰 컨트롤러를 초기화하고 표시합니다.
            let vc = ConsumeViewController() // 모달로 띄울 새로운 뷰 컨트롤러 인스턴스
            vc.modalPresentationStyle = .fullScreen // 또는 적절한 프레젠테이션 스타일
            self.present(vc, animated: true, completion: nil)

        }else{
            let currentDate = Date().toString()
            let vc = EvaluationViewController()
            vc.dateText = currentDate
            vc.isThroughFloatButton = true
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)

        }
    }
    
    
}
