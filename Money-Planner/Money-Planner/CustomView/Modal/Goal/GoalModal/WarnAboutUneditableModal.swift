//
//  WarnAboutUneditableModal.swift
//  Money-Planner
//
//  Created by 유철민 on 2/7/24.
//

import Foundation
import UIKit
import FSCalendar

protocol WarnAboutUneditableModalDelegate: AnyObject {
    func modalDismissed()
}

class WarnAboutUneditableModal : UIViewController {
    
    weak var delegate: WarnAboutUneditableModalDelegate?
    
    let customModal : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .mpWhite
        uiView.layer.cornerRadius = 28
        return uiView
    }()
    let grabber : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .mpLightGray
        uiView.layer.cornerRadius = 4
        return uiView
    }()
    let titleLabel : MPLabel = {
        let label = MPLabel()
        label.text = "전체 목표 금액과 기간은\n나중에 수정할 수 없어요!"
        label.textColor = .mpBlack
        label.font = .mpFont20B()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    let subtitleLabel : MPLabel = {
        let label = MPLabel()
        label.text = "소비 목표를 확정하시겠어요?"
        label.textColor = .mpBlack
        label.font = .mpFont14M()
        label.numberOfLines = 0
        return label
    }()
    let goalBudgetTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "목표 금액"
        label.font = .mpFont16B()
        return label
    }()
    let goalDurationTitleLabel : UILabel = {
        let label = UILabel()
        label.text = "목표 기간"
        label.font = .mpFont16B()
        return label
    }()
    let goalBudgetLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .mpFont16M()
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        let calendar = Calendar.current

        // GoalCreationManager에서 startDate와 endDate 가져오기
        let startDate = GoalCreationManager.shared.startDate?.toMPDate() ?? Date()
        let endDate = GoalCreationManager.shared.endDate?.toMPDate() ?? Date()

        // startDate와 endDate 사이의 일수 계산
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        if let day = components.day {
            // 일수를 주 단위로 변환하여 표시할지, 일 단위로 그대로 표시할지 결정
            label.text = day % 7 == 0 ? "\(day / 7)주" : "\(day)일"
        } else {
            // components.day가 nil인 경우의 기본값 처리
            label.text = "기간 계산 불가"
        }
        
        label.textAlignment = .center
        label.font = .mpFont16M() 
        return label
    }()

    
    let dateRangeLabel: UILabel = {
        let label = UILabel()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        label.text = GoalCreationManager.shared.startDate! + " - " + GoalCreationManager.shared.endDate!
        label.textAlignment = .center
        label.font = .mpFont14M()
        label.textColor = .mpDarkGray
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.backgroundColor = .mpWhite
        button.setTitleColor(.mpMainColor, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.mpMainColor.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.backgroundColor = .mpMainColor
        button.setTitleColor(.mpWhite, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    let stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        goalBudgetLabel.text = formatAmount(GoalCreationManager.shared.goalBudget!)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
        setupLayout()
        setupPanGesture()
        setupActions()
    }
    
    private func setupLayout() {
        
        view.addSubview(customModal)
        customModal.translatesAutoresizingMaskIntoConstraints = false
        
        [grabber, titleLabel, subtitleLabel, stackView, cancelButton, acceptButton].forEach {
            customModal.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Create horizontal stack views for the grouped labels
        let amountStackView = UIStackView(arrangedSubviews: [goalBudgetTitleLabel, goalBudgetLabel])
        amountStackView.axis = .horizontal
        amountStackView.distribution = .equalSpacing
//        amountStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let durationStackView = UIStackView(arrangedSubviews: [goalDurationTitleLabel, durationLabel])
        durationStackView.axis = .horizontal
        durationStackView.distribution = .equalSpacing
//        durationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        dateRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews to the main stack view
        stackView.addArrangedSubview(amountStackView)
        stackView.addArrangedSubview(durationStackView)
        stackView.addArrangedSubview(dateRangeLabel)
        
        // Align dateRangeLabel to the right
        dateRangeLabel.textAlignment = .right
        
        
        NSLayoutConstraint.activate([
            
            customModal.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            customModal.widthAnchor.constraint(equalToConstant: 280),
            customModal.heightAnchor.constraint(equalToConstant: 358),
            customModal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customModal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            grabber.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 12),
            grabber.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            grabber.widthAnchor.constraint(equalToConstant: 49),
            grabber.heightAnchor.constraint(equalToConstant: 4),
            
            titleLabel.topAnchor.constraint(equalTo: grabber.bottomAnchor, constant: 32),
            titleLabel.widthAnchor.constraint(equalToConstant: 284),
            titleLabel.heightAnchor.constraint(equalToConstant: 56),
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            subtitleLabel.widthAnchor.constraint(equalToConstant: 156),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 23),
            
            //
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            
            amountStackView.heightAnchor.constraint(equalToConstant: 22),
            durationStackView.heightAnchor.constraint(equalToConstant: 22),
            
            // Ensure the dateRangeLabel aligns to the right side of the stack view
            dateRangeLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            //
            cancelButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            cancelButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -24),
            cancelButton.widthAnchor.constraint(equalToConstant: 150),
            cancelButton.heightAnchor.constraint(equalToConstant: 56),
            
            acceptButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            acceptButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -24),
            acceptButton.widthAnchor.constraint(equalToConstant: 150),
            acceptButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true)
    }
    
    @objc private func acceptAction() {
        // Implement the accept action logic
        print("Accept and close modal")
        self.dismiss(animated: true) {
            self.delegate?.modalDismissed()
        }
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        grabber.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if translation.y > 0 { // Dismiss only on dragging down
            view.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        
        if gesture.state == .ended {
            let velocity = gesture.velocity(in: view)
            if velocity.y >= 1500 { // If the speed of dragging is high enough, dismiss
                self.dismiss(animated: true) {
//                    self.delegate?.modalDismissed()
                }
            } else {
                // Return to original position
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        }
    }
    
    private func formatAmount(_ number: Int64) -> String {
        if number == 0 { return "0원" }
        
        let thousand_billion = number / 1_0000_0000_0000
        let hundred_million = (number % 1_0000_0000_0000) / 1_0000_0000
        let ten_thousand = (number % 1_0000_0000) / 1_0000
        let thousand = (number % 1_0000) / 1000
        let remainder = number % 1000
        
        var result = ""
        if thousand_billion > 0 {result += "\(thousand_billion)조 "}
        if hundred_million > 0 { result += "\(hundred_million)억 " }
        if ten_thousand > 0 { result += "\(ten_thousand)만 " }
        if thousand > 0 { result += "\(thousand)천 " }
        if remainder > 0 || result.isEmpty { result += "\(remainder)" }
        
        return result + "원"
    }
}
