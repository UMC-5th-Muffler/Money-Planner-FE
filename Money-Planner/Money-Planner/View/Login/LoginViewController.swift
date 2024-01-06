//
//  ViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/5/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private lazy var headerView = HeaderView(title : "시험 페이지")
    private lazy var bottomButton = BottomButton(title: "버튼 텍스트")
    private lazy var descriptionView = DescriptionView(text: "메인 설명", alignToCenter: true)
    private lazy var subDescriptionView = SubDescriptionView(text: "부가 설명", alignToCenter: false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupHeaderView()
        setupViews()
        setupBottomButton()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60) // 고정된 높이
        ])
        
        headerView.addBackButtonTarget(target: self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        print("뒤로 가기 버튼이 탭되었습니다.")
        // 여기에 뒤로 가기 기능 구현 (예: self.navigationController?.popViewController(animated: true))
    }
    
    private func setupBottomButton() {
        view.addSubview(bottomButton)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),  // 하단 여백
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),  // 좌측 여백
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),  // 우측 여백
            bottomButton.heightAnchor.constraint(equalToConstant: 50)  // 고정된 높이
        ])
    }
    
    private func setupViews() {
        view.addSubview(descriptionView)
        view.addSubview(subDescriptionView)
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        subDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // DescriptionView 제약 조건
            descriptionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),  // 좌측 여백
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),  // 우측 여백
            
            // SubDescriptionView 제약 조건
            subDescriptionView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            subDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),  // 좌측 여백
            subDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)  // 우측 여백
        ])
    }
    
}

