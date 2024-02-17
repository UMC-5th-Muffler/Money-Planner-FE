//
//  BattleViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BattleViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = MufflerViewModel()
    let titleLabel : MPLabel = {
        let label = MPLabel()
        label.text = "친구와 배틀하기"
        label.font = .mpFont20B()
        label.textColor = .mpBlack
        return label
    }()
    let contentLabel : UnregisterTitleLabel = {
        let label = UnregisterTitleLabel()
        label.font = .mpFont14R()
        label.textColor = .mpDarkGray
        label.lineSpacing = 2
        label.text = "배틀 기능은 아직 준비 중...\n조금만 기다려주세요!"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mpWhite
        setupTitle()
        setupContents()
        
       
//
//        // 검색 버튼
//        let searchButton = UIButton(type: .system)
//        searchButton.setTitle("검색", for: .normal)
//        searchButton.backgroundColor = .mpGypsumGray
//        searchButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchButton)
//        searchButton.addTarget(self, action: #selector(alert), for: .touchUpInside)
//        let apiResultLabel = UILabel()
//        apiResultLabel.text = "API 결과 나옴"
//        apiResultLabel.numberOfLines = 0  // Set to 0 for multiple lines
//        apiResultLabel.lineBreakMode = .byWordWrapping  // or .byWordWrapping
//        apiResultLabel.translatesAutoresizingMaskIntoConstraints = false
//        apiResultLabel.textAlignment = .center
//        view.addSubview(apiResultLabel)
//        
//        // Add constraints for usernameTextField
//        NSLayoutConstraint.activate([
//            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
//            usernameTextField.widthAnchor.constraint(equalToConstant: 150),
//            usernameTextField.heightAnchor.constraint(equalToConstant: 40)
//        ])
//
//        // Add constraints for searchButton
//        NSLayoutConstraint.activate([
//            searchButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
//            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            searchButton.widthAnchor.constraint(equalToConstant: 100),
//            searchButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//        
//        NSLayoutConstraint.activate([
//            apiResultLabel.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: -5),
//            apiResultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            apiResultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            apiResultLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
//        ])
//        
//        viewModel.connect()
//            .subscribe(onNext: { repos in
//                // 네트워크 응답에 대한 처리
//                print("소비등록 성공!")
//                print(repos)
//                apiResultLabel.text = repos.message
//            }, onError: { error in
//                // 에러 처리
//                print("Error: \(error)")
//            })
//            .disposed(by: disposeBag)
    }
    private func setupTitle(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
    private func setupContents(){
        let container = UIView()
        container.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
    @objc private func alert() {
        let alertVCC = ExpensePopupModalView()
        // 완료한 이후 알람 띄우기
        let alarmTitle = "하루"
        let budget = 500
        let excessAmount = 500
        // 여기서 알람을 보여주는 작업을 수행합니다.
        
        if alarmTitle == "하루" {
            alertVCC.changeTitle(title: "하루 목표금액을 초과했어요")
            alertVCC.changeContents(content: "목표한 소비 금액 \(budget)원보다\n \(excessAmount)원 더 썼어요!")
        } else if alarmTitle == "카테고리" {
            let category = "식비"
            alertVCC.changeTitle(title: "\(category) 목표금액을 초과했어요")
            alertVCC.changeContents(content: "목표한 \(category) 금액 \(budget)원보다 \(excessAmount)원 더 썼어요!")
        } else if alarmTitle == "전체" {
            alertVCC.changeTitle(title: "전체 목표금액을 초과했어요")
            alertVCC.changeContents(content: "목표한 금액 \(budget)원보다 \(excessAmount)원 더 썼어요!")
        }
        
        // 모달을 화면에 표시
        present(alertVCC, animated: true, completion: nil)
    }

}

