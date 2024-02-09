//
//  GoalListModal.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/29.
//

import Foundation
import UIKit

protocol GoalListModalViewDelegate : AnyObject{
    func changeGoal(category : Category)
}

class GoalListModalViewController: UIViewController {
    weak var delegate: GoalListModalViewDelegate?
    
    let customModal = UIView(frame: CGRect(x: 0, y: 0, width: 361, height: 548))
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "조회할 목표를 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.mpFont20B()
        return label
    }()
    
    let addGoalLabel: UILabel = {
        let label = UILabel()
        label.text = "+  새로운 목표 추가하기"
        label.textAlignment = .center
        label.font = UIFont.mpFont16M()
        label.textColor = .mpGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        presentCustomModal()
        setupBackground()
        setuptitleLabel()
        setupView()
    }
    
    func presentCustomModal() {
        // Instantiate your custom modal view
        customModal.backgroundColor = UIColor.mpWhite
        view.addSubview(customModal)
        customModal.center = view.center
        
        customModal.frame.origin.y = view.frame.height - customModal.frame.height - 36
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    private func setupBackground() {
        customModal.backgroundColor = .mpWhite
        customModal.layer.cornerRadius = 25
        customModal.layer.masksToBounds = true
    }
    
    private func setuptitleLabel() {
        let modalBar = UIView()
        modalBar.layer.cornerRadius = 8
        modalBar.backgroundColor = .mpLightGray
        
        customModal.addSubview(modalBar)
        customModal.addSubview(titleLabel)
        modalBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            modalBar.widthAnchor.constraint(equalToConstant: 49),
            modalBar.heightAnchor.constraint(equalToConstant: 4),
            modalBar.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 12),
            modalBar.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: modalBar.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            ])
            
    }
    
    private func setupView() {
        customModal.addSubview(addGoalLabel)
        
        NSLayoutConstraint.activate([
            addGoalLabel.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -32),
            addGoalLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24)
        ])
    }
    
    @objc private func handleBackgroundTap() {
        // 모달을 닫는 로직을 구현합니다.
        dismiss(animated: true, completion: nil)
    }
}


extension GoalListModalViewController{
    func fetchData(){
        HomeRepository.shared.getGoalList{
            (result) in
            switch result{
            case .success(let data):
                // 아예 골이 없는 경우
                print("확인")
                print(data)
//                let goal : Goal? = data?.activeGoalResponse
//                let inactive : [CalendarInactive]? = data?.inactiveGoalsResponse
//
//                self.nowGoal = goal
//                self.inactiveGoal = inactive
//
//                DispatchQueue.main.async {
//                    self.reloadUI()
//                }
                
                
            case .failure(.failure(message: let message)):
                print(message)
            case .failure(.networkFail(let error)):
                print(error)
                print("networkFail in loginWithSocialAPI")
            }
        }
    }
}
