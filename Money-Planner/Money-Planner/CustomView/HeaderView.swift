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
    private let titleLabel = MPLabel()
    
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
        titleLabel.font = UIFont.mpFont18B()
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











