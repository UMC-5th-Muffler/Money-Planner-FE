//
//  MainNoGoal.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/12.
//

import Foundation
import UIKit

class MainNoGoalView : UIView {
    
    let alertLabel1: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexCode: "#979797")
        label.font = UIFont.mpFont16M()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "해당 날짜에 생성된"
        return label
    }()
    
    let alertLabel2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexCode: "#979797")
        label.font = UIFont.mpFont16M()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "소비목표가 없어요"
        return label
    }()
    
    let makeGoalButton : UIButton = {
        let button = UIButton(type: .system)
        
        // UIButton의 속성 설정
        button.setTitle("새 목표 만들기", for: .normal)
        button.titleLabel?.font = UIFont.mpFont18B()
        button.backgroundColor = UIColor.mpMainColor
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 12
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // UIButton의 Action 설정
        makeGoalButton.addTarget(self, action: #selector(newGoalButtonTapped), for: .touchUpInside)
        backgroundColor = .clear
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func setupView(){
        addSubview(alertLabel1)
        addSubview(alertLabel2)
        addSubview(makeGoalButton)
        
        NSLayoutConstraint.activate([
            alertLabel1.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            alertLabel1.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertLabel1.heightAnchor.constraint(equalToConstant: 23),
            alertLabel2.topAnchor.constraint(equalTo: alertLabel1.bottomAnchor, constant: 2),
            alertLabel2.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertLabel2.heightAnchor.constraint(equalToConstant: 23),
            makeGoalButton.topAnchor.constraint(equalTo: alertLabel2.bottomAnchor, constant: 16),
            makeGoalButton.widthAnchor.constraint(equalToConstant: 157),
            makeGoalButton.heightAnchor.constraint(equalToConstant: 48),
            makeGoalButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

    }

    @objc func newGoalButtonTapped() {
           print("새 목표 만들기 버튼이 탭되었습니다.")
       }
}


