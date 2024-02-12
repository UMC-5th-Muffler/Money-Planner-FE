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

extension GoalDetailsViewController : PeriodSelectionDelegate {
    func periodSelectionDidSelectDates(startDate: Date, endDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let startDateString = formatter.string(from: startDate)
        let endDateString = formatter.string(from: endDate)
        
        // 필터 버튼의 타이틀 업데이트
        spendingView.filterBtn.setTitle("\(startDateString) - \(endDateString)", for: .normal)
        print("보여지는 period 변경 실행")
    }
}

class GoalDetailsViewController : UIViewController {
    
    var goal : Goal
    
    private let spendingView = SpendingView()
    private let reportView = ReportView()
    
    init(goal: Goal) {
        //순서 미정의 된 변수, super init, 정의가 이제 된 변수를 바탕으로 한 개변
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mpWhite
        setupNavigationBar()
        setupLayout()
        setupTabButtons()
        setuplineViews()
        configureViews()
        configureSpendingAndReportViews()
        selectButton(spendingButton) // Default selected button
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
        ])
        
        // dday 제약 조건
        NSLayoutConstraint.activate([
            dday.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 56),
            dday.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dday.widthAnchor.constraint(equalToConstant: 39)
        ])
        
        // spanNDuration 제약 조건
        NSLayoutConstraint.activate([
            spanNDuration.centerYAnchor.constraint(equalTo: dday.centerYAnchor),
            spanNDuration.leadingAnchor.constraint(equalTo: dday.trailingAnchor, constant: 20),
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
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 10),
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
                self.spendingView.isHidden = false
                self.reportView.isHidden = true
            }else{
                self.spendingView.isHidden = true
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
        
        header.setupTitleLabel(with: goal.goalEmoji + " " + goal.goalName)
        header.addBackButtonTarget(target: self, action: #selector(backButtonTapped), for: .touchUpInside)
        //layer1
        //dday
        dday.configure(for: self.goal)
        
        //spanDuration
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let startdatestr = dateFormatter.string(from: goal.goalStart)
        
        let enddatestr : String
        if Calendar.current.dateComponents([.year], from: goal.goalStart) == Calendar.current.dateComponents([.year], from: goal.goalEnd) {
            enddatestr = dateFormatter.string(from: goal.goalEnd)
        }else{
            dateFormatter.dateFormat = "MM.dd"
            enddatestr = dateFormatter.string(from: goal.goalEnd)
        }
        
        if goal.goalStart < Date() && Date() < goal.goalEnd {
            let day = Calendar.current.dateComponents([.day], from: goal.goalStart, to: Date()).day
            spanNDuration.text = startdatestr + " - " + enddatestr + " | " + "\(day ?? 0)" + "일차"
        }else{
            spanNDuration.text = startdatestr + " - " + enddatestr
        }
        
        //editBtn은 이미 위에 구현됨.
        
        //layer2
        //label1 이미 구현됨.
        //label2
        let usedAmountString = setComma(cash: goal.usedAmount)
        let goalAmountString = " / \(setComma(cash: goal.goalAmount))원"
        
        let attributedString = NSMutableAttributedString(string: usedAmountString, attributes: [
            .font: UIFont.mpFont26B(),
            .foregroundColor: UIColor.mpBlack
        ])
        
        attributedString.append(NSAttributedString(string: goalAmountString, attributes: [
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
//        self.navigationItem.title = goal.goalEmoji + " " + goal.goalName
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}



class SpendingView: UIView {
    
    // 날짜 필터 버튼
    let filterBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 기간 조회", for: .normal)
        button.setTitleColor(.mpCharcoal, for: .normal)
        button.titleLabel?.font = .mpFont12M()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // 테이블뷰 초기 설정을 여기에 추가하세요.
        return tableView
    }()
    
    override init(frame: CGRect) {
        //api 호출로 셀 채워넣기 코드
        
        
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(filterBtn)
        addSubview(tableView)
        
        filterBtn.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        // 필터 버튼 및 테이블뷰의 오토레이아웃 설정을 여기에 추가하세요.
        NSLayoutConstraint.activate([
            filterBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            filterBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: filterBtn.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc private func filterButtonTapped() {
        tapFilterBtn?()
    }
    
    var tapFilterBtn: (() -> Void)?
}

class ReportView: UIView {
    
    // 리포트 뷰에 필요한 UI 요소를 여기에 추가하세요.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // 리포트 뷰의 오토레이아웃 설정을 여기에 추가하세요.
    }
}

extension GoalDetailsViewController {
    
    @objc func showModal() {
        let modal = ShowingPeriodSelectionModal(startDate: goal.goalStart, endDate: goal.goalEnd)
        modal.modalPresentationStyle = .popover
        modal.delegate = self
        present(modal, animated: true)
    }
    
    func configureSpendingAndReportViews() {
        spendingView.tapFilterBtn = { [weak self] in
            self?.showModal()
        }
        
        spendingView.translatesAutoresizingMaskIntoConstraints = false
        reportView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(spendingView)
        view.addSubview(reportView)
        
        // 이곳에서 spendingView와 reportView를 뷰에 추가하고 오토레이아웃을 설정하세요.
        NSLayoutConstraint.activate([
            spendingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spendingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spendingView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 1),
            spendingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reportView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reportView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reportView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 1),
            reportView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
