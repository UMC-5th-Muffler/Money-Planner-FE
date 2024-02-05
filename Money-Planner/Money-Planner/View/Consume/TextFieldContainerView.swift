//
//  TexFieldContainerView.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/5/24.
//

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
    
