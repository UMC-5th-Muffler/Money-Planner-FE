//
//  ViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/5/24.
//

import UIKit


class LoginViewController: UIViewController {
    
    private lazy var headerView = HeaderView(title: "헤더 타이틀")
    private lazy var descriptionView = DescriptionView(text: "메인 설명", alignToCenter: true)
    private lazy var subDescriptionView = SubDescriptionView(text: "부가 설명", alignToCenter: false)
    private lazy var checkButton = CheckBtn()
    private lazy var mainButton = MainBottomBtn(title: "메인 버튼")
    private lazy var smallButtonView = SmallBtnView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mpWhite")
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground  // 또는 UIColor.mpWhite, 적절한 색상 설정
        
        setupHeaderView()
        setupDescriptionView()
        setupSubDescriptionView()
        setupCheckButton()
        setupMainButton()
        setupSmallButtonView()
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupDescriptionView() {
        view.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupSubDescriptionView() {
        view.addSubview(subDescriptionView)
        subDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subDescriptionView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 10),
            subDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
    private func setupCheckButton() {
        view.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            checkButton.widthAnchor.constraint(equalToConstant: 50),
            checkButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupMainButton() {
        mainButton.isEnabled = false
        view.addSubview(mainButton)
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupSmallButtonView() {
        view.addSubview(smallButtonView)
        smallButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            smallButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            smallButtonView.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -20),
            smallButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            smallButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            smallButtonView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        smallButtonView.addCancelAction(target: self, action: #selector(cancelButtonTapped))
        smallButtonView.addCompleteAction(target: self, action: #selector(completeButtonTapped))
    }
    
    @objc private func cancelButtonTapped() {
        print("취소 버튼이 탭되었습니다.")
        // 취소 버튼 액션 처리
    }
    
    @objc private func completeButtonTapped() {
        print("완료 버튼이 탭되었습니다.")
        // 완료 버튼 액션 처리
    }
}


