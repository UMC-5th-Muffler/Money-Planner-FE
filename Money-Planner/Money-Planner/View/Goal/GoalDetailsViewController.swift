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
        let modal = ShowingPeriodSelectionModal(startDate: goal.goalStart, endDate: goal.goalEnd)
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
    
    var goal : Goal
    
    private lazy var spendingView = SpendingView()
    private lazy var reportView = ReportView()
    
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
    
    var goal: Goal?
    let tableView = UITableView()
    
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
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue and configure the cell based on section
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportSummaryCell", for: indexPath) as! ReportSummaryCell
            if let goal = goal {
                cell.configureCell(goal: goal)
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportGraphCell", for: indexPath) as! ReportGraphCell
            // Configure graph cell
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryReportCell", for: indexPath) as! CategoryReportCell
            // Configure category cell
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
            return 200 // Height for ReportGraphCell
        case 2:
            return 80 // Height for CategoryReportCell
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
    
    func configureCell(goal : Goal){
        
        self.contentView.backgroundColor = .mpWhite
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardImage.translatesAutoresizingMaskIntoConstraints = false
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        mostConsumedCatLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroDayCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if goal.goalStart <= Date() { //현재, 과거
            
            var span : Int?
            
            if goal.goalEnd < Date() { //과거
                span = Calendar.current.dateComponents([.day], from: goal.goalStart, to: goal.goalEnd).day
            }else {
                span = Calendar.current.dateComponents([.day], from: goal.goalStart, to: Date()).day
            }
            
            //card
            //cardLabel
            let (color, front, middle, end): (UIColor, String, String, String) = goal.usedAmount <= goal.goalAmount ?
            (UIColor.mpMainColor, "목표 금액보다 ", "\(setComma(cash: goal.goalAmount - goal.usedAmount))", " 원을 아꼈어요\n아주 잘 하고 있어요!") :
            (UIColor.mpRed, "목표 금액보다 ", "\(setComma(cash: goal.usedAmount - goal.goalAmount))", "원을 초과했어요\n조금만 더 아껴보아요!")
            cardLabel.attributedText = makeLabelText(front: front, middle: middle, end: end, color: color)
            //cardImage 추후 수정
            cardImage.image = goal.usedAmount <= goal.goalAmount ? UIImage(systemName: "pencil"): UIImage(systemName: "pencil")
            
            averageLabel.attributedText = makeLabelText(front: "하루평균 ", middle: "\(setComma(cash: Int64(goal.usedAmount)/Int64(span!)))원", end: " 결제했어요", color: .mpMainColor)
            
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        // Implement your layout setup here
    }
}

class CategoryReportCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        // Implement your layout setup here
    }
}
