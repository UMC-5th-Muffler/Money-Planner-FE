//
//  PopupViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/2/24.
//

import Foundation
import UIKit
protocol PopupViewDelegate : AnyObject{
    func popupChecked()
    
}

class PopupViewController: UIViewController {
    weak var delegate: PopupViewDelegate?

    let height : CGFloat = 200
    let customModal: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 28
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그아웃"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var contentLabel : UILabel = {
        let label = UILabel()
        label.text = "로그아웃이 완료되었습니다"
        label.textAlignment = .left
        label.font = UIFont.mpFont16M()
        label.textColor  = .mpBlack
        // 여러줄 허용
        label.numberOfLines = 0 // 0으로 설정하면 자동으로 여러 줄 허용
        label.lineBreakMode = .byWordWrapping // 줄 바꿈 방식 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 카테고리 선택 버튼 추가
    lazy var compleButton : UIButton = {
        let button = UIButton()
        
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.mpFont20M()
        button.setTitleColor(UIColor.mpWhite, for: .normal)
        button.backgroundColor = .mpMainColor
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  //클릭 활성화
        button.addTarget(self, action: #selector(popupDismiss), for: .touchUpInside) //클릭시 모달 띄우기
        return button
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        presentCustomModal()
        setuptitleLabel()
        setupContents()
        setupCompleteButton()
    }

    func presentCustomModal() {
        // Instantiate your custom modal view
        view.addSubview(customModal)
        NSLayoutConstraint.activate([
            customModal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            customModal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            customModal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customModal.heightAnchor.constraint(equalToConstant: height) // 높이 변경 가능
        ])
    }

 

    private func setuptitleLabel() {
        customModal.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20)
        ])
    }

    private func setupContents() {
        customModal.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            contentLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20)
        ])
    }
    private func setupCompleteButton(){
        customModal.addSubview(compleButton)
        compleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compleButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor,constant: -20),
            compleButton.heightAnchor.constraint(equalToConstant: 56),
            compleButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            compleButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
        ])
    }
    @objc
    func popupDismiss(){
        dismiss(animated: true)
        delegate?.popupChecked()
    }
}
