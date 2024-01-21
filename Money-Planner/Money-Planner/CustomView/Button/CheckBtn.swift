//
//  CheckBtn.swift
//  Money-Planner
//
//  Created by 유철민 on 1/19/24.
//

import Foundation
import UIKit


//check
class CheckBtn: UIButton {
    // 체크 상태 프로퍼티
    var isChecked: Bool = true {
        didSet {
            updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        updateImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 체크 상태 토글 메소드
    @objc private func toggleCheck() {
        isChecked = !isChecked
    }
    
    // 이미지 업데이트 메소드
    private func updateImage() {
        let systemName = "checkmark.circle.fill"
        let color = isChecked ? UIColor.mpMainColor : UIColor.mpGray
        setImage(UIImage(systemName: systemName)?.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    // 초기 상태 설정 메소드
    func setChecked(_ checked: Bool) {
        isChecked = checked
    }
}
