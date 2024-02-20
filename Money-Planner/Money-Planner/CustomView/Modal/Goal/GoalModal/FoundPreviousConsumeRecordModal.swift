//
//  FoundPreviousConsumeRecordModal.swift
//  Money-Planner
//
//  Created by 유철민 on 2/7/24.
//

import Foundation
import UIKit

protocol FoundPreviousConsumeRecordModalDelegate: AnyObject {
    func modalGoToGoalAmountVC()
}

class FoundPreviousConsumeRecordModal : UIViewController {
    
    //초기화
    var startDate : Date
    var endDate : Date
    
    weak var delegate : FoundPreviousConsumeRecordModalDelegate?
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //구성
    // 사용자 인터페이스 구성 요소 정의
    let customModal : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .mpWhite
        uiView.layer.cornerRadius = 28
        return uiView
    }()
    let titleLabel : MPLabel = {
        let label = MPLabel()
        label.text = "삭제된 목표 속 소비내역이\n해당 날짜에 있어요"
        label.textColor = .mpBlack
        label.font = .mpFont20B()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let subtitleLabel : MPLabel = {
        let label = MPLabel()
        label.text = "목표 날짜에 포함되는\n소비내역을 복구할까요?"
        label.textColor = .mpBlack
        label.font = .mpFont16M()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let skipBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("괜찮아요", for: .normal)
        btn.titleLabel?.font = .mpFont18M()
        btn.setTitleColor(.mpMainColor, for: .normal)
        btn.layer.cornerRadius = 12
        btn.layer.borderColor = UIColor.mpMainColor.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    let acceptBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .mpMainColor
        btn.setTitle("복구할래요", for: .normal)
        btn.titleLabel?.font = .mpFont18M()
        btn.setTitleColor(.mpWhite, for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupLayout()
        setupActions()
    }
    
    //레이아웃
    func setupLayout(){
        
        view.addSubview(customModal)
        customModal.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, subtitleLabel, skipBtn, acceptBtn].forEach {
            customModal.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            customModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customModal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customModal.widthAnchor.constraint(equalToConstant: 322),
            customModal.heightAnchor.constraint(equalToConstant: 400),
            
            titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 36),
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
            
            skipBtn.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            skipBtn.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -20),
            skipBtn.widthAnchor.constraint(equalToConstant: 136),
            skipBtn.heightAnchor.constraint(equalToConstant: 56),
            
            acceptBtn.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
//            acceptBtn.trailingAnchor.constraint(greaterThanOrEqualTo: skipBtn.trailingAnchor, constant: 10),
            acceptBtn.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -20),
            acceptBtn.widthAnchor.constraint(equalToConstant: 136),
            acceptBtn.heightAnchor.constraint(equalToConstant: 56)
        ])

    }
    
    //버튼 액션
    private func setupActions() {
        skipBtn.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        acceptBtn.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
    }
    
    @objc private func skipAction() {
            self.dismiss(animated: true) {
            self.delegate?.modalGoToGoalAmountVC()
        }
    }
    
    @objc private func acceptAction() {
        restoreConsumeRecords(startDate: startDate, endDate: endDate)
        self.dismiss(animated: true) {
            self.delegate!.modalGoToGoalAmountVC()
        }
    }
    
    func restoreConsumeRecords(startDate: Date, endDate: Date) {
        // 여기에 startDate부터 endDate까지의 소비 기록을 복구하는 로직 구현
        print("복구 시작: \(startDate)부터 \(endDate)까지")
    }
}
