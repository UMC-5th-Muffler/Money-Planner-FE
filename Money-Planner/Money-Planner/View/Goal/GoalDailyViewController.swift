//
//  GoalDailyViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/26/24.
//


//import Foundation
//import UIKit
//
//class GoalDailyViewController: UIViewController, DayGoalMonthViewDelegate {
//
//    private let header = HeaderView(title: "")
//    private let descriptionView = DescriptionView(text: "하루하루의 목표금액을\n조정해주세요", alignToCenter: false)
//    private let subdescriptionView = SubDescriptionView(text: "일정에 맞게 일일 목표 금액을 변경하면\n나머지 금액은 1/n 해드릴게요", alignToCenter: false)
//    private let btmBtn = MainBottomBtn(title: "다음")
//
//    private let goalCreationManager = GoalCreationManager.shared
//
//    let monthView: DayGoalMonthView = {
//        let v = DayGoalMonthView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
//
//    let calendarView: DayGoalCalendarView = {
//        let v = DayGoalCalendarView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        monthView.delegate = self
//
//        setupViews()
//        setupConstraints()
//
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = nil
//
//        header.addBackButtonTarget(target: self, action: #selector(backButtonTapped), for: .touchUpInside)
//        btmBtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
//
//        self.tabBarController?.tabBar.isHidden = true
//    }
//
//    private func setupViews() {
//        // Add subviews to the view hierarchy
//        view.addSubview(header)
//        view.addSubview(descriptionView)
//        view.addSubview(subdescriptionView)
//        view.addSubview(monthView)
//        view.addSubview(calendarView)
//        view.addSubview(btmBtn)
//    }
//
//    private func setupConstraints() {
//        // Disable autoresizing mask translation for all subviews
//        header.translatesAutoresizingMaskIntoConstraints = false
//        descriptionView.translatesAutoresizingMaskIntoConstraints = false
//        subdescriptionView.translatesAutoresizingMaskIntoConstraints = false
//        // monthView and calendarView are already set to false
//        btmBtn.translatesAutoresizingMaskIntoConstraints = false
//
//        // Set up constraints for all subviews
//        NSLayoutConstraint.activate([
//            // Header constraints
//            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            header.heightAnchor.constraint(equalToConstant: 60),
//
//            // DescriptionView constraints
//            descriptionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20),
//            descriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            descriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//
//            // SubDescriptionView constraints
//            subdescriptionView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 10),
//            subdescriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            subdescriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//
//            // MonthView constraints
//            monthView.topAnchor.constraint(equalTo: subdescriptionView.bottomAnchor, constant: 20),
//            monthView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            monthView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            monthView.heightAnchor.constraint(equalToConstant: 46),
//
//            // CalendarView constraints
//            calendarView.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 5),
//            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            calendarView.bottomAnchor.constraint(equalTo: btmBtn.topAnchor, constant: -30),
//
//            // btmBtn constraints
//            btmBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            btmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            btmBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
//            btmBtn.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//
//    @objc private func backButtonTapped() {
//        // Navigate back
//        navigationController?.popViewController(animated: true)
//    }
//
//    @objc private func btmButtonTapped() {
//        // Navigate to the next screen
//        let goalFinalVC = GoalFinalViewController() // Assume GoalFinalViewController exists
//        navigationController?.pushViewController(goalFinalVC, animated: true)
//    }
//
//    func didChangeMonth(monthIndex: Int, year: Int) {
//        calendarView.changeMonth(monthIndex: monthIndex, year: year)
//    }
//}

import Foundation
import UIKit
import FSCalendar

extension GoalDailyViewController: GoalAmountModalViewControllerDelegate {
    func didChangeAmount(to newAmount: String, for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateKey = dateFormatter.string(from: date)
        
        // Update the amountInfo dictionary and reload the calendar
        amountInfo[dateKey] = newAmount
        isEdited[dateKey] = true
        
        customCalendarView.calendar.reloadData()
    }
}

class GoalDailyViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    private let descriptionView = DescriptionView(text: "하루하루의 목표금액을\n조정해주세요", alignToCenter: false)
    private let subdescriptionView = SubDescriptionView(text: "일정에 맞게 일일 목표 금액을 변경하면\n나머지 금액은 1/n 해드릴게요", alignToCenter: false)
    private let btmBtn = MainBottomBtn(title: "다음")
    
    private let goalCreationManager = GoalCreationManager.shared
    
    var isEdited: [String: Bool] = [:]
    var amountInfo: [String: String] = [:]
    
    var customCalendarView: CustomCalendarView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // CustomCalendarView 인스턴스 생성 및 뷰에 추가
        customCalendarView = CustomCalendarView()
        customCalendarView.calendar.delegate = self
        customCalendarView.calendar.dataSource = self
        customCalendarView.translatesAutoresizingMaskIntoConstraints = false // Auto Layout 사용 설정
        view.addSubview(customCalendarView)
        
        if let start = goalCreationManager.startDate?.toMPDate(), let end = goalCreationManager.endDate?.toMPDate() {
            customCalendarView.setPeriod(startDate: start, endDate: end)
        }
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupWeekdayLabels()
        
        btmBtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonTapped))
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .medium)
        backButton.image = UIImage(systemName: "chevron.left", withConfiguration: config)
        backButton.tintColor = .mpBlack
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupViews() {
        view.addSubview(descriptionView)
        view.addSubview(subdescriptionView)
        view.addSubview(customCalendarView)
        view.addSubview(btmBtn)
    }
    
    private func setupConstraints() {
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        subdescriptionView.translatesAutoresizingMaskIntoConstraints = false
        btmBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            descriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            subdescriptionView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 10),
            subdescriptionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            subdescriptionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            customCalendarView.topAnchor.constraint(equalTo: subdescriptionView.bottomAnchor, constant: 20),
            customCalendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            customCalendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            customCalendarView.bottomAnchor.constraint(equalTo: btmBtn.topAnchor, constant: -30),
            
            btmBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            btmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            btmBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            btmBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func btmButtonTapped() {
        let goalFinalVC = GoalFinalViewController() // 가정: GoalFinalViewController가 존재함
        navigationController?.pushViewController(goalFinalVC, animated: true)
    }
    
    
    ///calendar관련
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 예를 들어, 선택된 날짜에 대한 현재 금액을 가져옵니다. 실제 구현에서는 모델 또는 데이터 소스에서 이 값을 조회해야 합니다.
        let currentTotalAmount = calculateTotalAmount(from: (goalCreationManager.startDate?.toMPDate(format: "yyyy/MM/dd"))!, to: (goalCreationManager.endDate?.toMPDate(format: "yyyy/MM/dd"))!)
        presentEditModal(for: date, with: currentTotalAmount)
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let dateString = formatDate(date)
        if let startDate = customCalendarView.startDate, let endDate = customCalendarView.endDate,
           date >= startDate && date <= endDate {
            
            
            let currentYear = Calendar.current.component(.year, from: calendar.currentPage)
            let currentMonth = Calendar.current.component(.month, from: calendar.currentPage)
            let dateYear = Calendar.current.component(.year, from: date)
            let dateMonth = Calendar.current.component(.month, from: date)
            
            if currentMonth == dateMonth && currentYear == dateYear {
                return .mpGray // Dates in the current month
            }else {
                return .mpBlack // Your custom color for edited dates
            }
            
        }
        return .mpMidGray
    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "customCell", for: date, at: position) as! CustomFSCalendarCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateKey = dateFormatter.string(from: date)
        
        // startDate와 endDate 사이의 날짜에 대해서만 금액 정보 표시 및 이미지 설정
        if let startDate = customCalendarView.startDate, let endDate = customCalendarView.endDate,
           date >= startDate && date <= endDate {
            cell.configureBackgroundImage(image: UIImage(named: "btn_date_on"))
            cell.configureImageSize(CGSize(width: 30, height: 30)) // 이미지 크기 조정
            // 금액 정보가 있는 경우 해당 금액을 표시
            if let amount = amountInfo[dateKey] {
                cell.configureAmountText(amount)
            } else {
                // 금액 정보가 없는 경우 빈 문자열로 설정
                cell.configureAmountText("")
            }
        } else {
            cell.configureBackgroundImage(image: nil)
            cell.configureAmountText("") // 금액 정보 없는 경우 빈 문자열로 설정
        }
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        guard let startDate = customCalendarView.startDate, let endDate = customCalendarView.endDate else {
            return false
        }
        
        // 오직 startDate와 endDate 사이의 날짜만 선택 가능하게 함
        return date >= startDate && date <= endDate
    }
    
    
    func presentEditModal(for date: Date, with currentAmount: Int64) {
        // Create an instance of GoalAmountModalViewController
        let goalAmountModalVC = GoalAmountModalViewController()
        
        // Configure the properties of the modal
        goalAmountModalVC.modalPresentationStyle = .pageSheet
        goalAmountModalVC.modalTransitionStyle = .crossDissolve
        goalAmountModalVC.delegate = self
        goalAmountModalVC.date = date
        goalAmountModalVC.currentTotalAmount = currentAmount
        
        // Present the modal
        self.present(goalAmountModalVC, animated: true, completion: nil)
    }
    
    private func refreshAmountInfo(startDate : Date, endDate : Date) {
        
        let goalBudget = GoalCreationManager.shared.goalBudget
        var sum = calculateTotalAmount(from: startDate, to: endDate)
        
        if goalBudget ?? 0 > sum {
            btmBtn.isEnabled = false
            
            //isEdited를 읽어서 value가 false인 녀석들만 key를 모아 여기에서 만든 배열에 저장. 이 날짜에만 goalBudget - sum 을 분배한다.
            // 이를 분배하는 로직 :
            
        }else if goalBudget == sum{
            btmBtn.isEnabled = true
        }else{
            btmBtn.isEnabled = false
            
        }
        
        var currentDate = startDate
        let calendar = Calendar.current
        while currentDate <= endDate {
            let dateString = formatDate(currentDate)
            amountInfo[dateString] = "0"
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
    }
    
    func updateAmount(for date: Date, with text: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let dateKey = dateFormatter.string(from: date)
        
        // startDate와 endDate 사이의 날짜에 대해서만 업데이트를 허용합니다.
        if let startDate = customCalendarView.startDate, let endDate = customCalendarView.endDate,
           date >= startDate && date <= endDate {
            amountInfo[dateKey] = text
            
            // 필요한 경우 캘린더 뷰를 업데이트합니다.
            customCalendarView.calendar.reloadData()
        } else {
            print("날짜는 startDate와 endDate 사이여야 합니다.")
        }
    }
    
    func calculateTotalAmount(from startDate: Date, to endDate: Date) -> Int64 {
        var totalAmount: Int64 = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        for (dateKey, value) in amountInfo {
            if let date = dateFormatter.date(from: dateKey) {
                // startDate와 endDate 사이의 날짜에 대해서만 계산합니다.
                if date >= startDate && date <= endDate {
                    // 금액의 문자열에서 ','를 제거하고 Int64로 변환하여 총합에 더합니다.
                    let formattedValue = value.replacingOccurrences(of: ",", with: "")
                    if let amount = Int64(formattedValue) {
                        totalAmount += amount
                    } else {
                        print("잘못된 형식의 금액입니다: \(value)")
                    }
                }
            } else {
                print("잘못된 날짜 형식입니다: \(dateKey)")
            }
        }
        
        return totalAmount
    }

    
    private func setupWeekdayLabels() {
        let calendarWeekdayView = customCalendarView.calendar.calendarWeekdayView
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        for (index, label) in calendarWeekdayView.weekdayLabels.enumerated() {
            label.text = weekdays[index]
            label.font = .mpFont14B()
        }
    }
    
    private func initializeIsEdited(start: Date, end: Date) {
        var currentDate = start
        let calendar = Calendar.current
        while currentDate <= end {
            let dateString = formatDate(currentDate)
            isEdited[dateString] = false
            amountInfo[dateString] = "0"
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        refreshAmountInfo(startDate: start, endDate: end)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
}
