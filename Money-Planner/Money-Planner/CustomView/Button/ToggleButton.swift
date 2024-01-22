//
//  ToggleButton.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/22.
//

import Foundation

import UIKit

class ToggleButton: UIButton {
    
    // 토글 상태를 나타내는 프로퍼티
    var isToggled: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    // 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        layer.cornerRadius = 18
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 154),
            heightAnchor.constraint(equalToConstant: 46),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // UI 설정 메서드
    private func setupUI() {
        // 버튼 초기 설정
        setTitleColor(.white, for: .normal)
        setTitleColor(.blue, for: .selected)
        backgroundColor = .blue
        layer.cornerRadius = 8
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        // 초기 상태 설정
        isToggled = false
        updateUI()
    }
    
    // 버튼 탭 시 호출되는 메서드
    @objc private func buttonTapped() {
        isToggled.toggle() // 토글 상태 변경
        sendActions(for: .valueChanged) // 값이 변경되었음을 알림
    }
    
    // UI 갱신 메서드
    private func updateUI() {
        let duration: TimeInterval = 0.3
        
        UIView.animate(withDuration: duration) {
            self.backgroundColor = self.isToggled ? .blue : .lightGray
            self.setTitle(self.isToggled ? "ON" : "OFF", for: .normal)
        }
    }
}
