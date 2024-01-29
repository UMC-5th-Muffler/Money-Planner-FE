//
//  MainBottomBtn.swift
//  Money-Planner
//
//  Created by 유철민 on 1/19/24.
//

import Foundation
import UIKit

//MainBottomButton
class MainBottomBtn: UIButton {
    // 초기화 메소드
    init(title: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            updateButtonStyle()
        }
    }
    
    
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        layer.cornerRadius = 10  // 둥근 모서리 설정
        titleLabel?.font = UIFont.systemFont(ofSize: 16)  // 폰트 크기 설정
        updateButtonStyle()
    }
    
    // 버튼 스타일 업데이트 메소드
    private func updateButtonStyle() {
        if isEnabled {
            backgroundColor = .mpMainColor
            setTitleColor(.mpWhite, for: .normal)
        } else {
            backgroundColor = .mpGypsumGray // 수정 - 근영/ 메인 버튼 색상 F6F6F6
            setTitleColor(.mpGray, for: .normal)
        }
    }
}


