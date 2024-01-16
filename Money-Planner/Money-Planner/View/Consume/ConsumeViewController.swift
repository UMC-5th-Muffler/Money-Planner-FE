//
//  ConsumeViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 1/16/24.
//

import Foundation
import UIKit

class ConsumeViewController: UIViewController {

    private lazy var headerView = HeaderView(title: "소비내역 입력")
    private var completeButton = MainBottomBtn(title: "완료")

    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // 배경색상 추가
        view.backgroundColor = UIColor(named: "mpWhite")
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // > 이게 뭐죠
        
        
        // 헤더
        setupHeader()
        
        // 소비금액
        
        // 카테고리
        
        // 제목
        
        // 메모
        
        // 날짜
        
        // 반복
        
        // 완료 버튼 추가
        setupCompleteButton()

        
        // Auto Layout 설정
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    // 세팅 : 헤더
    private func setupHeader(){
        // HeaderView 추가
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        
    }
    // 세팅 : 완료 버튼
    private func setupCompleteButton(){
        completeButton.isEnabled = false
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}




