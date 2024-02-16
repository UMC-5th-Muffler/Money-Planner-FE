//
//  GoalTotalAmountViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/17/24.
//

import Foundation
import UIKit


extension GoalTotalAmountViewController: MoneyAmountTextCellDelegate {
    func didChangeAmountText(to newValue: String?, cell: MoneyAmountTextCell, oldValue: String?) {
        // 쉼표를 제거하고 숫자로 변환
        if let text = newValue?.replacingOccurrences(of: ",", with: ""),
           let amount = Int64(text), amount > 0 {
            goalCreationManager.goalBudget = amount
            btmbtn.isEnabled = true
        } else {
            goalCreationManager.goalBudget = nil
            btmbtn.isEnabled = false
        }
    }
}

extension GoalTotalAmountViewController: WarnAboutUneditableModalDelegate {
    func modalDismissed() {
        goToGoalCategoryVC()
    }
}

class GoalTotalAmountViewController : UIViewController, UITableViewDataSource {
    
    private var header : HeaderView = HeaderView(title: "")
    private var descriptionView : DescriptionView = DescriptionView(text: "도전할 소비 목표의 금액을 입력해주세요", alignToCenter: false)
    private var tableView : UITableView!
    private lazy var btmbtn : MainBottomBtn = MainBottomBtn(title: "다음")
    
    private let goalViewModel = GoalViewModel.shared
    private let goalCreationManager = GoalCreationManager.shared //목표 생성용
    
    var btmbtnBottomConstraint: NSLayoutConstraint!//키보드 이동용
    
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
        btmbtn.isEnabled = false
        
        // 키보드 알림 구독
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func btmButtonTapped() {
        let modal = WarnAboutUneditableModal()
        modal.modalPresentationStyle = .popover
        modal.delegate = self
        self.present(modal, animated: true)
    }
    
    func goToGoalCategoryVC(){
        let goalCategoryViewController = GoalCategoryViewController()
        navigationController?.pushViewController(goalCategoryViewController, animated: true)
        // Extract the textField's text from the cell and convert it to an Int
        if let indexPath = tableView.indexPathForSelectedRow,
           let cell = tableView.cellForRow(at: indexPath) as? MoneyAmountTextCell,
           let text = cell.textField.text,
           let amount = Int64(text) {
            goalCreationManager.goalBudget = amount
        }
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
        
        btmbtnBottomConstraint = btmbtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        
        NSLayoutConstraint.activate([
            btmbtnBottomConstraint,
            btmbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmbtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmbtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func setupTableView() {
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.register(MoneyAmountTextCell.self, forCellReuseIdentifier: "MoneyAmountTextCell")
        tableView.rowHeight = 80
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
        cell.configureCell(image: UIImage(named: "icon_Wallet"), placeholder: "목표 금액")
        cell.delegate = self  // Set the viewController as the delegate
        return cell
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustButtonWithKeyboard(notification: notification, show: true)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustButtonWithKeyboard(notification: notification, show: false)
    }
    
    func adjustButtonWithKeyboard(notification: NSNotification, show: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let keyboardHeight = keyboardSize.height
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        
        // 키보드 상태에 따른 버튼의 bottom constraint 조정
        let bottomConstraintValue = show ? -keyboardHeight : -30  // -30은 키보드가 없을 때의 기본 간격입니다.
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.btmbtnBottomConstraint.constant = bottomConstraintValue
            self?.view.layoutIfNeeded()
        }
    }
    
    
}



