//
//  GoalDetailsViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 2/7/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxMoya
import Moya
import FSCalendar

extension GoalDetailsViewController {
    
    @objc func showModal() {
        let modal = ShowingPeriodSelectionModal(startDate: (goalDetail!.startDate.toDate) ?? Date(), endDate: (goalDetail!.endDate.toDate) ?? Date())
        modal.modalPresentationStyle = .popover
        modal.delegate = self
        present(modal, animated: true)
    }
    
    func configureSpendingAndReportViews() {
        
        expenseView.tapFilterBtn = { [weak self] in
            self?.showModal()
        }
        
        reportView.goal = goalDetail // Pass the goal to the report view
        reportView.tableView.reloadData()
        
        expenseView.translatesAutoresizingMaskIntoConstraints = false
        reportView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(expenseView)
        view.addSubview(reportView)
        
        // 이곳에서 expenseView와 reportView를 뷰에 추가하고 오토레이아웃을 설정하세요.
        NSLayoutConstraint.activate([
            expenseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expenseView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 1),
            expenseView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reportView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reportView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reportView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 1),
            reportView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension GoalDetailsViewController : PeriodSelectionDelegate {
    func periodSelectionDidSelectDates(startDate: Date, endDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        // 필터 버튼의 타이틀 업데이트
        expenseView.filterBtn.setTitle("\(startDateString) - \(endDateString)", for: .normal)
        print("보여지는 period 변경 실행")
    }
}

class GoalDetailsViewController : UIViewController {
    
    private let viewModel = GoalDetailViewModel.shared
    private let disposeBag = DisposeBag()
    
    let goalId : Int
    
    var goalDetail : GoalDetail?
    var goalReport : GoalReportResult?
    var goalExpense : WeeklyExpenseResult?
    
    private lazy var expenseView = ExpenseView()
    private lazy var reportView = ReportView()
    
    init(goalID: Int) {
        self.goalId = goalID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .mpWhite
//        setupNavigationBar()
//        setupLayout()
//        setupTabButtons()
//        setuplineViews()
//        configureViews()
//        configureSpendingAndReportViews()
//        selectButton(spendingButton) // Default selected button
//        
//        // ViewModel의 goalDetail 데이터를 관찰하고 UI 업데이트
//        viewModel.goalDetail.asObservable()
//            .compactMap { $0 }
//            .subscribe(onNext: { [weak self] detail in
//                // GoalDetail 데이터를 사용하여 UI 업데이트
//                // 예: self?.titleLabel.text = detail.title
//            }).disposed(by: disposeBag)
//        
//        // ViewModel의 goalExpenses 데이터를 관찰하고 UI 업데이트
//        viewModel.goalExpenses.asObservable()
//            .compactMap { $0 }
//            .subscribe(onNext: { [weak self] expenses in
//                // GoalExpenses 데이터를 사용하여 UI 업데이트
//                // 예: self?.updateExpenses(expenses)
//            }).disposed(by: disposeBag)
//        
//        // ViewModel의 CategoryTotalCost 데이터를 관찰하고 UI 업데이트
//        viewModel.goalReport.asObservable()
//            .compactMap { $0 }
//            .subscribe(onNext: { [weak self] goalReportResult in
//                self?.updateCategory(with: goalReportResult)
//            }).disposed(by: disposeBag)
//        
//        // ViewModel에서 GoalReport 데이터 가져오기
//        
//        viewModel.fetchGoalReport(goalId: goalId)
//        viewModel.fetchGoalDetail(goalId: goalId)
//        viewModel.fetchGoalExpenses(goalId: goalId, startDate: <#T##String#>, endDate: <#T##String#>, size: 10)
//        
//    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // ViewModel에서 GoalReport 데이터 가져오기
        viewModel.fetchGoalReport(goalId: goalId)
        viewModel.fetchGoalDetail(goalId: goalId)
        viewModel.fetchExpensesUsingGoalDetail(goalId: goalId, forceRefresh: true)
        // 초기 fetchGoalExpenses 호출은 제거하고, goalDetail 구독 결과에 따라 호출되도록 변경
        
        // ViewModel의 goalDetail 데이터를 관찰하고 UI 업데이트
        viewModel.goalDetail
            .subscribe(onNext: { [weak self] detail in
                // 여기서 goal 데이터를 사용하여 UI 업데이트
                print("상단 goal detail 받기 성공.")
                print("\(detail.icon) + \(detail.title)")
                self?.goalDetail = detail
                // GoalDetail에서 startDate와 endDate를 기반으로 Expenses 데이터 가져오기
                self?.configureViews()

            })
            .disposed(by: disposeBag)
        
        viewModel.goalReportRelay
            .subscribe(onNext: { [weak self] report in
                // report 데이터를 사용하여 UI 업데이트
                print(report)
            })
            .disposed(by: disposeBag)
        
        
        // 소비 내역 구독 설정
        viewModel.weeklyExpensesRelay
            .subscribe(onNext: { [weak self] weeklyExpenses in
                // 여기서 weeklyExpenses 데이터를 사용하여 UI 업데이트, 예를 들어 콘솔에 출력
                print("Weekly Expenses: \(weeklyExpenses)")
                // 추가적으로, 여기에서 테이블 뷰를 업데이트할 수도 있습니다.
                // self?.tableView.reloadData() // 예시: 테이블 뷰가 있다고 가정
            })
            .disposed(by: disposeBag)
        
        
        view.backgroundColor = .mpWhite
        setupNavigationBar()
        setupLayout()
        setupTabButtons()
        setuplineViews()
        selectButton(spendingButton) // Default selected button
        
        configureSpendingAndReportViews()
    }

    
    func updateCategory(with reports: GoalReportResult) {
        reportView.updateCategory(with: reports, goal: self.goalDetail!)
    }
    
    var header = HeaderView(title: "")
    //layer1
    let dday = DdayLabel()
    let spanNDuration : MPLabel = {
        let label = MPLabel()
        label.text = ""
        label.font = .mpFont14M()
        label.textColor = .mpGray
        return label
    }()
    let editBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "icon_Edit"), for: .normal)
        btn.tintColor = .mpGray
        return btn
    }()
    
    //layer2
    let label1 : MPLabel = {
        let label = MPLabel()
        label.text = "소비한 금액"
        label.font = .mpFont16M()
        label.textColor = .mpGray
        label.textAlignment = .left
        return label
    }()
    
    let label2 : MPLabel = {
        let label = MPLabel()
        label.textAlignment = .left
        return label
    }()
    
    
    func setupLayout(){
        
        view.addSubview(header)
        view.addSubview(dday)
        view.addSubview(spanNDuration)
        view.addSubview(editBtn)
        view.addSubview(label1)
        view.addSubview(label2)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        dday.translatesAutoresizingMaskIntoConstraints = false
        spanNDuration.translatesAutoresizingMaskIntoConstraints = false
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            header.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // dday 제약 조건
        NSLayoutConstraint.activate([
            dday.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 40),
            dday.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dday.widthAnchor.constraint(equalToConstant: 39)
        ])
        
        // spanNDuration 제약 조건
        NSLayoutConstraint.activate([
            spanNDuration.centerYAnchor.constraint(equalTo: dday.centerYAnchor),
            spanNDuration.leadingAnchor.constraint(equalTo: dday.trailingAnchor, constant: 10),
        ])
        
        // editBtn 제약 조건
        NSLayoutConstraint.activate([
            editBtn.centerYAnchor.constraint(equalTo: dday.centerYAnchor),
            editBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editBtn.widthAnchor.constraint(equalToConstant: 40),
            editBtn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // label1 제약 조건
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: dday.bottomAnchor, constant: 24),
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // label2 제약 조건
        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 5),
            label2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label2.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    //layer3 : button tab
    private let spendingButton = UIButton()
    private let reportButton = UIButton()
    private let underlineView = UIView()
    private let lineView = UIView()
    
    private var underlineViewLeadingConstraint: NSLayoutConstraint?
    
    private func setupTabButtons() {
        
        spendingButton.setTitle("소비내역", for: .normal)
        spendingButton.titleLabel!.font = .mpFont18B()
        reportButton.setTitle("분석 리포트", for: .normal)
        reportButton.titleLabel!.font = .mpFont18B()
        
        spendingButton.setTitleColor(.gray, for: .normal)
        reportButton.setTitleColor(.gray, for: .normal)
        
        spendingButton.setTitleColor(.black, for: .selected)
        reportButton.setTitleColor(.black, for: .selected)
        
        spendingButton.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
        
        spendingButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(spendingButton)
        view.addSubview(reportButton)
        
        NSLayoutConstraint.activate([
            spendingButton.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20),
            spendingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spendingButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            reportButton.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 20),
            reportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reportButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
    
    private func setuplineViews() {
        
        lineView.backgroundColor = .mpLightGray
        underlineView.backgroundColor = .mpBlack
        lineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineView)
        view.addSubview(underlineView)
        
        underlineViewLeadingConstraint = underlineView.centerXAnchor.constraint(equalTo: spendingButton.centerXAnchor)
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: spendingButton.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2),
            
            underlineViewLeadingConstraint!,
            underlineView.topAnchor.constraint(equalTo: spendingButton.bottomAnchor),
            underlineView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            underlineView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    @objc private func selectButton(_ sender: UIButton) {
        [spendingButton, reportButton].forEach { $0.isSelected = ($0 == sender) }
        
        // Animate underline view
        underlineViewLeadingConstraint?.isActive = false
        underlineViewLeadingConstraint = underlineView.centerXAnchor.constraint(equalTo: sender.centerXAnchor)
        underlineViewLeadingConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            if sender == self.spendingButton {
                self.expenseView.isHidden = false
                self.reportView.isHidden = true
            }else{
                self.expenseView.isHidden = true
                self.reportView.isHidden = false
            }
        }
    }
    
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    private func setComma(cash: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: cash)) ?? ""
    }
    
    func configureViews(){
        
//        let goalDetail = self.goalDetail!
        header.setupTitleLabel(with: goalDetail!.icon + " " + goalDetail!.title)
        header.addBackButtonTarget(target: self, action: #selector(backButtonTapped), for: .touchUpInside)
        //layer1
        //dday
        dday.configure(for: goalDetail!)
        
        let dateFormatter = DateFormatter()
        
        //spanDuration
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let startdatestr = goalDetail!.startDate
        
        let enddatestr : String
        if Calendar.current.dateComponents([.year], from: goalDetail!.startDate.toDate!) == Calendar.current.dateComponents([.year], from: goalDetail!.endDate.toDate!) {
            enddatestr = goalDetail!.endDate
        }else{
            dateFormatter.dateFormat = "MM.dd"
            enddatestr = dateFormatter.string(from: goalDetail!.endDate.toDate!)
        }
        
        if goalDetail!.startDate.toDate! < Date() && Date() < goalDetail!.endDate.toDate! {
            let day = Calendar.current.dateComponents([.day], from: goalDetail!.startDate.toDate!, to: Date()).day
            spanNDuration.text = startdatestr + " - " + enddatestr + " | " + "\(day ?? 0)" + "일차"
        }else{
            spanNDuration.text = startdatestr + " - " + enddatestr
        }
        
        //editBtn은 이미 위에 구현됨.
        
        //layer2
        //label1 이미 구현됨.
        //label2
        let totalCostString = setComma(cash: goalDetail!.totalCost)
        let goalBudgetString = " / \(setComma(cash: goalDetail!.totalBudget))원"
        
        let attributedString = NSMutableAttributedString(string: totalCostString, attributes: [
            .font: UIFont.mpFont26B(),
            .foregroundColor: UIColor.mpBlack
        ])
        
        attributedString.append(NSAttributedString(string: goalBudgetString, attributes: [
            .font: UIFont.mpFont16M(),
            .foregroundColor: UIColor.mpGray
        ]))
        
        label2.attributedText = attributedString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰 컨트롤러가 나타날 때 탭 바 숨김 처리
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 뷰 컨트롤러가 사라질 때 탭 바를 다시 표시
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupNavigationBar() {
        //        self.navigationController?.navigationBar.tintColor = .mpBlack
        //        self.navigationItem.title = goal.icon + " " + goal.goalTitle
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
