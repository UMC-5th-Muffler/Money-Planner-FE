//
//  GoalNameViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import UIKit

extension GoalNameViewController: WriteNameCellDelegate {
    
    func didChangeEmojiText(to newValue: String?, cell: WriteNameCell) {
        if let text = newValue, let emoji = String?(text) {
            goalCreationManager.goalEmoji = emoji
        } else {
            // Handle the case where the text is not an String or is nil
            goalCreationManager.goalEmoji = nil
        }
    }
    
    func didChangeTitleText(to newValue: String?, cell: WriteNameCell) {
        if let text = newValue, let name = String?(text) {
            goalCreationManager.goalName = name
        } else {
            // Handle the case where the text is not an integer or is nil
            goalCreationManager.goalName = nil
        }
    }
}

class GoalNameViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    private var header = HeaderView(title: "")
    private var descriptionView = DescriptionView(text: "목표 이름을 설정해주세요", alignToCenter: false)
    private var tableView: UITableView!
    private var btmbtn = MainBottomBtn(title: "다음")
    private var scrim = UIView()
    
    private let goalViewModel = GoalViewModel.shared //지금까지 만든 목표 확인용
    private let goalCreationManager = GoalCreationManager.shared //목표 생성용
    
    
    
    var btmbtnBottomConstraint: NSLayoutConstraint! //키보드 이동용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupDescriptionView()
        setUpBtmBtn()
        setupTableView()
        tableView.delegate = self // 이 코드 추가 안할시 delegate 함수 반영 안됨
        
        // 기본 네비게이션 바의 뒤로 가기 버튼 숨기기
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        
        btmbtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
        
        // 키보드 알림 구독
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func btmButtonTapped() {
        print("이름 입력 완료. 기간 화면으로.")
        let goalPeriodViewController = GoalPeriodViewController()
        navigationController?.pushViewController(goalPeriodViewController, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 첫 번째 row의 첫 번째 section을 지정
        let indexPath = IndexPath(row: 0, section: 0)
        
        // 해당 indexPath의 셀을 가져옴
        if let cell = tableView.cellForRow(at: indexPath) as? WriteNameCell {
            // 셀 내의 텍스트 필드에 포커스를 줌
//            cell.writeNameView.textField.becomeFirstResponder()
            cell.emojiView.textField.becomeFirstResponder()
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
        self.tabBarController?.tabBar.isHidden = false
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
    
    //navigation 말고 present
//    // Action when the backButton is tapped
//    @objc func backButtonTapped() {
//        // Dismiss the current view controller and go back to GoalMainViewController
//        self.dismiss(animated: true, completion: nil)
//    }
    
    private func setupTableView() {
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.register(WriteNameCell.self, forCellReuseIdentifier: "WriteNameCell")
        tableView.rowHeight = 200
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none  // 셀 사이 구분선 제거
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: btmbtn.topAnchor, constant: -20)
        ])
    }
    
    // UITableViewDataSource 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // 두 개의 셀
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WriteNameCell", for: indexPath) as! WriteNameCell
        return cell
    }
    
    // UITableViewDelegate 메서드
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {  // 두 번째 셀에 대한 높이 설정
            return 180
        } else {
            return 60  // 다른 셀에 대한 기본 높이
        }
    }
    
    func setUpBtmBtn(){
        btmbtn.translatesAutoresizingMaskIntoConstraints = false
//        btmbtn.isEnabled = false
        view.addSubview(btmbtn)
        
        btmbtnBottomConstraint = btmbtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        
        NSLayoutConstraint.activate([
            btmbtnBottomConstraint,
            btmbtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmbtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmbtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
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



