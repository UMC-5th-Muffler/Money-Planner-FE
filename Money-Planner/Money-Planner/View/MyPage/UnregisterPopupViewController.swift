//
//  UnregisterPopupViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/8/24.
//

import Foundation
import UIKit
protocol UnregisterPopupViewDelegate : AnyObject{
    func UnregisterpopupChecked()
    
}

class UnregisterPopupViewController: UIViewController {
    weak var delegate: UnregisterPopupViewDelegate?

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
        label.text = "정말 탈퇴하시겠습니까?"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var contentLabel : UILabel = {
        let label = UILabel()
        label.text = "그 동안의 소비 기록이 모두 사라져요."
        label.textAlignment = .left
        label.font = UIFont.mpFont16M()
        label.textColor  = .mpBlack
        // 여러줄 허용
        label.numberOfLines = 0 // 0으로 설정하면 자동으로 여러 줄 허용
        label.lineBreakMode = .byWordWrapping // 줄 바꿈 방식 설정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 탈퇴 취소 및 선택 버튼들
    lazy var buttons = SmallBtnView()

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
        customModal.addSubview(buttons)
        buttons.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttons.bottomAnchor.constraint(equalTo: customModal.bottomAnchor,constant: -20),
            buttons.heightAnchor.constraint(equalToConstant: 56),
            buttons.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            buttons.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
        ])
        
        buttons.cancelButton.setTitle("탈퇴하기", for: .normal)
        buttons.completeButton.setTitle("돌아가기", for: .normal)

        buttons.cancelButton.addTarget(self, action: #selector(popupUnregister), for: .touchUpInside)
        buttons.completeButton.addTarget(self, action: #selector(popupDismiss), for: .touchUpInside)
        
    }
    // 돌아가기 클릭 시 함수
    @objc
    func popupDismiss(){
        dismiss(animated: true)
    }
    // 탈퇴하기 클릭 시 함수
    @objc
    func popupUnregister(){
        dismiss(animated: true)
        delegate?.UnregisterpopupChecked()
    }
}
