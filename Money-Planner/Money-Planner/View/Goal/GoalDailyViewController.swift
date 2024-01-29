//
//  GoalDailyViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/26/24.
//

import Foundation
import UIKit

class GoalDailyViewController : UIViewController {
    
    private let header = HeaderView(title: "")
    private let descriptionView = DescriptionView(text: "하루하루의 목표금액을\n조정해주세요", alignToCenter: false)
    private let subdescriptionView = SubDescriptionView(text: "일정에 맞게 일일 목표 금액을 변경하면\n나머지 금액은 1/n 해드릴게요", alignToCenter: false)
    let dailyEditCalendar = DailyEditCalendar()
    private let btmBtn = MainBottomBtn(title: "다음")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        
        header.addBackButtonTarget(target: self, action: #selector(backButtonTapped), for: .touchUpInside)
        btmBtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
    }
    
    private func setupViews() {
        // Add subviews to the view hierarchy
        view.addSubview(header)
        view.addSubview(descriptionView)
        view.addSubview(subdescriptionView)
        view.addSubview(dailyEditCalendar)
        view.addSubview(btmBtn)
    }
    
    private func setupConstraints() {
        // Disable autoresizing mask translation for all subviews
        header.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        subdescriptionView.translatesAutoresizingMaskIntoConstraints = false
        dailyEditCalendar.translatesAutoresizingMaskIntoConstraints = false
        btmBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints for all subviews
        NSLayoutConstraint.activate([
            // Header constraints
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60), // Adjust the height as needed
            
            // DescriptionView constraints
            descriptionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20),
            descriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // SubDescriptionView constraints
            subdescriptionView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 10),
            subdescriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            subdescriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            // DailyEditCalendar constraints
            dailyEditCalendar.topAnchor.constraint(equalTo: subdescriptionView.bottomAnchor, constant: 20),
            dailyEditCalendar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dailyEditCalendar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            dailyEditCalendar.bottomAnchor.constraint(equalTo: btmBtn.topAnchor, constant: -20),
            
            // btmButn contraints
            btmBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btmBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func backButtonTapped() {
        // 뒤로 가기 기능 구현
        navigationController?.popViewController(animated: true)
    }
    
    @objc func btmButtonTapped() {
        print("최종 확인 화면으로 이동")
        let goalFinalVC = GoalFinalViewController()
        navigationController?.pushViewController(goalFinalVC, animated: true)
    }
}

class DailyEditCalendar : UICalendarView {
    
}
