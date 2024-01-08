//
//  Components.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit

// HeaderView
class HeaderView: UIView {
    
    private let backButton = UIButton()
    private let titleLabel = UILabel()
    
    init(title: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupBackButton()
        setupTitleLabel(with: title)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //추후 색 변환 가능
    private func setupBackButton() {
        if let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal) {
            let darkGrayChevron = chevronImage.withTintColor(.mpGray)
            backButton.setImage(darkGrayChevron, for: .normal)
        }
        addSubview(backButton)
    }
    
    
    //나중에 action을 필요에 따라 설정한다.
    public func addBackButtonTarget(target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        backButton.addTarget(target, action: action, for: controlEvents)
    }
    
    //받은 제목에 맞춰서 title 수정
    private func setupTitleLabel(with title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    
    //headerView 내부 contraint
    private func setupConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}



//DescriptionView
class DescriptionView: UILabel {
    // 초기화 메소드
    init(text: String, alignToCenter: Bool) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = alignToCenter ? .center : .left
        self.font = UIFont.systemFont(ofSize: 22, weight: .bold)  // 크고 진한 글자
        self.numberOfLines = 0  // 여러 줄 표시 가능
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//SubDescriptionView
class SubDescriptionView: UILabel {
    // 초기화 메소드
    init(text: String, alignToCenter: Bool) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = alignToCenter ? .center : .left
        self.textColor = UIColor.mpGray
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)  // 보통 크기와 두께의 글자
        self.numberOfLines = 0  // 여러 줄 표시 가능
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//BottomButton
class BottomButton: UIButton {
    // 초기화 메소드
    init(title: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        backgroundColor = .darkGray  // 어두운 배경색 설정
        setTitleColor(.white, for: .normal)  // 흰색 글씨색 설정
        layer.cornerRadius = 10  // 둥근 모서리 설정
        titleLabel?.font = UIFont.systemFont(ofSize: 16)  // 폰트 크기 설정
    }
}

