//
//  ReportView.swift
//  Money-Planner
//
//  Created by 유철민 on 2/28/24.
//

import Foundation
import UIKit

class ReportView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var goalDetail : GoalDetail?
    var zeroDayCount: Int64 = 0
    var CategoryTotalCosts: [CategoryTotalCost] = []
    var CategoryGoalReports: [CategoryGoalReport] = []
    let tableView = UITableView()
    
    var summaryCellHeight = 420
    var graphCellHeight = 90
    
    var numberOfSections = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        tableView.dataSource = self
        tableView.register(ReportSummaryCell.self, forCellReuseIdentifier: "ReportSummaryCell")
        tableView.register(ReportGraphCell.self, forCellReuseIdentifier: "ReportGraphCell")
        tableView.register(CategoryReportCell.self, forCellReuseIdentifier: "CategoryReportCell")
        tableView.backgroundColor = .mpWhite
        
        addSubview(tableView)
        tableView.separatorStyle = .none
//        tableView.tableFooterView = UIView() // to remove unused cells
//        tableView.tableFooterView?.backgroundColor = .mpWhite
    }
    
    private func setupLayout(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // Constraints for tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
//    func updateCategory(with reports: GoalReportResult, goal : GoalDetail) {
//        self.zeroDayCount = reports.zeroDayCount
//        self.CategoryTotalCosts = reports.categoryTotalCosts
//        self.CategoryGoalReports = reports.categoryGoalReports
//        self.goalDetail = goal
//        tableView.reloadData() // 테이블 뷰 리로드하여 새 데이터 반영
//    }
    
    func updateCategoryReports(with reports: GoalReportResult) {
        self.zeroDayCount = reports.zeroDayCount
        self.CategoryTotalCosts = reports.categoryTotalCosts
        self.CategoryGoalReports = reports.categoryGoalReports
        
        if CategoryTotalCosts.count == 0 {
            graphCellHeight = 120
        }else {
            graphCellHeight = 140 + (CategoryTotalCosts.count * 38) + 30
        }
        
        tableView.reloadData() // 테이블 뷰 리로드하여 새 데이터 반영
    }
    
    func updateCategoryGoalDetail(goal : GoalDetail) {
        self.goalDetail = goal
        print(goal.startDate.toDate!)
        print(Date.todayAtMidnight)
        if goal.startDate.toDate! > Date.todayAtMidnight {
            summaryCellHeight = 220
            numberOfSections = 1
//            tableView.backgroundColor = .mpGypsumGray
        }else{
            summaryCellHeight = 420
            numberOfSections = 3
//            tableView.backgroundColor = .mpWhite
        }
        tableView.reloadData() // 테이블 뷰 리로드하여 새 데이터 반영
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        // One for summary, one for graph, one for category reports
        return self.numberOfSections
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
            if let goalDetail = goalDetail {
                cell.configureCell(goal: goalDetail, categoryTotalCost : CategoryTotalCosts, zeroDayCount : zeroDayCount)
            }
            return cell
            
        case 1: //그래프
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportGraphCell", for: indexPath) as! ReportGraphCell
            if let goalDetail = goalDetail {
                cell.configureCell(with: CategoryTotalCosts, goal: goalDetail)
            }
            return cell
            
        case 2: //카테고리별 리포트
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryReportCell", for: indexPath) as! CategoryReportCell
            if indexPath.row < CategoryGoalReports.count {
                let report = CategoryGoalReports[indexPath.row]
                if let goalDetail = self.goalDetail{
                    cell.configureCell(report: report, goal: goalDetail)
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
            return CGFloat(summaryCellHeight) // Height for ReportSummaryCell
        case 1:
            return CGFloat(graphCellHeight) // Height for ReportGraphCell
        case 2:
            return CGFloat(240) // Height for CategoryReportCell
        default:
            return UITableView.automaticDimension // Fallback
        }
    }
    
    //section header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
//
        // 섹션별로 다른 헤더 타이틀 설정
        switch section {
        case 2:
            let headerLabel = UILabel(frame: CGRect(x: 16, y: 8, width: tableView.bounds.size.width - 32, height: 24))
            headerLabel.font = .mpFont20B() // 헤더의 폰트 설정
            headerLabel.textColor = .mpBlack // 헤더의 텍스트 색상 설정
            headerLabel.text = "카테고리별 리포트 보기"
            headerView.backgroundColor = .mpWhite// 헤더의 배경 색상 설정
            headerView.addSubview(headerLabel)
        default:
            headerView.backgroundColor = .mpGypsumGray
        }
//
//
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 0 :
            return 0
        case 1 :
            return 10
        case 2 :
            return 40
        default :
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .mpGypsumGray
        switch section {
        case 1:
            return footerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section{
        case 1 :
            return 10
        default :
            return 0
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
        label.font = .mpFont16M()
        label.numberOfLines = 0
        return label
    }()
    
    //average
    //var average : Int64 = 0
    var circle1 : UIImageView = {
        let image = UIImageView(image: UIImage(named: "icon_spend-money"))
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
        let image = UIImageView(image: UIImage(named: "icon_most-spend"))
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
        let image = UIImageView(image: UIImage(named: "icon_0day"))
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
    func makeLabelText(front: String, middle: String, end: String, color: UIColor, middleBold : Bool, elseColor: UIColor = .mpCharcoal) -> NSAttributedString {
        let frontAttributes = [NSAttributedString.Key.foregroundColor: elseColor]
        let middleAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: middleBold ? UIFont.mpFont16B() : UIFont.mpFont16M()]
        let endAttributes = [NSAttributedString.Key.foregroundColor: elseColor]
        
        let attributedString = NSMutableAttributedString(string: front, attributes: frontAttributes)
        attributedString.append(NSAttributedString(string: middle, attributes: middleAttributes))
        attributedString.append(NSAttributedString(string: end, attributes: endAttributes))
        
        return attributedString
    }
    
    func configureCell(goal : GoalDetail, categoryTotalCost : [CategoryTotalCost], zeroDayCount : Int64){
        
        self.contentView.backgroundColor = .mpWhite
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardImage.translatesAutoresizingMaskIntoConstraints = false
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        mostConsumedCatLabel.translatesAutoresizingMaskIntoConstraints = false
        zeroDayCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if goal.startDate.toDate! <= Date.todayAtMidnight { //현재, 과거 startDate >= Date
            
            var span : Int?
            
            if goal.endDate.toDate! < Date.todayAtMidnight { //과거
                span = Calendar.current.dateComponents([.day], from: goal.startDate.toDate!, to: goal.endDate.toDate!).day
            }else {
                span = Calendar.current.dateComponents([.day], from: goal.startDate.toDate!, to: Date.todayAtMidnight).day
            }
            
            //card
            //cardLabel
            let (color, front, middle, end): (UIColor, String, String, String) = goal.totalCost <= goal.totalBudget ?
            (UIColor.mpMainColor, "목표 금액보다 ", "\(setComma(cash: goal.totalBudget - goal.totalCost))원", "을 아꼈어요\n아주 잘 하고 있어요!") :
            (UIColor.mpRed, "목표 금액보다 ", "\(setComma(cash: goal.totalCost - goal.totalBudget))원", "을 초과했어요\n조금만 더 아껴보아요!")
            cardLabel.attributedText = makeLabelText(front: front, middle: middle, end: end, color: color, middleBold: true, elseColor: .mpBlack)
            //cardImage 추후 수정
            cardImage.image = goal.totalCost <= goal.totalBudget ? UIImage(named : "img_goalreport-safe"): UIImage(named : "img_goalreport-over")
            
            averageLabel.attributedText = makeLabelText(front: "하루평균 ", middle: "\(setComma(cash: Int64(goal.totalCost)/Int64(span!)))원", end: " 결제했어요", color: .mpMainColor, middleBold: false)

            mostConsumedCatLabel.attributedText = makeLabelText(front: "가장 많이 쓴 카테고리는 ", middle: categoryTotalCost.count > 0 ? categoryTotalCost[0].categoryName : "없습니다.", end: categoryTotalCost.count > 0 ? "(이)에요" : "", color: .mpMainColor, middleBold: false) // todo : middle은 수정할것
            
            zeroDayCountLabel.attributedText = makeLabelText(front: "0원 소비를 한 날은 총 ", middle: "\(zeroDayCount)일", end: "이에요", color: .mpMainColor, middleBold: false) // todo : middle은 수정할것
            
        } else{ //미래 목표
            cardImage.image = UIImage(named: "img_home-deafult")
            cardLabel.text = "아직 시작하지 않은 목표에요"
            averageLabel.isHidden = true
            mostConsumedCatLabel.isHidden = true
            zeroDayCountLabel.isHidden = true
            circle1.isHidden = true
            circle2.isHidden = true
            circle3.isHidden = true
        }
        
        cardImage.contentMode = .scaleAspectFit
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
            cardImage.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            cardImage.widthAnchor.constraint(equalToConstant: 108),
            cardImage.heightAnchor.constraint(equalToConstant: 108),
            
            cardLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cardLabel.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 15),
            cardLabel.bottomAnchor.constraint(lessThanOrEqualTo : cardView.bottomAnchor, constant: -20),
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
        label.textAlignment = .left
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
        // titleLabel과 categoryConsumeRatioGraph 추가 등 기본 레이아웃 설정
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryConsumeRatioGraph)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryConsumeRatioGraph.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            categoryConsumeRatioGraph.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            categoryConsumeRatioGraph.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryConsumeRatioGraph.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
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
            firstCat.topAnchor.constraint(equalTo: categoryConsumeRatioGraph.bottomAnchor, constant: 20)
            // 추가적인 제약 조건은 아래에 구성
        ])
        
        // 다음 카테고리 뷰들은 각각 이전 뷰의 아래에 위치하게 설정
        NSLayoutConstraint.activate([
            secondCat.topAnchor.constraint(equalTo: firstCat.bottomAnchor, constant: 8),
            thirdCat.topAnchor.constraint(equalTo: secondCat.bottomAnchor, constant: 8),
            othersCat.topAnchor.constraint(equalTo: thirdCat.bottomAnchor, constant: 8),
        ])
    }
    
    func configureCell(with reports: [CategoryTotalCost], goal : GoalDetail) {
        
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
                let percentage = (Double(report.totalCost) / Double(totalCost)) * 100.0
                view.configure(color: colors[index], name: report.categoryName, percentage: percentage)
                view.isHidden = false
            } else if index == 3 && !otherReports.isEmpty {
                let percentage = (Double(otherTotalCost) / Double(totalCost)) * 100.0
                view.configure(color: colors[index], name: "그 외 카테고리 \(otherReports.count)개", percentage: percentage)
                view.isHidden = false
            }
        }
        
        if firstCat.isHidden && secondCat.isHidden && thirdCat.isHidden && othersCat.isHidden {
            firstCat.isHidden = false
            firstCat.configure(color: .mpGray, name: "소비내역 없음", percentage: 0)
            firstCat.categoryName.textColor = .mpGray
            firstCat.percentage.text = ""
        }else{
            firstCat.categoryName.textColor = .mpBlack
        }
    }
}


class CategoryConsumeRatioGraph : UIView {

    var reportData : [CategoryTotalCost] = []
    
    //bar들의 틀이 되어줄 view
    let graphView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let firstBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = .mpMainColor
        bar.layer.cornerRadius = 4
        return bar
    }()
    
    let secondBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = .mpRed
        bar.layer.cornerRadius = 4
        return bar
    }()
    
    let thirdBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = .yellow
        bar.layer.cornerRadius = 4
        return bar
    }()
    
    let othersBar : UIView = {
        let bar = UIView()
        bar.backgroundColor = .mpGray
        bar.layer.cornerRadius = 4
        return bar
    }()
    
    let leftAmountLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14B()
        return label
    }()
    
    var firstBarWidthConstraint: NSLayoutConstraint?
    var secondBarWidthConstraint: NSLayoutConstraint?
    var thirdBarWidthConstraint: NSLayoutConstraint?
    var othersBarWidthConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        addSubview(graphView)
        addSubview(firstBar)
        addSubview(secondBar)
        addSubview(thirdBar)
        addSubview(othersBar)
        addSubview(leftAmountLabel)
        
        // Auto Layout 설정을 위해 translatesAutoresizingMaskIntoConstraints를 false로 설정
        graphView.translatesAutoresizingMaskIntoConstraints = false
        firstBar.translatesAutoresizingMaskIntoConstraints = false
        secondBar.translatesAutoresizingMaskIntoConstraints = false
        thirdBar.translatesAutoresizingMaskIntoConstraints = false
        othersBar.translatesAutoresizingMaskIntoConstraints = false
        leftAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: self.topAnchor),
            graphView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            graphView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        firstBarWidthConstraint = firstBar.widthAnchor.constraint(equalToConstant: 0)
        firstBarWidthConstraint?.isActive = true

        secondBarWidthConstraint = secondBar.widthAnchor.constraint(equalToConstant: 0)
        secondBarWidthConstraint?.isActive = true
        
        thirdBarWidthConstraint = firstBar.widthAnchor.constraint(equalToConstant: 0)
        thirdBarWidthConstraint?.isActive = true

        othersBarWidthConstraint = secondBar.widthAnchor.constraint(equalToConstant: 0)
        othersBarWidthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            firstBar.heightAnchor.constraint(equalToConstant: 8),
            firstBar.leadingAnchor.constraint(equalTo: graphView.leadingAnchor),
            firstBar.topAnchor.constraint(equalTo: graphView.topAnchor),
        ])
        
        //secondBar
        NSLayoutConstraint.activate([
            secondBar.heightAnchor.constraint(equalToConstant: 8),
            secondBar.leadingAnchor.constraint(equalTo: firstBar.trailingAnchor),
            secondBar.topAnchor.constraint(equalTo: graphView.topAnchor),
        ])
        //thirdBar
        NSLayoutConstraint.activate([
            thirdBar.heightAnchor.constraint(equalToConstant: 8),
            thirdBar.leadingAnchor.constraint(equalTo: secondBar.trailingAnchor),
            thirdBar.topAnchor.constraint(equalTo: graphView.topAnchor),
        ])
        //othersBar
        NSLayoutConstraint.activate([
//            othersBar.trailingAnchor.constraint(equalTo: graphView.trailingAnchor),
            othersBar.heightAnchor.constraint(equalToConstant: 8),
            othersBar.leadingAnchor.constraint(equalTo: thirdBar.trailingAnchor),
            othersBar.topAnchor.constraint(equalTo: graphView.topAnchor),
        ])
        
        //leftAmountLabel
        NSLayoutConstraint.activate([
            leftAmountLabel.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 10),
            leftAmountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            leftAmountLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    private func setComma(cash: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: cash)) ?? ""
    }
    
    func numberToKorean(_ number: Int64) -> String {
        let unitLarge = ["", "만", "억", "조"]
        
        var result = ""
        var num = number
        var unitIndex = 0
        
        while num > 0 {
            let segment = num % 10000
            if segment != 0 {
                result = "\((segment))\(unitLarge[unitIndex]) \(result)"
            }
            num /= 10000
            unitIndex += 1
        }
        
        return result.isEmpty ? "0" : result
    }
    
    func configure(with reportData: [CategoryTotalCost], goal: GoalDetail) {
        // Update leftAmountLabel based on goal status
        leftAmountLabel.text = goal.totalBudget >= goal.totalCost ? "남은 금액 " + numberToKorean(goal.totalBudget - goal.totalCost) + "원" : "초과 금액 " + numberToKorean(goal.totalCost - goal.totalBudget)
        leftAmountLabel.textColor = .mpCharcoal
//        leftAmountLabel.textColor = goal.totalBudget >= goal.totalCost ? .mpCharcoal : .mpRed

        // Calculate total cost from reportData
        let totalCost = reportData.reduce(0) { $0 + $1.totalCost }

        // Calculate proportions for each category
        let proportions = reportData.map { CGFloat($0.totalCost) / CGFloat(totalCost) }

        // Reset constraints before setting new values
        firstBarWidthConstraint?.isActive = false
        secondBarWidthConstraint?.isActive = false
        thirdBarWidthConstraint?.isActive = false
        othersBarWidthConstraint?.isActive = false

        // Assign calculated width to each bar based on its proportion
        if !proportions.isEmpty { // Ensure there is at least one proportion
            firstBarWidthConstraint = firstBar.widthAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: proportions.count > 0 ? proportions[0] : 0)
            secondBarWidthConstraint = secondBar.widthAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: proportions.count > 1 ? proportions[1] : 0)
            thirdBarWidthConstraint = thirdBar.widthAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: proportions.count > 2 ? proportions[2] : 0)
            let othersProportion = proportions.dropFirst(3).reduce(0, +)
            othersBarWidthConstraint = othersBar.widthAnchor.constraint(equalTo: graphView.widthAnchor, multiplier: othersProportion)
        }

        // Activate new constraints
        firstBarWidthConstraint?.isActive = true
        secondBarWidthConstraint?.isActive = true
        thirdBarWidthConstraint?.isActive = true
        othersBarWidthConstraint?.isActive = true

        // Animate changes
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded() // Animates the constraint changes
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
            percentage.leadingAnchor.constraint(equalTo: categoryName.trailingAnchor, constant: 18),
            percentage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(color : UIColor, name : String, percentage : Double){
        circle.tintColor = color
        categoryName.text = name
        self.percentage.text = "\(String(format: "%.1f", percentage))%"
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
        
        [categoryIcon, categoryName, averageLabel, mostConsumedLabel].forEach { view in
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //아이콘, label
        NSLayoutConstraint.activate([
            categoryIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            categoryIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryIcon.widthAnchor.constraint(equalToConstant: 40),
            categoryIcon.heightAnchor.constraint(equalToConstant: 40),
            
            categoryName.centerYAnchor.constraint(equalTo: categoryIcon.centerYAnchor),
            categoryName.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: 16),
            categoryName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        //stack요소
        setupStackView()
        
        //label
        NSLayoutConstraint.activate([
            averageLabel.topAnchor.constraint(equalTo: verticalStack.bottomAnchor, constant: 30),
            averageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            averageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            mostConsumedLabel.topAnchor.constraint(equalTo: averageLabel.bottomAnchor, constant: 16),
            mostConsumedLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
            mostConsumedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mostConsumedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    public func configureCell(report : CategoryGoalReport, goal : GoalDetail){
        
        contentView.backgroundColor = .mpWhite
        categoryIcon.image = UIImage(named: report.categoryIcon)
        categoryName.text = report.categoryName
        
        progressBar.changeUsedAmt(usedAmt: report.totalCost, goalAmt: report.categoryBudget)
        
        let color : UIColor = report.totalCost < report.categoryBudget ? .mpMainColor : .mpRed
        averageLabel.attributedText = makeLabelText(front: "평균적으로 ", middle: formatNumber(Int64(report.avgCost))+"원", end: " 결제했어요", color: color)
        mostConsumedLabel.attributedText = makeLabelText(front: "가장 많이 쓴 돈은 ", middle: formatNumber(Int64(report.maxCost))+"원", end: "이에요", color: color)
        
        updateSumAmountDisplay(report: report)
        
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
        verticalStack.spacing = 0
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: categoryIcon.bottomAnchor, constant: 25),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        progressBar.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func makeLabelText(front: String, middle: String, end: String, color: UIColor) -> NSAttributedString {
        let frontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpCharcoal]
        let middleAttributes = [NSAttributedString.Key.foregroundColor: color]
        let endAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mpCharcoal]
        
        let attributedString = NSMutableAttributedString(string: front, attributes: frontAttributes)
        attributedString.append(NSAttributedString(string: middle, attributes: middleAttributes))
        attributedString.append(NSAttributedString(string: end, attributes: endAttributes))
        
        return attributedString
    }
    
    //총금액 알려주는 구간 업데이트
    private func updateSumAmountDisplay(report : CategoryGoalReport) {
        let sumAmount = report.totalCost
        let formattedSumAmount = formatNumber(sumAmount)
        let goalBudget = report.categoryBudget
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
        leftAmountLabel.textColor = .mpCharcoal
        leftAmountLabel.font = .mpFont14B()
        
    }
    
    private func formatNumber(_ number: Int64) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // Use .decimal for formatting with commas.
        return numberFormatter.string(from: NSNumber(value: number)) ?? "0"
    }
}

