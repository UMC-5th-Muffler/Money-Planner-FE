//
//  SmallButton.swift
//  Money-Planner
//
//  Created by 유철민 on 1/19/24.
//

import Foundation
import UIKit

//smallButton 이 2개 있는 view. 주로 하단에 위치
class SmallBtnView: UIView {
    // 버튼 생성
    // 버튼 타이틀 변경을 위해서 private 해체함 - Park
    let cancelButton = UIButton()
    let completeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///사용하는 viewcontroller에서 viewdidload에서 반드시 넣어줄것!
    ///smallButtonView.addCancelAction(target: self, action: #selector(cancelButtonTapped))
    ///smallButtonView.addCompleteAction(target: self, action: #selector(completeButtonTapped))
    ///
    ///@objc func cancelButtonTapped() {
    ///print("취소 버튼이 탭되었습니다.")
    /// 취소 버튼 액션 처리
    ///}
    ///
    // 취소 버튼에 액션 추가 메소드
    func addCancelAction(target: Any?, action: Selector) {
        cancelButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // 완료 버튼에 액션 추가 메소드
    func addCompleteAction(target: Any?, action: Selector) {
        completeButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func setupButtons() {
        // 취소 버튼 설정
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(UIColor.mpMainColor, for: .normal)
        cancelButton.layer.borderColor = UIColor.mpMainColor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.backgroundColor = UIColor.mpWhite
        cancelButton.layer.cornerRadius = 10  // 적절한 둥글기 값 설정
        cancelButton.clipsToBounds = true
        
        // 완료 버튼 설정
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(UIColor.mpWhite, for: .normal)
        completeButton.backgroundColor = UIColor.mpMainColor
        completeButton.layer.cornerRadius = 10  // 적절한 둥글기 값 설정
        completeButton.clipsToBounds = true
        
        // 버튼을 뷰에 추가
        addSubview(cancelButton)
        addSubview(completeButton)
        
        // Auto Layout 설정
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 취소 버튼 제약 조건
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 완료 버튼 제약 조건
            completeButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 10), // 버튼 사이의 간격
            completeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            completeButton.topAnchor.constraint(equalTo: topAnchor),
            completeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // 두 버튼의 너비를 동일하게 설정
            cancelButton.widthAnchor.constraint(equalTo: completeButton.widthAnchor)
        ])
    }
}
