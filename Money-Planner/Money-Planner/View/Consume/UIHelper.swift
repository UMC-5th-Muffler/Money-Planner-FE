//
//  UIHelper.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/6/24.
//

import Foundation
import UIKit

class UIHelper {
    
    // UIButton 설정을 위한 메서드
    static func configureButton(_ button: UIButton, title: String, titleColor: UIColor, backgroundColor: UIColor, cornerRadius: CGFloat) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
    }
    
    // UILabel 설정을 위한 메서드
    static func configureLabel(_ label: UILabel, text: String, font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment) {
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
    }
}
