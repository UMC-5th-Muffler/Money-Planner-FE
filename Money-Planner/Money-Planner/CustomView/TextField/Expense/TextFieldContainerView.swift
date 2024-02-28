//
//  TexFieldContainerView.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/5/24.
//
// 소비등록 화면 - 카테고리, 달력 텍스트 필드 컨테이너 뷰 구현
import Foundation
import UIKit
class TextFieldContainerView : UIView {
    // 초기화 메소드
    init() {
        super.init(frame: .zero)
        setupContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupContainer(){
        self.backgroundColor = UIColor.mpGypsumGray
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false // Add this line
    }
    
    
}
    
