//
//  GoalTotalAmountViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/17/24.
//

import Foundation
import UIKit


extension GoalTotalAmountViewController: MoneyAmountTextCellDelegate {
    func didChangeAmountText(to newValue: String?, cell: MoneyAmountTextCell) {
        // This is where you can validate and convert newValue to an Int and store it in goalCreationManager
        if let text = newValue, let amount = Int(text) {
            goalCreationManager.goalAmount = amount
        } else {
            // Handle the case where the text is not an integer or is nil
            goalCreationManager.goalAmount = nil
        }
    }
}


class GoalTotalAmountViewController : UIViewController, UITableViewDataSource {
    
    private var header : HeaderView = HeaderView(title: "")
    private var descriptionView : DescriptionView = DescriptionView(text: "도전할 소비 목표의 금액을 입력해주세요", alignToCenter: false)
    private var tableView : UITableView!
    private lazy var btmbtn : MainBottomBtn = MainBottomBtn(title: "다음")
    
    private let goalViewModel = GoalViewModel.shared
    private let goalCreationManager = GoalCreationManager.shared //목표 생성용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupDescriptionView()
        setUpBtmBtn()
        setupTableView()
        
        // 기본 네비게이션 바의 뒤로 가기 버튼 숨기기
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        
        btmbtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
    }

    
    @objc func btmButtonTapped() {
        // Extract the textField's text from the cell and convert it to an Int
        if let indexPath = tableView.indexPathForSelectedRow,
           let cell = tableView.cellForRow(at: indexPath) as? MoneyAmountTextCell,
           let text = cell.textField.text,
           let amount = Int(text) {
            goalCreationManager.goalAmount = amount
        }

        let goalCategoryViewController = GoalCategoryViewController()
        navigationController?.pushViewController(goalCategoryViewController, animated: true)
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
    
    private func setupTableView() {
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.register(MoneyAmountTextCell.self, forCellReuseIdentifier: "MoneyAmountTextCell")
        tableView.rowHeight = 60
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none  // 셀 사이 구분선 제거
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20), // cashEmojiLabel 대신 descriptionView.bottomAnchor 사용
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: btmbtn.topAnchor, constant: -20)
        ])
    }
    
    
    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyAmountTextCell", for: indexPath) as! MoneyAmountTextCell
        cell.configureCell(image: UIImage(systemName: "wonsign.square.fill"), placeholder: "목표 금액")
        cell.delegate = self  // Set the viewController as the delegate
        return cell
    }
    
    
    
}



