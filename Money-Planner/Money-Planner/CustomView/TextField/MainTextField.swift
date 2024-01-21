//
//  MainTextField.swift
//  Money-Planner
//
//  Created by 유철민 on 1/19/24.
//

import Foundation
import UIKit


class MainTextField: UITextField {
    // 초기화 메소드
    init(placeholder: String, iconName: String, keyboardType: UIKeyboardType = .default,frame:CGRect = .zero) {
        super.init(frame: frame)
        setupTextField(placeholder: placeholder, iconName: iconName,keyboardType: keyboardType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 소비등록 - 텍스트필드 By 그냥
    private func setupTextField(placeholder: String, iconName: String,  keyboardType: UIKeyboardType) {
        self.placeholder = placeholder
        // 라운드 설정
        layer.cornerRadius = 8
        layer.masksToBounds = true
        borderStyle = .none
        font = UIFont.mpFont20M()
        tintColor = UIColor.mpMainColor
        backgroundColor = .mpGypsumGray // 수정 - 근영/ 텍스트 필드 배경 색상 F6F6F6
        self.keyboardType = keyboardType
        
        
        // 텍스트 필드에 시스템 아이콘 이미지 추가
            let systemIconImageView = UIImageView(image: UIImage(named: iconName))
            systemIconImageView.tintColor = UIColor.mpMainColor// 시스템 아이콘 이미지 색상 설정
            //systemIconImageView.contentMode = .scaleAspectFit

            // 아이콘 이미지 크기와 여백 설정
            let iconSize: CGFloat = 25
            let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize, height: iconSize))
            iconContainerView.addSubview(systemIconImageView)

            systemIconImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                systemIconImageView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: 20),
                systemIconImageView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant:-16),
                systemIconImageView.topAnchor.constraint(equalTo: iconContainerView.topAnchor),
                systemIconImageView.bottomAnchor.constraint(equalTo: iconContainerView.bottomAnchor)
            ])

            leftView = iconContainerView
            leftViewMode = .always
        
    }
    
    
}
    


