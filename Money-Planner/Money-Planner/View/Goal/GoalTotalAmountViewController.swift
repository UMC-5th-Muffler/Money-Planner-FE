//
//  GoalTotalAmountViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/17/24.
//

import Foundation
import UIKit

class GoalTotalAmountViewController : UIViewController, UITableViewDataSource {
    
    private var header : HeaderView = HeaderView(title: "목표 금액 설정")
    private var descriptionView : DescriptionView = DescriptionView(text: "도전할 목표 금액을 입력해주세요", alignToCenter: true)
    private var cashEmojiLabel = UILabel()
    private var tableView : UITableView!
    private lazy var btmbtn : MainBottomBtn = MainBottomBtn(title: "다음")
    
    private let goalViewModel = GoalViewModel.shared // 싱글턴용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupDescriptionView()
        setUpBtmBtn()
        setupCashEmojiLabel()
        setupTableView()
    }
    
    private func setupHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60) // 예시 높이값
        ])
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
    
    private func setupCashEmojiLabel(){
        cashEmojiLabel.translatesAutoresizingMaskIntoConstraints = false
        cashEmojiLabel.text = "💰"
        cashEmojiLabel.font = UIFont.systemFont(ofSize: 100, weight: .medium)
        view.addSubview(cashEmojiLabel)
        
        NSLayoutConstraint.activate([
            cashEmojiLabel.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            cashEmojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    
    private func setupTableView() {
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.register(MoneyAmountTextCell.self, forCellReuseIdentifier: "MoneyAmountTextCell")
        tableView.rowHeight = 60
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none  // 셀 사이 구분선 제거
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cashEmojiLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: btmbtn.topAnchor, constant: -20)
        ])
    }
    
    
    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyAmountTextCell", for: indexPath) as! MoneyAmountTextCell //Thread 1: signal SIGABRT
        // 셀 설정
        
        cell.configureCell(image: UIImage(systemName: "wonsign.square.fill"), placeholder: "목표 금액")
        
        return cell
    }
}
