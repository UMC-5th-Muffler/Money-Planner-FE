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
        let modal = ShowingPeriodSelectionModal(startDate: goal.startDate?.toMPDate(), endDate: goal.endDate?.toMPDate())
        modal.modalPresentationStyle = .popover
        modal.delegate = self
        present(modal, animated: true)
    }
    
    func configureSpendingAndReportViews() {
        
        spendingView.tapFilterBtn = { [weak self] in
            self?.showModal()
        }
        
        reportView.goal = self.goal // Pass the goal to the report view
        reportView.tableView.reloadData()
        
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
    
    var goal : Goal_
    let reportViewModel = GoalReportViewModel.shared
    let disposeBag = DisposeBag()
    
    private lazy var spendingView = SpendingView()
    private lazy var reportView = ReportView()
    
    init(goal: Goal_) {
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
        
        // ViewModel에서 GoalReport 데이터 가져오기
        reportViewModel.fetchGoalReport(for: goal.goalID)
        
        // ViewModel의 CategoryTotalCost 데이터를 관찰하고 UI 업데이트
        reportViewModel.goalReportRelay.asObservable()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] goalReportResult in
                self?.updateCategory(with: goalReportResult)
            }).disposed(by: disposeBag)
    }
    
    func updateCategory(with reports: GoalReportResult) {
        reportView.updateCategory(with: reports, goal: goal)
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
        
        header.setupTitleLabel(with: goal.icon + " " + goal.goalTitle)
        header.addBackButtonTarget(target: self, action: #selector(backButtonTapped), for: .touchUpInside)
        //layer1
        //dday
        dday.configure(for: self.goal)
        
        //spanDuration
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let startdatestr = dateFormatter.string(from: goal.startDate)
        
        let enddatestr : String
        if Calendar.current.dateComponents([.year], from: goal.startDate) == Calendar.current.dateComponents([.year], from: goal.endDate) {
            enddatestr = dateFormatter.string(from: goal.endDate)
        }else{
            dateFormatter.dateFormat = "MM.dd"
            enddatestr = dateFormatter.string(from: goal.endDate)
        }
        
        if goal.startDate < Date() && Date() < goal.endDate {
            let day = Calendar.current.dateComponents([.day], from: goal.startDate, to: Date()).day
            spanNDuration.text = startdatestr + " - " + enddatestr + " | " + "\(day ?? 0)" + "일차"
        }else{
            spanNDuration.text = startdatestr + " - " + enddatestr
        }
        
        //editBtn은 이미 위에 구현됨.
        
        //layer2
        //label1 이미 구현됨.
        //label2
        let totalCostString = setComma(cash: goal.totalCost)
        let goalBudgetString = " / \(setComma(cash: goal.goalBudget))원"
        
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



class SpendingView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    //    var data: [DailyConsume] = [] {
    //        didSet {
    //            tableView.reloadData()
    //        }
    //    }
    var data: [DailyConsume] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tapFilterBtn: (() -> Void)?
    
    // 날짜 필터 버튼
    let filterBtn: LabelAndImageBtn = {
        let button = LabelAndImageBtn(type: .system)
        button.setTitle("전체 기간 조회 ", for: .normal)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.setTitleColor(.mpCharcoal, for: .normal)
        button.titleLabel?.font = .mpFont12M()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        table.separatorStyle = .none
        return table
    }()
    
    override init(frame: CGRect) {
        //api 호출로 셀 채워넣기 코드
        super.init(frame: frame)
        data = parseDailyConsume(from: jsonString) ?? []
        setupViews()
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(filterBtn)
        addSubview(tableView)
        
        filterBtn.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConsumeRecordCell.self, forCellReuseIdentifier: "ConsumeRecordCell")
        
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].expenseDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConsumeRecordCell", for: indexPath) as? ConsumeRecordCell else {
            fatalError("Unable to dequeue ConsumeRecordCell")
        }
        
        let consumeRecord = data[indexPath.section].expenseDetailList[indexPath.row]
        
        cell.configure(with: consumeRecord)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let separatorView : UIView = {
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .mpGypsumGray
            v.heightAnchor.constraint(equalToConstant: 1)
            return v
        }()
        
        // 섹션 헤더에 표시할 내용을 추가
        let titleLabel = MPLabel()
        titleLabel.text = data[section].date
        titleLabel.textColor = UIColor(hexCode: "9FAAB0")
        titleLabel.font = UIFont.mpFont14M()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // "Cost" 텍스트를 추가
        let costLabel = MPLabel()
        
        let result: String = data[section].dailyTotalCost.formattedWithSeparator()
        
        costLabel.text = "\(result)원"
        costLabel.textColor = UIColor.mpDarkGray
        costLabel.font = UIFont.mpFont14M()
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(costLabel)
        headerView.addSubview(separatorView)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            costLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            costLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            
            //            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            //            separatorView.trailingAnchor.constraint(equalTo: costLabel.trailingAnchor)
        ])
        
        return headerView
    }
    
    func parseDailyConsume(from jsonString: String) -> [DailyConsume]? {
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        do {
            let dailyConsumes = try decoder.decode([DailyConsume].self, from: jsonData)
            return dailyConsumes
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    let jsonString = """
    [
      {
        "date": "2024-02-01",
        "dailyTotalCost": 54787,
        "expenseDetailList": [
          {"title": "교통", "cost": 12074},
          {"title": "쇼핑", "cost": 4267},
          {"title": "기타", "cost": 2734},
          {"title": "기타", "cost": 13783},
          {"title": "식사", "cost": 4426}
        ]
      },
      {
        "date": "2024-02-02",
        "dailyTotalCost": 87180,
        "expenseDetailList": [
          {"title": "교통", "cost": 14498},
          {"title": "쇼핑", "cost": 19898},
          {"title": "식사", "cost": 6872},
          {"title": "쇼핑", "cost": 12139}
        ]
      },
      {
        "date": "2024-02-12",
        "dailyTotalCost": 73836,
        "expenseDetailList": [
          {"title": "식사", "cost": 9805},
          {"title": "식사", "cost": 11865},
          {"title": "기타", "cost": 11343},
          {"title": "교통", "cost": 15389}
        ]
      }
    ]
    """
    
}

class ReportView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var goal: Goal_?
    let tableView = UITableView()
    var CategoryTotalCosts: [CategoryTotalCost] = []
    var CategoryGoalReports: [CategoryGoalReport] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(ReportSummaryCell.self, forCellReuseIdentifier: "ReportSummaryCell")
        tableView.register(ReportGraphCell.self, forCellReuseIdentifier: "ReportGraphCell")
        tableView.register(CategoryReportCell.self, forCellReuseIdentifier: "CategoryReportCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        // Constraints for tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.tableFooterView = UIView() // to remove unused cells
    }
    
    func updateCategory(with reports: GoalReportResult, goal : Goal_) {
        self.CategoryTotalCosts = reports.categoryTotalCosts
        self.CategoryGoalReports = reports.categoryGoalReports
        self.goal = goal
        tableView.reloadData() // 테이블 뷰 리로드하여 새 데이터 반영
    }

    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // One for summary, one for graph, one for category reports
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Adjust the number of rows for each section
        switch section {
        case 0: // Summary section
            return 1
        case 1: // Graph section
            return 1
        case 2: // Category report section
            return CategoryGoalReports.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue and configure the cell based on section
        switch indexPath.section {
        case 0: //리포트 요약 카드
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportSummaryCell", for: indexPath) as! ReportSummaryCell
            if let goal = goal {
                cell.configureCell(goal: goal)
            }
            return cell
            
        case 1: //그래프
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportGraphCell", for: indexPath) as! ReportGraphCell
            cell.configure(with: CategoryTotalCosts, goal: goal!)
            return cell
            
        case 2: //카테고리별 리포트
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryReportCell", for: indexPath) as! CategoryReportCell
            if indexPath.row < CategoryGoalReports.count {
                let report = CategoryGoalReports[indexPath.row]
                if let goal = self.goal {
                    cell.configureCell(report: report, goal: goal)
                }
            }
            return cell
            
        default:
            fatalError("Unknown section")
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        tableView.delegate = self // Set the delegate
    }
    
    // UITableViewDelegate method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 420 // Height for ReportSummaryCell
        case 1:
            return 300 // Height for ReportGraphCell
        case 2:
            return 300 // Height for CategoryReportCell
        default:
            return UITableView.automaticDimension // Fallback
        }
    }
}


class ReportSummaryCell : UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //card
    let cardView : UIView = {
        let v = UIView()
        v.backgroundColor = .mpGypsumGray
        v.layer.cornerRadius = 27
        return v
    }()
    
    var cardImage = UIImageView()
    var cardLabel : MPLabel = {
        let label = MPLabel()
        label.textAlignment = .center
        label.font = .mpFont16B()
        label.numberOfLines = 0
        return label
    }()
    
    //average
    //var average : Int64 = 0
    var circle1 : UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "circlebadge.fill"))
        image.tintColor = UIColor(hexCode: "D9D9D9")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var averageLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont16M()
        label.textAlignment = .left
        return label
    }()
    
    //mostConsumedCat
    //var mostConsumedCat = ""
    var circle2 : UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "circlebadge.fill"))
        image.tintColor = UIColor(hexCode: "D9D9D9")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var mostConsumedCatLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont16M()
        label.textAlignment = .left
        return label
    }()
    
    //zeroDayCount
    //var zeroDayCount : Int64 = 0
    var circle3 : UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "circlebadge.fill"))
        image.tintColor = UIColor(hexCode: "D9D9D9")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var zeroDayCountLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont16M()
        label.textAlignment = .left
        return label
    }()
    
    var stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    let hstack1 : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    let hstack2 : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    let hstack3 : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    
    //텍스트 만드는 함수
    func makeLabelText(front: String, middle: String, end: String, color: UIColor) -> NSAttributedString {
        let frontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpCharcoal]
        let middleAttributes = [NSAttributedString.Key.foregroundColor: color]
        let endAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpCharcoal]
        
        let attributedString = NSMutableAttributedString(string: front + " ", attributes: frontAttributes)
        attributedString.append(NSAttributedString(string: middle, attributes: middleAttributes))
        attributedString.append(NSAttributedString(string: " " + end, attributes: endAttributes))
        
        return attributedString
    }
    
    func configureCell(goal : Goal_){
        
        self.contentView.backgroundColor = .mpWhite
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardImage.translatesAutoresizingMaskIntoConstraints = false
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        mostConsumedCatLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroDayCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if goal.endDate.toMPDate()! <= Date() { //현재, 과거 startDate >= Date
            
            var span : Int?
            
            if goal.endDate.toMPDate()! < Date() { //과거
                span = Calendar.current.dateComponents([.day], from: goal.startDate, to: goal.endDate).day
            }else {
                span = Calendar.current.dateComponents([.day], from: goal.startDate, to: Date()).day
            }
            
            //card
            //cardLabel
            let (color, front, middle, end): (UIColor, String, String, String) = goal.totalCost <= goal.goalBudget ?
            (UIColor.mpMainColor, "목표 금액보다 ", "\(setComma(cash: goal.goalBudget - goal.totalCost))", " 원을 아꼈어요\n아주 잘 하고 있어요!") :
            (UIColor.mpRed, "목표 금액보다 ", "\(setComma(cash: goal.totalCost - goal.goalBudget))", "원을 초과했어요\n조금만 더 아껴보아요!")
            cardLabel.attributedText = makeLabelText(front: front, middle: middle, end: end, color: color)
            //cardImage 추후 수정
            cardImage.image = goal.totalCost <= goal.goalBudget ? UIImage(systemName: "pencil"): UIImage(systemName: "pencil")
            
            averageLabel.attributedText = makeLabelText(front: "하루평균 ", middle: "\(setComma(cash: Int64(goal.totalCost)/Int64(span!)))원", end: " 결제했어요", color: .mpMainColor)
            
            mostConsumedCatLabel.attributedText = makeLabelText(front: "가장 많이 쓴 카테고리는 ", middle: "'임시조치'", end: "(이)에요", color: .mpMainColor) // todo : middle은 수정할것
            
            zeroDayCountLabel.attributedText = makeLabelText(front: "0원 소비를 한 날은 총 ", middle: "'임시조치'일", end: "이에요", color: .mpMainColor) // todo : middle은 수정할것
            
        } else{ //미래 목표
            cardLabel.text = "아직 시작하지 않은 목표에요"
            averageLabel.isHidden = true
            mostConsumedCatLabel.isHidden = true
            zeroDayCountLabel.isHidden = true
            circle1.isHidden = true
            circle2.isHidden = true
            circle3.isHidden = true
        }
    }
    
    func setupLayout(){
        
        contentView.addSubview(cardView)
        contentView.addSubview(cardImage)
        contentView.addSubview(cardLabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalToConstant: 192),
            
            cardImage.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cardImage.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            cardImage.widthAnchor.constraint(equalToConstant: 78),
            cardImage.heightAnchor.constraint(equalToConstant: 78),
            
            cardLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cardLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -30),
            cardLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            cardLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
        
        // Set up stackView with hstacks
        stackView.addArrangedSubview(hstack1)
        stackView.addArrangedSubview(hstack2)
        stackView.addArrangedSubview(hstack3)
        stackView.spacing = 20 // Adjust the spacing accordingly
        
        // Add the circles and labels to the horizontal stacks
        hstack1.addArrangedSubview(circle1)
        hstack1.addArrangedSubview(averageLabel)
        
        hstack2.addArrangedSubview(circle2)
        hstack2.addArrangedSubview(mostConsumedCatLabel)
        
        hstack3.addArrangedSubview(circle3)
        hstack3.addArrangedSubview(zeroDayCountLabel)
        
        // Set up constraints for circles and labels
        [circle1, circle2, circle3].forEach { circle in
            circle.widthAnchor.constraint(equalToConstant: 30).isActive = true
            circle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        // Set up constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 44),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            //            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        // Constraints for the horizontal stack views to align the circles and labels
        [hstack1, hstack2, hstack3].forEach { hstack in
            hstack.alignment = .center
            hstack.spacing = 8 // Adjust the spacing accordingly
        }
        
        // Make sure the labels do not compress smaller than their content
        [averageLabel, mostConsumedCatLabel, zeroDayCountLabel].forEach { label in
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
        
        // 30보다는 멀리 있도록 제한
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -30).isActive = true
    }
    
    private func setComma(cash: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: cash)) ?? ""
    }
}

class ReportGraphCell: UITableViewCell {
    
    var titleLabel : MPLabel = {
        let label = MPLabel()
        label.text = "가장 많이 소비한 곳은?"
        label.font = .mpFont20B()
        label.textColor = .mpBlack
        return label
    }()
    
    var categoryConsumeRatioGraph = CategoryConsumeRatioGraph()
    var firstCat = CategoryConsumeRatioGraphTextView()
    var secondCat = CategoryConsumeRatioGraphTextView()
    var thirdCat = CategoryConsumeRatioGraphTextView()
    var othersCat = CategoryConsumeRatioGraphTextView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        
        contentView.addSubview(firstCat)
        contentView.addSubview(secondCat)
        contentView.addSubview(thirdCat)
        contentView.addSubview(othersCat)
        
        // titleLabel과 categoryConsumeRatioGraph 추가 등 기본 레이아웃 설정
        // ... 코드 추가
        
        // CategoryConsumeRatioGraphTextViews 레이아웃 설정
        let views = [firstCat, secondCat, thirdCat, othersCat]
        for view in views {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            // Autolayout constraints
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                view.widthAnchor.constraint(equalToConstant: 200),
                view.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        // 추가적인 제약 조건 설정
        // 첫 번째 카테고리 뷰는 titleLabel 아래에 위치하게 설정
        NSLayoutConstraint.activate([
            firstCat.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
            // 추가적인 제약 조건은 아래에 구성
        ])
        
        // 다음 카테고리 뷰들은 각각 이전 뷰의 아래에 위치하게 설정
        NSLayoutConstraint.activate([
            secondCat.topAnchor.constraint(equalTo: firstCat.bottomAnchor, constant: 8),
            thirdCat.topAnchor.constraint(equalTo: secondCat.bottomAnchor, constant: 8),
            othersCat.topAnchor.constraint(equalTo: thirdCat.bottomAnchor, constant: 8)
        ])
    }
    
    func configure(with reports: [CategoryTotalCost], goal : Goal) {
        
        //그래프 configure
        categoryConsumeRatioGraph.configure(with: reports, goal: goal)
        
        //아래 configure
        let totalCost = reports.reduce(0) { $0 + $1.totalCost }
        
        let sortedReports = reports.sorted(by: { $0.totalCost > $1.totalCost })
        let topReports = sortedReports.prefix(3)
        let otherReports = sortedReports.dropFirst(3)
        let otherTotalCost = otherReports.reduce(0) { $0 + $1.totalCost }
        
        // 각각의 CategoryConsumeRatioGraphTextView 구성
        let views = [firstCat, secondCat, thirdCat, othersCat]
        let colors = [UIColor.mpMainColor, UIColor.mpRed, UIColor.yellow, UIColor.mpGray] // 색상 설정
        
        for (index, view) in views.enumerated() {
            view.isHidden = true // 기본적으로 모든 뷰를 숨깁니다.
            if index < topReports.count {
                let report = topReports[index]
                let percentage = Int((Double(report.totalCost) / Double(totalCost)) * 100.0)
                view.configure(color: colors[index], name: report.categoryName, percentage: percentage)
                view.isHidden = false
            } else if index == 3 && !otherReports.isEmpty {
                let percentage = Int((Double(otherTotalCost) / Double(totalCost)) * 100.0)
                view.configure(color: colors[index], name: "그 외 카테고리 \(otherReports.count)개", percentage: percentage)
                view.isHidden = false
            }
        }
        
    }
}


class CategoryConsumeRatioGraph : UIView {

    var reportData : [CategoryTotalCost] = []
    var goal : Goal?
    
    //bar들의 틀이 되어줄 view
    let graphView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let firstBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = .mpMainColor
        bar.layer.cornerRadius = 33
        return bar
    }()
    
    let secondBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = .mpRed
        bar.layer.cornerRadius = 33
        return bar
    }()
    
    let thirdBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = .yellow
        bar.layer.cornerRadius = 33
        return bar
    }()
    
    let othersBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = .mpGray
        bar.layer.cornerRadius = 33
        return bar
    }()
    
    let leftAmountLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14B()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        NSLayoutConstraint.activate([
            graphView.leadingAnchor.constraint(equalTo: leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: trailingAnchor),
            graphView.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        NSLayoutConstraint.activate([
            firstBar.leadingAnchor.constraint(equalTo: graphView.leadingAnchor),
            firstBar.widthAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: 0.25),
            firstBar.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        //secondBar
        NSLayoutConstraint.activate([
            secondBar.leadingAnchor.constraint(equalTo: firstBar.leadingAnchor),
            secondBar.widthAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: 0.25),
            secondBar.heightAnchor.constraint(equalToConstant: 18),
        ])
        //thirdBar
        NSLayoutConstraint.activate([
            thirdBar.leadingAnchor.constraint(equalTo: secondBar.leadingAnchor),
            thirdBar.widthAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: 0.25),
            thirdBar.heightAnchor.constraint(equalToConstant: 18),
        ])
        //othersBar
        NSLayoutConstraint.activate([
            othersBar.leadingAnchor.constraint(equalTo: thirdBar.leadingAnchor),
            othersBar.widthAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: 0.25),
            othersBar.trailingAnchor.constraint(equalTo: graphView.trailingAnchor),
            othersBar.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        //leftAmountLabel
        NSLayoutConstraint.activate([
            leftAmountLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 10),
            leftAmountLabel.trailingAnchor.constraint(equalTo: graphView.trailingAnchor),
            leftAmountLabel.heightAnchor.constraint(equalToConstant: 23),
            leftAmountLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    private func setComma(cash: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: cash)) ?? ""
    }
    
    func configure(with reportData: [CategoryTotalCost], goal : Goal) {
        
        //leftAmountLabel 수정
        leftAmountLabel.text = goal.goalBudget >= goal.totalCost ? setComma(cash: goal.goalBudget - goal.totalCost) + "원" : setComma(cash: goal.totalCost - goal.goalBudget) + "원 초과"
        leftAmountLabel.textColor = goal.goalBudget >= goal.totalCost ? .mpBlack : .mpRed

        //그래프 형성
        let totalCost = reportData.reduce(0) { $0 + $1.totalCost }
        
        // 전체 너비에서 각 카테고리의 비율에 따른 너비 계산
        let proportions = reportData.map { CGFloat($0.totalCost) / CGFloat(totalCost) }
        
        // 모든 바의 너비를 초기화 (선택적으로, 상황에 맞게 조정 가능)
        [firstBar, secondBar, thirdBar, othersBar].forEach { bar in
            if let widthConstraint = bar.constraints.first(where: { $0.firstAttribute == .width }) {
                widthConstraint.constant = 0
            }
        }
        
        // 카테고리 개수에 따라 각 바의 너비 설정
        for (index, proportion) in proportions.enumerated() {
            let width = proportion * self.graphView.bounds.width
            switch index {
            case 0:
                if let widthConstraint = firstBar.constraints.first(where: { $0.firstAttribute == .width }) {
                    widthConstraint.constant = width
                }
            case 1:
                if let widthConstraint = secondBar.constraints.first(where: { $0.firstAttribute == .width }) {
                    widthConstraint.constant = width
                }
            case 2:
                if let widthConstraint = thirdBar.constraints.first(where: { $0.firstAttribute == .width }) {
                    widthConstraint.constant = width
                }
            default:
                // 나머지 모든 카테고리는 othersBar의 너비에 추가
                if let widthConstraint = othersBar.constraints.first(where: { $0.firstAttribute == .width }) {
                    widthConstraint.constant += width // othersBar에 나머지 비율들의 합산 너비 설정
                }
            }
        }
        
        // 애니메이션 적용하여 레이아웃 변경
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }

}

class CategoryConsumeRatioGraphTextView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let circle : UIImageView = {
        let circle = UIImageView(image: UIImage(systemName: "circle.fill"))
        circle.contentMode = .scaleAspectFit
        return circle
    }()
    
    let categoryName : MPLabel = {
        let label = MPLabel()
        label.textColor = .mpBlack
        label.font = .mpFont16M()
        return label
    }()
    
    let percentage : MPLabel = {
        let label = MPLabel()
        label.textColor = .mpDarkGray
        label.font = .mpFont14M()
        return label
    }()
    
    func setLayout(){
        addSubview(circle)
        addSubview(categoryName)
        addSubview(percentage)
        
        circle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circle.leadingAnchor.constraint(equalTo: leadingAnchor),
            circle.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle.widthAnchor.constraint(equalToConstant: 24),
            circle.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryName.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 16),
            categoryName.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryName.trailingAnchor.constraint(lessThanOrEqualTo: percentage.leadingAnchor, constant: -16)
        ])
        
        percentage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            percentage.trailingAnchor.constraint(equalTo: trailingAnchor),
            percentage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(color : UIColor, name : String, percentage : Int){
        circle.tintColor = color
        categoryName.text = name
        self.percentage.text = "\(percentage)%"
    }
    
}

class CategoryReportCell: UITableViewCell {
    
    let categoryIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let categoryName : MPLabel = {
        let label = MPLabel()
        label.textColor = .mpBlack
        label.font = .mpFont18B()
        label.textAlignment = .left
        return label
    }()
    var verticalStack = UIStackView()
    var progressBar = GoalProgressBar(goalAmt: 300000, usedAmt: 0) // 임시 값으로 초기화
    let totalCostLabel = MPLabel() //progressBar 안에
    let leftAmountLabel = MPLabel() //progressBar 안에
    let averageLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont16M()
        label.textAlignment = .left
        return label
    }()
    let mostConsumedLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont16M()
        label.textAlignment = .left
        return label
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        
        //아이콘, label
        NSLayoutConstraint.activate([
            categoryIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            categoryIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryIcon.widthAnchor.constraint(equalToConstant: 40),
            categoryIcon.heightAnchor.constraint(equalToConstant: 40),
            
            categoryName.centerYAnchor.constraint(equalTo: categoryIcon.centerYAnchor),
            categoryName.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: 16),
            categoryName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryName.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        //stack요소
        setupStackView()
        
        //label
        NSLayoutConstraint.activate([
            averageLabel.topAnchor.constraint(equalTo: verticalStack.bottomAnchor, constant: 16),
            averageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            averageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            mostConsumedLabel.topAnchor.constraint(equalTo: averageLabel.bottomAnchor, constant: 16),
            mostConsumedLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            mostConsumedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mostConsumedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    public func configureCell(report : CategoryGoalReport, goal : Goal){
        
        contentView.backgroundColor = .mpWhite
        categoryIcon.image = UIImage(named: report.categoryName)
        categoryName.text = report.categoryName
        
        progressBar.changeUsedAmt(usedAmt: Int64(report.totalCost), goalAmt: Int64(report.categoryBudget))
        
        let color : UIColor = goal.totalCost < goal.goalBudget ? .mpMainColor : .mpRed
        averageLabel.attributedText = makeLabelText(front: "평균적으로", middle: formatNumber(Int64(report.avgCost))+"원", end: "결제했어요", color: color)
        mostConsumedLabel.attributedText = makeLabelText(front: "가장 많이 쓴 돈은 ", middle: formatNumber(Int64(report.maxCost))+"원", end: "이에요", color: color)
        
        updateSumAmountDisplay(goal: goal)
        
    }
    
    private func setupStackView() {

        totalCostLabel.font = UIFont.systemFont(ofSize: 14)
        leftAmountLabel.font = .mpFont14B()
        
        let horizontalStack = UIStackView(arrangedSubviews: [totalCostLabel, leftAmountLabel])
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .equalSpacing
        horizontalStack.alignment = .center
        
        verticalStack = UIStackView(arrangedSubviews: [progressBar, horizontalStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = 8
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: categoryName.bottomAnchor, constant: 20),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        progressBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func makeLabelText(front: String, middle: String, end: String, color: UIColor) -> NSAttributedString {
        let frontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpCharcoal]
        let middleAttributes = [NSAttributedString.Key.foregroundColor: color]
        let endAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpCharcoal]
        
        let attributedString = NSMutableAttributedString(string: front + " ", attributes: frontAttributes)
        attributedString.append(NSAttributedString(string: middle, attributes: middleAttributes))
        attributedString.append(NSAttributedString(string: " " + end, attributes: endAttributes))
        
        return attributedString
    }
    
    //총금액 알려주는 구간 업데이트
    private func updateSumAmountDisplay(goal : Goal) {
        let sumAmount = goal.totalCost
        let formattedSumAmount = formatNumber(sumAmount)
        let goalBudget = goal.goalBudget
        let formattedGoalAmount = formatNumber(goalBudget)
        
        let text = "\(formattedSumAmount)원 / \(formattedGoalAmount)원"
        
        // NSAttributedString을 사용하여 다른 색상 적용
        let attributedString = NSMutableAttributedString(string: text)
        
        // '/' 기호를 기준으로 전후 텍스트의 범위를 찾음
        if let range = text.range(of: "/") {
            let preSlashRange = NSRange(text.startIndex..<range.lowerBound, in: text)
            let fromSlashRange = NSRange(range.lowerBound..<text.endIndex, in: text) //endIndex 포함시 오버플로우
            attributedString.addAttribute(.foregroundColor, value: UIColor.mpDarkGray, range: preSlashRange )
            attributedString.addAttribute(.foregroundColor, value: UIColor.mpGray, range: fromSlashRange)
        }
        
        totalCostLabel.attributedText = attributedString
        
        let leftAmount = goalBudget > sumAmount ? goalBudget - sumAmount : sumAmount - goalBudget
        let formattedLeftAmount = formatNumber(leftAmount)
        leftAmountLabel.text = goalBudget > sumAmount ? "남은 금액 \(formattedLeftAmount)원" : "초과 금액 \(formattedLeftAmount)원"
        leftAmountLabel.textColor = goalBudget >= sumAmount ? .mpBlack : .mpRed
        
    }
    
    private func formatNumber(_ number: Int64) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // Use .decimal for formatting with commas.
        return numberFormatter.string(from: NSNumber(value: number)) ?? "0"
    }
}
