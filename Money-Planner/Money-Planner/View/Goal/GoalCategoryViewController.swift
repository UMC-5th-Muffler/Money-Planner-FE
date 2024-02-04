//
//  GoalCategoryViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import UIKit

class GoalCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var header = HeaderView(title: "")
    var descriptionView = DescriptionView(text: "카테고리별 목표 금액을\n입력해주세요", alignToCenter: false)
    var progressBar = GoalProgressBar(goalAmt: 300000, usedAmt: 0) // 임시 값으로 초기화
    var verticalStack = UIStackView()
    var tableView : UITableView!
    var btmBtn = MainBottomBtn(title: "다음")
    var sumAmount : Int64 = 0
    var categoryCount = 2
    
    
    private let goalViewModel = GoalViewModel.shared // 지금까지 만든 목표 확인용
    private let goalCreationManager = GoalCreationManager.shared // 목표 생성용
//    private let categoryViewModel = CategoryViewModel.shared // 지금까지 만들어진 카테고리 확인용
//    private let categoryCreationManager = CategoryCreationManager.shared // 카테고리별 목표 생성용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupHeader()
        setupDescriptionView()
        setupStackView()
        setupBtmBtn()
        setupTableView()
        
        // 기본 네비게이션 바의 뒤로 가기 버튼 숨기기
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
    }
    
    // 여기서부터 setup 메서드들을 정의합니다.
    @objc func btmButtonTapped() {
        // Create and present GoalNameViewController
        print("일별 설정으로 넘어감")
        let goalDailyVC = GoalDailyViewController()
        navigationController?.pushViewController(goalDailyVC, animated: true)
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
    
    //스택 생성
    private func setupStackView() {
        // 레이블을 생성합니다.
        let usedAmountLabel = UILabel()
        usedAmountLabel.text = "0원 / \(String(goalCreationManager.goalAmount!))원" // 실제 데이터 바인딩 필요
        usedAmountLabel.font = UIFont.systemFont(ofSize: 14)
        
        let leftAmountLabel = UILabel()
        let leftAmount = goalCreationManager.goalAmount ?? 0 > sumAmount ? (goalCreationManager.goalAmount ?? 0) - sumAmount : 0 // 꼭 불러올 수 있도록!
        leftAmountLabel.text = "남은 금액 \(leftAmount)원"
        leftAmountLabel.font = .mpFont14B()
        
        // 가로 스택 뷰를 생성하고 레이블을 추가
        let horizontalStack = UIStackView(arrangedSubviews: [usedAmountLabel, leftAmountLabel])
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .equalSpacing
        horizontalStack.alignment = .center
        
        // 수직 스택 뷰를 생성하고 progressBar와 수평 스택 뷰를 추가
        verticalStack = UIStackView(arrangedSubviews: [progressBar, horizontalStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = 8
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(verticalStack)
        
        // 수직 스택 뷰에 대한 제약 조건을 설정합니다.
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // ProgressBar의 높이 제약 조건을 추가합니다.
        progressBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
    // setUpBtmBtn 메소드 구현
    private func setupBtmBtn() {
        btmBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btmBtn)
        btmBtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
        
        let guide = view.safeAreaLayoutGuide
        let bottomConstraint = btmBtn.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        bottomConstraint.isActive = true // 키보드에 의해 변경될 수 있는 제약 조건
        
        NSLayoutConstraint.activate([
            btmBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btmBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 키보드 알림 구독
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // 키보드가 나타날 때 호출되는 메소드
    @objc func keyboardWillShow(notification: NSNotification) {
        adjustForKeyboard(notification: notification, show: true)
    }
    
    // 키보드가 사라질 때 호출되는 메소드
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustForKeyboard(notification: notification, show: false)
    }
    
    // 키보드 나타남/사라짐에 따른 뷰 조정 메소드
    private func adjustForKeyboard(notification: NSNotification, show: Bool) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let adjustmentHeight = show ? -keyboardHeight : 0
        
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            UIView.animate(withDuration: animationDuration) {
                self.btmBtn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: adjustmentHeight).isActive = true
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped) // Use .grouped for section headers
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GoalCreateBtnCell.self, forCellReuseIdentifier: "GoalCreateBtnCell")
        tableView.register(GoalCategoryTableViewCell.self, forCellReuseIdentifier: "GoalCategoryTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100 // Give an estimated row height for better performance
        tableView.separatorStyle = .none  // Remove separator lines if not needed
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: verticalStack.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: btmBtn.topAnchor, constant: -20)
        ])
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Each section has one cell
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "카테고리 목표 \(section + 1)"
    }
        
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // 마지막 셀인지 확인하여 GoalCategoryTableViewCell 또는 GoalCreateBtnCell 반환
//        if indexPath.section == categoryViewModel.categories.count {
//            // GoalCreateBtnCell 생성 및 구성
//            let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCreateBtnCell", for: indexPath) as! GoalCreateBtnCell
//            // 셀 구성
//            return cell
//        } else {
//            // GoalCategoryTableViewCell 생성 및 구성
//            let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCategoryTableViewCell", for: indexPath) as! GoalCategoryTableViewCell
//            // 셀 구성, 예를 들어 cell.configure(with: categoryViewModel.categories[indexPath.section])
//            return cell
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == categoryCount - 1 {
            // 마지막 섹션에 GoalCreateBtnCell 배치
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCreateBtnCell", for: indexPath) as! GoalCreateBtnCell
            cell.onAddButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.categoryCount += 1
                // 마지막 섹션 바로 앞에 새로운 GoalCategoryTableViewCell 섹션 추가
                self.tableView.insertSections([self.categoryCount - 2], with: .automatic)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCategoryTableViewCell", for: indexPath) as! GoalCategoryTableViewCell
            cell.categoryTextChanged = { text in
                // 텍스트 변경 처리
                print("카테고리 텍스트 변경됨: \(text)")
            }
            cell.categoryButtonTapped = {
                // 버튼 탭 처리
                print("카테고리 선택 버튼 탭됨")
            }
            return cell
        }
    }

    
    // UITableViewDelegate 메서드 구현
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == categoryCount - 1 {
            return 64
        } else {
            return 130
        }
    }
    
}


