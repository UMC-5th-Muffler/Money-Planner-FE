//
//  ViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/5/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let globeImageView = UIImageView()
    private let firstButton = UIButton()
    private let secondButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .mpWhite
        
        // 뷰 설정
        setupGlobeImageView()
        setupButtons()
    }
    
    private func setupGlobeImageView() {
        globeImageView.image = UIImage(named: "globeImage") // "globeImage"는 이미지 이름
        globeImageView.backgroundColor = .mpMainColor
        globeImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(globeImageView)
        
        NSLayoutConstraint.activate([
            globeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            globeImageView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 182),
            globeImageView.widthAnchor.constraint(equalToConstant: 193),
            globeImageView.heightAnchor.constraint(equalToConstant: 193)
        ])
    }
    
    private func setupButtons() {
        setupButton(firstButton, title: "첫 번째 버튼")
        setupButton(secondButton, title: "두 번째 버튼")
        
        NSLayoutConstraint.activate([
            firstButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstButton.widthAnchor.constraint(equalToConstant: 332),
            firstButton.heightAnchor.constraint(equalToConstant: 50),
            
            secondButton.bottomAnchor.constraint(equalTo: firstButton.topAnchor, constant: -10),
            secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondButton.widthAnchor.constraint(equalToConstant: 332),
            secondButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .blue // 예시 색상
        button.layer.cornerRadius = 25 // 버튼의 높이의 절반으로 둥근 모서리 설정
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    //
    //    private func setupHeaderView() {
    //        view.addSubview(headerView)
    //        headerView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
    //            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    //            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    //            headerView.heightAnchor.constraint(equalToConstant: 60)
    //        ])
    //    }
    //
    //    private func setupDescriptionView() {
    //        view.addSubview(descriptionView)
    //        descriptionView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            descriptionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
    //            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
    //            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    //        ])
    //    }
    //
    //    private func setupSubDescriptionView() {
    //        view.addSubview(subDescriptionView)
    //        subDescriptionView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            subDescriptionView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 10),
    //            subDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
    //            subDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
    //        ])
    //    }
    //
    //
    //    private func setupCheckButton() {
    //        view.addSubview(checkButton)
    //        checkButton.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //            checkButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
    //            checkButton.widthAnchor.constraint(equalToConstant: 50),
    //            checkButton.heightAnchor.constraint(equalToConstant: 50)
    //        ])
    //    }
    //
    //    private func setupMainButton() {
    //        mainButton.isEnabled = false
    //        view.addSubview(mainButton)
    //        mainButton.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //            mainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
    //            mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
    //            mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
    //            mainButton.heightAnchor.constraint(equalToConstant: 50)
    //        ])
    //    }
    //
    //    private func setupSmallButtonView() {
    //        view.addSubview(smallButtonView)
    //        smallButtonView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            smallButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    //            smallButtonView.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -20),
    //            smallButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
    //            smallButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
    //            smallButtonView.heightAnchor.constraint(equalToConstant: 50)
    //        ])
    //
    //        smallButtonView.addCancelAction(target: self, action: #selector(cancelButtonTapped))
    //        smallButtonView.addCompleteAction(target: self, action: #selector(completeButtonTapped))
    //    }
    //
    //    @objc private func cancelButtonTapped() {
    //        print("취소 버튼이 탭되었습니다.")
    //        // 취소 버튼 액션 처리
    //    }
    //
    //    @objc private func completeButtonTapped() {
    //        print("완료 버튼이 탭되었습니다.")
    //        // 완료 버튼 액션 처리
    //    }
}

