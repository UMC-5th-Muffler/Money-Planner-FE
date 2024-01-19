//
//  MPLabel.swift
//  Money-Planner
//
//  Created by 유철민 on 1/19/24.
//

import Foundation
import UIKit

// CustomLabel (letter spacing -2%)
class MPLabel: UILabel {
    override var text: String? {
        didSet {
            updateTextSpacing()
        }
    }
    
    // 문자 간격 업데이트 메소드
    private func updateTextSpacing() {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let letterSpacing = -0.02 * self.font.pointSize // 글자 크기의 -2%
        attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
    
    /// 사용방법
    /// let label = MPLabel()
    /// label.font = UIFont.systemFont(ofSize: 16)
    /// label.text = "커스텀 레이블 테스트"
}
