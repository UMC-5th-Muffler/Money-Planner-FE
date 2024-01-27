//
//  ToggleButton.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/22.
//

import Foundation

import UIKit

class CustomToggleButton: UIButton {
    let halfView : UIView = {
        let v = UIView()
        v.backgroundColor = .mpWhite
        v.layer.cornerRadius = 20
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var isRight: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.text = "달력"
        label.textColor = .mpBlack
        label.textAlignment = .center
        label.font = UIFont.mpFont14B()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.text = "소비"
        label.textColor = .mpBlack
        label.textAlignment = .center
        label.font = UIFont.mpFont14B()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateUI()
        addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        updateUI()
        addTarget(self, action: #selector(switchButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        backgroundColor = UIColor(hexCode: "E4E6EB")
        layer.cornerRadius = 23
        addSubview(halfView)
        addSubview(leftLabel)
        addSubview(rightLabel)
        
        
        NSLayoutConstraint.activate([
            halfView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            halfView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5, constant: -4),
            halfView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            halfView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            leftLabel.leadingAnchor.constraint(equalTo: halfView.leadingAnchor),
            leftLabel.topAnchor.constraint(equalTo: halfView.topAnchor),
            leftLabel.bottomAnchor.constraint(equalTo: halfView.bottomAnchor),
            leftLabel.heightAnchor.constraint(equalTo: halfView.heightAnchor ),
            leftLabel.widthAnchor.constraint(equalTo: halfView.widthAnchor ),
            
            rightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            rightLabel.topAnchor.constraint(equalTo: halfView.topAnchor),
            rightLabel.bottomAnchor.constraint(equalTo: halfView.bottomAnchor),
            rightLabel.heightAnchor.constraint(equalTo: halfView.heightAnchor ),
            rightLabel.widthAnchor.constraint(equalTo: halfView.widthAnchor ),
        ])
    }
    
    private func updateUI() {
        UIView.animate(withDuration: 0.3) {
            self.halfView.transform = self.isRight ? CGAffineTransform(translationX: self.halfView.frame.width, y: 0) : .identity
        }
    }
    
    @objc private func switchButtonTapped() {
        isRight.toggle()
    }
}
