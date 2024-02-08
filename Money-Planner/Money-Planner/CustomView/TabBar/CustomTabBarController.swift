//
//  CustomTabBarController.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/17.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        setupMiddleButton()
    }

    // tabBar에 그림자 적용하기
    func setupStyle() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
    
    // 소비 등록 버튼 추가하기
    func setupMiddleButton() {
        let middleBtnSize: CGFloat = 60 // 버튼 크기
           let middleBtn = UIButton(frame: CGRect(x: (self.tabBar.bounds.width / 2) - (middleBtnSize / 2), y: -20, width: middleBtnSize, height: middleBtnSize)) // 버튼 위치 및 크기 설정
           middleBtn.setBackgroundImage(UIImage(named: "btn_add_now"), for: .normal) // 버튼 이미지 설정
           middleBtn.layer.cornerRadius = middleBtnSize / 2 // 버튼을 동그랗게 만듦
           middleBtn.layer.masksToBounds = true
           //middleBtn.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside) // 버튼에 액션 추가
           self.tabBar.addSubview(middleBtn)
           self.view.layoutIfNeeded()
       }
}
