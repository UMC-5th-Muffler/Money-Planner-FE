//
//  ExpenseView.swift
//  Money-Planner
//
//  Created by 유철민 on 2/28/24.
//

import Foundation
import UIKit

// Protocol for handling actions within ExpenseView, like selecting an expense detail
protocol ExpenseViewDelegate: AnyObject {
    func navigateToDailyConsumeViewController(date: String, totalAmount: Int64)
}

class ExpenseView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: ExpenseViewDelegate?
    
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
    
    @objc private func filterButtonTapped() {
        tapFilterBtn?()
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = true
        table.separatorStyle = .none
        table.backgroundColor = .clear
        return table
    }()
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "소비내역이 없습니다."
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    var data: [DailyExpense] = [] {
        didSet {
            tableView.isHidden = data.isEmpty
            noDataLabel.isHidden = !data.isEmpty
            tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func update(with dailyExpenses: [DailyExpense]) {
        self.data = dailyExpenses
    }
    
    private func setupUI() {
        
        addSubview(filterBtn)
        addSubview(tableView)
        addSubview(noDataLabel)
        
        filterBtn.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        
        // 필터 버튼 및 테이블뷰의 오토레이아웃 설정을 여기에 추가하세요.
        NSLayoutConstraint.activate([
            filterBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            filterBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 22),
            
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: filterBtn.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            noDataLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ConsumeRecordCell.self, forCellReuseIdentifier: "ConsumeRecordCell")
        
        backgroundColor = .mpWhite
    }
    
    // MARK: UITableViewDataSource
    
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
        let expenseDetail = data[indexPath.section].expenseDetailList[indexPath.row]
        cell.configure(with: expenseDetail)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedExpense = data[indexPath.section].expenseDetailList[indexPath.row]
//        delegate?.didSelectExpenseDetail(expenseId: Int64(selectedExpense.expenseId))
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 // Adjust the height as needed
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .mpWhite // Customize the background color
        
        let separatorView = UIView()
        separatorView.backgroundColor = .mpGypsumGray // Customize separator color
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(separatorView)
        
        let label = UILabel()
        label.font = .mpFont14M() // Customize the font
        label.textColor = UIColor(hexCode: "9FAAB0") // Customize the text color
        label.text = data[section].date.toDate?.toString(format: "yyyy.MM.dd") // Use your date format
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        let totalCostButton = UIButton(type: .system)
        let dateText = data[section].date.toDate?.toString(format: "yyyy년 MM월 dd일") ?? "Unknown Date"
        totalCostButton.setTitle("\(setComma(cash: data[section].dailyTotalCost))원", for: .normal)
        totalCostButton.setImage(UIImage(named : "btn_arrow"), for: .normal)
        totalCostButton.tintColor = .mpDarkGray
        totalCostButton.contentHorizontalAlignment = .right
        totalCostButton.semanticContentAttribute = .forceRightToLeft
        totalCostButton.setTitleColor(.mpDarkGray, for: .normal)
        totalCostButton.titleLabel?.font = .mpFont14M()
        totalCostButton.imageView?.contentMode = .scaleAspectFit // Set image content mode
        totalCostButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
        totalCostButton.translatesAutoresizingMaskIntoConstraints = false
        // Store the section date in the accessibilityIdentifier for retrieval in the action method
        totalCostButton.accessibilityIdentifier = dateText
        totalCostButton.addTarget(self, action: #selector(tappedDailyConsumeBtn(sender:)), for: .touchUpInside)
        headerView.addSubview(totalCostButton)
        
        
        // Constraints for separatorView
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // Constraints for label
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        // Constraints for totalCostButton
        NSLayoutConstraint.activate([
            totalCostButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            totalCostButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            totalCostButton.widthAnchor.constraint(equalToConstant: 100) // Adjust width as needed
        ])
        
        return headerView
    }

    private func setComma(cash: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: cash)) ?? ""
    }
    
//    @objc func handleHeaderTap(_ gesture: UITapGestureRecognizer) {
//        guard let section = gesture.view?.tag else { return }
//        let date = data[section].date.toDate?.toString(format: "yyyy.MM.dd") ?? "Unknown Date"
//        delegate?.didTapSectionHeader(date: date)
//    }
//    
//    func didTapSectionHeader(date: String) {
//        print(date) // Now prints the date of the tapped section header
//    }
    
//    @objc func tappedDailyConsumeBtn(sender: UIButton) {
//        if let date = sender.accessibilityIdentifier {
//            // Assuming you have access to calculate or retrieve the total amount for the given date.
//            // For demonstration, I'm using a placeholder value. You should replace this with your actual total amount calculation or retrieval logic.
//            let totalAmount = Int64(sender.currentTitle)! // Your logic to get the total amount for this date
//            delegate?.navigateToDailyConsumeViewController(date: date, totalAmount: totalAmount)
//        }
//    }
    
    @objc func tappedDailyConsumeBtn(sender: UIButton) {
        if let dateIdentifier = sender.accessibilityIdentifier?.toDate?.toString(),
           let sectionIndex = data.firstIndex(where: { $0.date == dateIdentifier }) {
            let totalAmount = data[sectionIndex].dailyTotalCost
            delegate?.navigateToDailyConsumeViewController(date: dateIdentifier, totalAmount: totalAmount)
        }else {
            print("Date unknown or section not found")
            return
        }
    }
}
