//
//  MakeGoalViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit
import Moya

class GoalPeriodViewController : UIViewController{
    
    private var header : HeaderView = HeaderView(title: "")
    private var descriptionView : DescriptionView = DescriptionView(text: "도전할 소비 목표의 기간을 선택해주세요", alignToCenter: false)
    private lazy var btmbtn : MainBottomBtn = MainBottomBtn(title: "다음")
    
    private let goalViewModel = GoalViewModel.shared //지금까지 만든 목표 확인용
    private let goalCreationManager = GoalCreationManager.shared //목표 생성용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupDescriptionView()
        setUpBtmBtn()
        
        btmbtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
        
        // 기본 네비게이션 바의 뒤로 가기 버튼 숨기기
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        
    }
    
    @objc func btmButtonTapped() {
        print("목표 금액 등록 화면으로 이동")
        let goalTotalAmountVC = GoalTotalAmountViewController()
        navigationController?.pushViewController(goalTotalAmountVC, animated: true)
    }
    
    private func setupHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        header.addBackButtonTarget(target: self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60) // 예시 높이값
        ])
    }
    
    @objc private func backButtonTapped() {
        // 뒤로 가기 기능 구현
        navigationController?.popViewController(animated: true)
    }
    
    private func setupDescriptionView() {
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionView)
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setUpBtmBtn(){
        btmbtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btmbtn)
        NSLayoutConstraint.activate([
            btmbtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btmbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmbtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmbtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
//    goalCreationManager.goalStart = Date() // 셀 안에서 받은 값을 반영할 수 있게 수정해야 함.
//    goalCreationManager.goalEnd = Date()
    
    
//    // UITableViewDelegate 메서드
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 1 {  // 두 번째 셀에 대한 높이 설정
//            return 180
//        } else {
//            return 60  // 다른 셀에 대한 기본 높이
//        }
//    }
}

class DefaultModalViewController : UIViewController{
    
}
