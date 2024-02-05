//
//  UnregisterTitleLabel.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/5/24.
//

import Foundation
import UIKit

class UnregisterTitleLabel: MPLabel {
    // 줄 바꿈 간격을 조절하기 위한 프로퍼티
    var lineSpacing: CGFloat = 8.0 {
        didSet {
            updateText()
        }
    }

    override var text: String? {
        didSet {
            updateText()
        }
    }

    // 텍스트 업데이트 및 줄 바꿈 간격 적용
    private func updateText() {
        guard let labelText = text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

        attributedText = attributedString
    }
}
