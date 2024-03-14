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

class GoalDetailsViewController: UIViewController, ExpenseViewDelegate {
    
    func didRequestToFetchMoreData() {
        viewModel.fetchNextPageIfPossible(goalId: String(goalId)){ [weak self] in
            DispatchQueue.main.async {
               print("추가 소비내역 업데이트 됨")
            }
        }
    }
    
    func navigateToDailyConsumeViewController(date: String, totalAmount: Int64) {
        let vc = DailyConsumeViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.dateText = date
        navigationController?.pushViewController(vc, animated: true)
    }
    
    var viewModel = GoalDetailViewModel.shared
    var disposeBag = DisposeBag()
    
    let goalId : Int
    
    var goalDetail : GoalDetail?
    var goalReport : GoalReportResult?
    var goalExpense : WeeklyExpenseResult?
    
    private var isFetchingMore = false
    
    private lazy var expenseView: ExpenseView = {
        let view = ExpenseView()
        view.delegate = self  // Delegate 연결
        return view
    }()
    
    private lazy var reportView = ReportView()
    
    init(goalID: Int) {
        self.goalId = goalID
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.goalId = 8//11, 12 4=>가장 많이 소비한 곳은 안뜸. 5=>카페/간식 데이터가 안옴.
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewModel.fetchGoal(goalId: String(goalId))
        viewModel.fetchGoalReport(goalId: String(goalId))
        viewModel.fetchExpensesUsingGoalDetail(goalId: String(goalId), forceRefresh: true)
        
        // GoalDetail 데이터 수신
        viewModel.goalRelay
            .subscribe(onNext: { [weak self] goalDetail in
                // reportView에 GoalDetail 데이터 전달 및 업데이트
                self?.reportView.updateCategoryGoalDetail(goal: goalDetail)
                self?.setupNavgationBarTitle(icon: goalDetail.icon, title: goalDetail.title)
                self?.goalDetail = goalDetail
                self?.configureViews(goalDetail: goalDetail)
                print(goalDetail)
            })
            .disposed(by: disposeBag)
        
        // GoalReport 데이터 수신
        viewModel.goalReportRelay
            .subscribe(onNext: { [weak self] report in
                // reportView에 GoalReport 데이터 전달 및 업데이트
                self?.reportView.updateCategoryReports(with: report)
                print(report)
            })
            .disposed(by: disposeBag)
        
        // WeeklyExpenses 데이터 수신
        viewModel.dailyExpenseListRelay
            .subscribe(onNext: { [weak self] dailyExpenseList in
                // reportView에 WeeklyExpenses 데이터 전달 및 업데이트
                self?.expenseView.update(with: dailyExpenseList)
            })
            .disposed(by: disposeBag)
        
        setupNavigationBar()
        setupLayout()
        setupTabButtons()
        setuplineViews()
        setupExpenseView()
        setupReportView()
        selectButton(spendingButton)
        
//        expenseView.tableView.delegate = self
    }
    
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
        btn.setImage(UIImage(named: "btn_Edit"), for: .normal)
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
        
        view.addSubview(dday)
        view.addSubview(spanNDuration)
        view.addSubview(editBtn)
        view.addSubview(label1)
        view.addSubview(label2)
        
        dday.translatesAutoresizingMaskIntoConstraints = false
        spanNDuration.translatesAutoresizingMaskIntoConstraints = false
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        
        // dday 제약 조건
        NSLayoutConstraint.activate([
            dday.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
    
    private func setComma(cash: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: cash)) ?? ""
    }
    
    func configureViews(goalDetail : GoalDetail){
        //layer1
        //dday
        dday.configure(for: goalDetail)
        
        let dateFormatter = DateFormatter()
        
        //spanDuration
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let startdatestr = dateFormatter.string(from: goalDetail.startDate.toDate!)
        
        let enddatestr : String
        if Calendar.current.dateComponents([.year], from: goalDetail.startDate.toDate!) == Calendar.current.dateComponents([.year], from: goalDetail.endDate.toDate!) {
            enddatestr = dateFormatter.string(from: goalDetail.endDate.toDate!)
        }else{
            dateFormatter.dateFormat = "MM.dd"
            enddatestr = dateFormatter.string(from: goalDetail.endDate.toDate!)
        }
        
        if goalDetail.startDate.toDate! <= Date.todayAtMidnight && Date.todayAtMidnight <= goalDetail.endDate.toDate! {
            let day = Calendar.current.dateComponents([.day], from: goalDetail.startDate.toDate!, to: Date.todayAtMidnight).day! + 1
            spanNDuration.text = startdatestr + " - " + enddatestr + " | " + "\(day)" + "일차"
        }else{
            spanNDuration.text = startdatestr + " - " + enddatestr
        }
        
        //editBtn은 이미 위에 구현됨.
        
        //layer2
        //label1 이미 구현됨.
        //label2
        let totalCostString = setComma(cash: goalDetail.totalCost)
        let goalBudgetString = " / \(setComma(cash: goalDetail.totalBudget))원"
        
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
    
    private func setupExpenseView() {
        view.addSubview(expenseView)
        expenseView.translatesAutoresizingMaskIntoConstraints = false
        configureExpenseViews()
        NSLayoutConstraint.activate([
            expenseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expenseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expenseView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 1),
            expenseView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupReportView() {
        view.addSubview(reportView)
        reportView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reportView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reportView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reportView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 1),
            reportView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //navigation 설정
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonTapped))
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .medium)
        backButton.image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backButton.tintColor = .mpBlack
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupNavgationBarTitle(icon : String, title : String){
        let titleLabel = UILabel()
        
        // 아이콘과 타이틀을 결합한 문자열 생성
        let fullTitle = icon + " " + title
        
        // NSAttributedString을 사용하여 타이틀 문자열에 스타일 적용
        let attributedText = NSMutableAttributedString(string: fullTitle, attributes: [
            .font: UIFont.mpFont18B(),
            .foregroundColor: UIColor.mpBlack // 텍스트 색상 설정
        ])
        
        // 아이콘에 대한 스타일 지정 (예시: 아이콘만 볼드체로 표시하고 싶은 경우)
        if let iconRange = fullTitle.range(of: icon) {
            attributedText.addAttributes([
                .font: UIFont.boldSystemFont(ofSize: 18) // 아이콘에 대한 커스텀 폰트 설정
            ], range: NSRange(iconRange, in: fullTitle))
        }
        
        // NSAttributedString을 UILabel에 할당
        titleLabel.attributedText = attributedText
        
        // 타이틀 뷰로 설정
        navigationItem.titleView = titleLabel
        
        // 타이틀 뷰의 크기 조정이 필요한 경우
        titleLabel.sizeToFit()
    }
    
}


extension GoalDetailsViewController {
    
    @objc func showModal() {
        let modal = ShowingPeriodSelectionModal(startDate: (goalDetail!.startDate.toDate) ?? Date(), endDate: (goalDetail!.endDate.toDate) ?? Date())
        modal.modalPresentationStyle = .popover
        modal.delegate = self
        present(modal, animated: true)
    }
    
    func configureExpenseViews() {
        expenseView.tapFilterBtn = { [weak self] in
            self?.showModal()
        }
    }
}


extension GoalDetailsViewController: PeriodSelectionDelegate {
    func periodSelectionDidSelectDates(startDate: Date, endDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        // viewModel 선택 날짜로 갱신 with completion
        viewModel.fetchBySelectedDates(goalId: String(goalId), startDate: startDateString, endDate: endDateString, forceRefresh: true) { [weak self] in
            DispatchQueue.main.async {
                // Ensure UI updates are on the main thread
                if startDateString == self?.goalDetail?.startDate && endDateString == self?.goalDetail?.endDate {
                    self?.expenseView.filterBtn.setTitle("전체 기간 조회", for: .normal)
                } else {
                    // Update the button title to reflect the selected period
                    formatter.dateFormat = "yyyy.MM.dd"
                    let formattedStartDate = formatter.string(from: startDate)
                    let formattedEndDate = formatter.string(from: endDate)
                    self?.expenseView.filterBtn.setTitle("\(formattedStartDate) - \(formattedEndDate)", for: .normal)
                }
            }
        }
        
        print("보여지는 period 변경 실행")
    }
}



