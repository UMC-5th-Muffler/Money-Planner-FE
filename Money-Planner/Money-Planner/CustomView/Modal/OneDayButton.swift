//
//  OneDayButton.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/28/24.
//

import Foundation
import UIKit


class OneDayButton: UIButton {
    var checked = true
    var button = true
    // 초기화 메소드
    init(title: String, buttonBool: Bool, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupButton(title: title)
        button = buttonBool

        if button == true {
            print("log1")
            addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
        if button == false{
            print("log2")
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func changeTitel(title : String){
        setTitle(title, for: .normal)
    }
    
    private func setupButton(title: String) {
        setTitle(title, for: .normal)
        layer.cornerRadius = 6  // 둥근 모서리 설정
        titleLabel?.font = UIFont.mpFont14R()// 폰트 크기 설정
        backgroundColor = .mpLightGray
        setTitleColor(.mpDarkGray, for: .normal)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 38),
            heightAnchor.constraint(equalToConstant: 38)
        ])
       
    }
    
    
    // 버튼 탭 시 호출되는 메서드
    @objc private func buttonTapped() {
        if checked {
            checked = false
            //if is
            backgroundColor = .mpMainColor
            setTitleColor(.mpWhite, for: .normal)
            print("요일 선택 : 클릭 \(String(describing: currentTitle))")
            
        }else{
            checked = true
            //if is
            backgroundColor = .mpLightGray
            setTitleColor(.mpDarkGray, for: .normal)
            print("요일 선택 : 클릭 취소")
        }
        
    }
    
   
}



