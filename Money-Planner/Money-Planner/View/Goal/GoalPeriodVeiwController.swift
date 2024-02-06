//
//  MakeGoalViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation
import UIKit
import Moya

//extension GoalPeriodViewController: PeriodSelectionDelegate {
//
//}

class GoalPeriodViewController : UIViewController, UINavigationControllerDelegate, PeriodSelectionDelegate {
    
    private var header : HeaderView = HeaderView(title: "")
    private var descriptionView : DescriptionView = DescriptionView(text: "도전할 소비 목표의 기간을 선택해주세요", alignToCenter: false)
    private lazy var periodBtn = PeriodButton()
    private lazy var btmbtn : MainBottomBtn = MainBottomBtn(title: "다음")
    
    private let goalViewModel = GoalViewModel.shared //지금까지 만든 목표 확인용
    private let goalCreationManager = GoalCreationManager.shared //목표 생성용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHeader()
        setupDescriptionView()
        setupPeriodBtn()
        setUpBtmBtn()
        
        btmbtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
        
        // 기본 네비게이션 바의 뒤로 가기 버튼 숨기기
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        
        btmbtn.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 숨기기
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func btmButtonTapped() {
        print("목표 금액 등록 화면으로 이동")
        let goalTotalAmountVC = GoalTotalAmountViewController()
        goalCreationManager.goalStart = periodBtn.startDate
        goalCreationManager.goalEnd = periodBtn.endDate
        navigationController?.pushViewController(goalTotalAmountVC, animated: true)
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
        goalCreationManager.goalStart = nil
        goalCreationManager.goalEnd = nil
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
    
    private func setupPeriodBtn(){
        periodBtn.translatesAutoresizingMaskIntoConstraints = false
        periodBtn.addTarget(self, action: #selector(periodBtnTapped), for: .touchUpInside)
        view.addSubview(periodBtn)
        NSLayoutConstraint.activate([
            periodBtn.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 30),
            periodBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            periodBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            periodBtn.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    @objc private func periodBtnTapped() {
        let startDateSelectionVC = StartDateSelectionViewController()
        startDateSelectionVC.delegate = self
        let navController = UINavigationController(rootViewController: startDateSelectionVC)
        navController.modalPresentationStyle = .popover // 혹은 .popover 등 적절한 스타일 선택
        self.present(navController, animated: true, completion: nil)
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
    
    func periodSelectionDidSelectDates(startDate: Date, endDate: Date) {
        periodBtn.setPeriod(startDate: startDate, endDate: endDate)
        btmbtn.isEnabled = true // btmBtn의 이름은 실제 버튼 변수명에 따라 달라질 수 있음
        print("변경 실행")
    }
    
}

class PeriodButton: UIButton {
    
    let iconImageView = UIImageView()
    let periodLabel = MPLabel()
    let spanLabel = MPLabel()
    let startDate = Date()
    let endDate = Date()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
        setupIconImageView()
        setupSpanLabelField()
        setupPeriodLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSelf(){
        self.backgroundColor = .mpGypsumGray
        self.layer.cornerRadius = 10
    }
    
    private func setupIconImageView() {
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(systemName: "calendar")
        iconImageView.tintColor = .mpGray
        self.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupPeriodLabel() {
        periodLabel.translatesAutoresizingMaskIntoConstraints = false
        periodLabel.text = "목표 기간 설정하기"
        self.addSubview(periodLabel)
        
        periodLabel.textColor = UIColor.mpGray
        periodLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            periodLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            periodLabel.trailingAnchor.constraint(equalTo: spanLabel.trailingAnchor, constant: -20),
            periodLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            periodLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupSpanLabelField() {
        spanLabel.translatesAutoresizingMaskIntoConstraints = false
        spanLabel.text = ""
        self.addSubview(spanLabel)
        
        spanLabel.textColor = .mpMainColor
        
        NSLayoutConstraint.activate([
            spanLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            spanLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            spanLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            spanLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    func setPeriod(startDate: Date, endDate: Date) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        periodLabel.text = "\(startDateString) - \(endDateString)"
        periodLabel.textColor = .mpBlack
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        if let day = components.day {
            spanLabel.text = day%7==0 ? "\(day/7)주" : "\(day)일"
        }
    }
}
