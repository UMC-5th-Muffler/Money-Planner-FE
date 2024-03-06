//
//  LabelAndImageBtn.swift
//  Money-Planner
//
//  Created by 유철민 on 2/14/24.
//

import Foundation
import UIKit

class LabelAndImageBtn: UIButton {
    
    private var customImageView: UIImageView!
    private var imageHeight: CGFloat = 15
    private var imageWidth: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        // 커스텀 이미지 뷰 생성 및 설정
        customImageView = UIImageView()
        customImageView.tintColor = .mpCharcoal
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(customImageView)
        
        NSLayoutConstraint.activate([
            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customImageView.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 2), // 이미지 위치 조정
            customImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            customImageView.heightAnchor.constraint(equalToConstant: imageHeight)
        ])
    }
    
    // 이미지 설정 메소드 오버라이드
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        customImageView.image = image
        
    }
}
