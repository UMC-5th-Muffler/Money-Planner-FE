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
    func didRequestToFetchMoreData()
}


class ExpenseView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: ExpenseViewDelegate?
    var isEnabled = true
    
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
    
    let tableView: UITableView = {
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
        tableView.register(ConsumeRecordPagingCell.self, forCellReuseIdentifier: "ConsumeRecordPagingCell")
        
        backgroundColor = .mpWhite
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data[section].expenseDetailList.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 마지막 섹션인 경우, '더보기' 셀을 위해 행의 수를 1 증가
        if section == data.count - 1 {
            return data[section].expenseDetailList.count + 1 // +1 for the paging cell
        }
        return data[section].expenseDetailList.count
    }

    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConsumeRecordCell", for: indexPath) as? ConsumeRecordCell else {
//            fatalError("Unable to dequeue ConsumeRecordCell")
//        }
//        let expenseDetail = data[indexPath.section].expenseDetailList[indexPath.row]
//        cell.configure(with: expenseDetail)
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 마지막 섹션의 마지막 행인지 확인
        if indexPath.section == data.count - 1 && indexPath.row == data[indexPath.section].expenseDetailList.count {
            // ConsumeRecordPagingCell 반환
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConsumeRecordPagingCell", for: indexPath) as? ConsumeRecordPagingCell else {
                fatalError("Unable to dequeue ConsumeRecordPagingCell")
            }
            cell.configure(isEnabled: GoalDetailViewModel.shared.hasNext) // isFetchingMore 상태에 따라 버튼 활성화
//            cell.onAddButtonTapped = self.delegate?.didRequestToFetchMoreData
            cell.onAddButtonTapped = { [weak self] in
                        self?.delegate?.didRequestToFetchMoreData()
                    }
            return cell
        }

        // 기존의 ConsumeRecordCell 반환 로직
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
        label.text = data[section].date.toDate?.toString(format: "yyyy년 MM월 dd일") // Use your date format
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        let totalCostButton = UIButton(type: .system)
        let dateText = data[section].date //.toDate?.toString(format: "yyyy-MM-dd")
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
        totalCostButton.addTarget(self, action: #selector(tappedDailyConsumeBtn(sender: )), for: .touchUpInside)
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
            totalCostButton.widthAnchor.constraint(equalToConstant: 200) // Adjust width as needed
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
        if let dateIdentifier = sender.accessibilityIdentifier,
           let sectionIndex = data.firstIndex(where: { $0.date == dateIdentifier }) {
            let totalAmount = data[sectionIndex].dailyTotalCost
            delegate?.navigateToDailyConsumeViewController(date: dateIdentifier, totalAmount: totalAmount)
        }else {
            print("Date unknown or section not found")
            return
        }
    }
}


class ConsumeRecordPagingCell: UITableViewCell {

    var onAddButtonTapped: (() -> Void)?
    
    @objc private func addButtonAction() {
        onAddButtonTapped?()
    }
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("아래로 스와이프하여 더보기", for: .normal)
        button.setTitleColor(.mpGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(ConsumeRecordPagingCell.self, action: #selector(addButtonAction), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            moreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            moreButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            moreButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
    
    func configure(isEnabled: Bool) {
        moreButton.isEnabled = isEnabled
        if isEnabled {
            moreButton.setTitle("아래로 스와이프하여 더보기", for: .normal)
        } else {
            moreButton.setTitle("마지막입니다", for: .disabled)
        }
    }
}


extension ExpenseView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 스크롤 뷰의 현재 오프셋, 콘텐츠 높이, 뷰 높이를 가져옵니다.
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // 사용자가 스크롤 뷰의 맨 아래 근처에 도달했는지 확인합니다.
        // 'threshold' 값은 더 일찍 데이터 로딩을 시작하고 싶을 때 조절할 수 있습니다.
        let threshold = CGFloat(100.0) // 필요에 따라 조절 가능
        if currentOffset > maximumOffset - threshold {
            // 맨 아래에 도달했을 때의 액션을 실행합니다.
            delegate?.didRequestToFetchMoreData()
            print("aaaa")
        }
    }
}
