//
//  SubDescriptionView.swift
//  Money-Planner
//
//  Created by 유철민 on 1/19/24.
//

import Foundation
import UIKit

//SubDescriptionView
class SubDescriptionView: MPLabel {
    // 초기화 메소드
    init(text: String, alignToCenter: Bool) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = alignToCenter ? .center : .left
        self.textColor = UIColor.mpGray
        self.font = UIFont.mpFont16M()
        self.numberOfLines = 0  // 여러 줄 표시 가능
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
