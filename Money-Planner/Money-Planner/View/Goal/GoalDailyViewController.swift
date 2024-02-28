//
//  GoalDailyViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/26/24.
//


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
        
        refreshAmountInfo(startDate: goalCreationManager.startDate!.toDate ?? Date(), endDate: goalCreationManager.endDate!.toDate ?? Date())
        
        customCalendarView.calendar.reloadData()
        
        if calculateTotalAmount(from: goalCreationManager.startDate!.toDate ?? Date(), to: goalCreationManager.endDate?.toDate ?? Date()) == goalCreationManager.goalBudget {
            btmBtn.isEnabled = true
        }else{
            btmBtn.isEnabled = false
        }
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
        
        if let start = goalCreationManager.startDate?.toDate, let end = goalCreationManager.endDate?.toDate {
            customCalendarView.setPeriod(startDate: start, endDate: end)
            initializeArray(start: start, end: end)
        }
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupWeekdayLabels()
        
        btmBtn.addTarget(self, action: #selector(btmButtonTapped), for: .touchUpInside)
        btmBtn.isEnabled = false
        
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
        let goalFinalVC = GoalFinalViewController()
        let budgets = convertToInt64Array(from: amountInfo)
        goalCreationManager.addDailyBudgets(budgets: budgets)
        navigationController?.pushViewController(goalFinalVC, animated: true)
    }
    
    
    ///calendar관련
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 예를 들어, 선택된 날짜에 대한 현재 금액을 가져옵니다. 실제 구현에서는 모델 또는 데이터 소스에서 이 값을 조회해야 합니다.
//        let currentTotalAmount = calculateEditedAmount(from: goalCreationManager.startDate?.toDate ?? Date(), to: goalCreationManager.endDate?.toDate ?? Date()),
        let currentTotalAmount = calculateTotalAmount(from: (goalCreationManager.startDate?.toDate)!, to: (goalCreationManager.endDate?.toDate)!)
        
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

    
    private func setupWeekdayLabels() {
        let calendarWeekdayView = customCalendarView.calendar.calendarWeekdayView
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        for (index, label) in calendarWeekdayView.weekdayLabels.enumerated() {
            label.text = weekdays[index]
            label.font = .mpFont14B()
        }
    }

    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    private func initializeArray(start: Date, end: Date) {
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
        let unedited = findAllTheUneditedDays()
        let editedsum = calculateEditedAmount(from: startDate, to: endDate)
        let distributingBudget = goalBudget! - editedsum
        
        if distributingBudget < 0 {
            //1/N 진행안됨.
            print("합이 너무 큼.")
        }else if distributingBudget == 0 {
            //0원 분배
            if unedited.count <= 1 { //한번씩은 다 수정이 되었다. 이제부터는 1/n 기능이 꺼진다. 이젠 금액이 넘어가는지만 체크한다.
                return
            }else{ //아직 수정이 다 안됐다. 1/N 지원!
                if (distributingBudget / Int64(unedited.count)) < 100 {
                    let distributingDays = distributingBudget/100
                    let remainder = distributingBudget%100
                    distribution(startDate: startDate, endDate: endDate, days: distributingDays, budget: 100, remainder: remainder, addToHead: false)
                }else{
                    //발생해선 안됨
                    print("error")
                }
            }
        }else{
            if unedited.count <= 1 { //한번씩은 다 수정이 되었다. 이제부터는 1/n 기능이 꺼진다.
                return
            }else{ //아직 수정이 다 안됐다. 1/N 지원!
                if (distributingBudget / Int64(unedited.count)) < 100 {
                    let distributingDays = distributingBudget/100
                    let remainder = distributingBudget%100
                    distribution(startDate: startDate, endDate: endDate, days: distributingDays, budget: 100, remainder: remainder, addToHead: false)
                }else{
                    let k = distributingBudget / Int64(unedited.count)
                    if k % 100 == 0 {
                        distribution(startDate: startDate, endDate: endDate, days: Int64(unedited.count), budget: k, remainder: 0, addToHead: true)
                    }else{
                        let remainderConstant = k%100
                        let budget = k - remainderConstant
                        let remainderMultiplier = Int64(unedited.count)
                        let remainder = remainderConstant * remainderMultiplier
                        distribution(startDate: startDate, endDate: endDate, days: Int64(unedited.count), budget: budget, remainder: remainder, addToHead: true)
                    }
                }
            }
        }
    }
    
//    func distribution(startDate: Date, endDate: Date, days : Int, budget : Int, remainder : Int, addToHead : Bool){
//        var firstAdded = false
//        var lastAdded = false
//        //while문으로 startDate ~ endDate 까지 돌면서
//        //isEdited[dateKey] = false 인 곳에 budget을 넣는다.
//        //addToHead가 true일때, firstAdded가 false라면 처음 넣는 날이다. remainder + budget를 더한다. firstAdded =true. days-=1
//        //addToHead가 true일때, firstAdded가 true라면 budget를 더한다. days-=1. 마지막에 days가 0이 되면 return
//        //addToHead가 false일때, days가 0이고, lastAdded == false면, remainder를 amountInfo[dateKey] 에 할당하고,
//        //addToHead가 false일때, days가 0이고, lastAdded == true면, amountInfo[dateKey]에 0을 할당.
//    }
    
    func distribution(startDate: Date, endDate: Date, days: Int64, budget: Int64, remainder: Int64, addToHead: Bool) {
        
        var firstAdded = false
        var lastAdded = false
        var currentDate = startDate
        var daysLeft = days
        
        while currentDate <= endDate {
            let dateString = formatDate(currentDate)
            
            // isEdited[dateKey] = false 인 경우 budget 할당
            if !isEdited[dateString]! {
//                amountInfo[dateString] = "\(budget)"
//                isEdited[dateString] = true
//                daysLeft -= 1
                
                if addToHead {
                    if !firstAdded {
                        let initialBudget = remainder + budget
                        amountInfo[dateString] = "\(initialBudget)"
                        firstAdded = true
                        daysLeft -= 1
                    } else {
                        amountInfo[dateString] = "\(budget)"
                        daysLeft -= 1
                        if daysLeft == 0 {
                            return
                        }
                    }
                }else{
                    if daysLeft == 0 && !lastAdded{
                        amountInfo[dateString] = "\(remainder)"
                        lastAdded = true
                    }
                    else if daysLeft == 0 && lastAdded {
                        amountInfo[dateString] = "0"
                    }
                    else if daysLeft > 0 {
                        amountInfo[dateString] = "\(budget)"
                        daysLeft -= 1
                    }
                    
                }
            }
            
            // endDate까지 도달한 경우 (사실 이 작업 의미 없을수도)
            if currentDate == endDate {
                lastAdded = true
            }
            
            // 다음 날짜로 이동
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
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
    
    func findAllTheUneditedDays() -> [String] {
        var uneditedDays: [String] = []
        // amountInfo 딕셔너리의 키들을 반복하여 uneditedDays 배열에 편집되지 않은 날짜를 추가합니다.
        for (dateKey, edited) in isEdited {
            if !edited {
                uneditedDays.append(dateKey)
            }
        }
        return uneditedDays
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
    
    func calculateEditedAmount(from startDate: Date, to endDate: Date) -> Int64 {
        var totalAmount: Int64 = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        if findAllTheUneditedDays().count == 1 {
            return calculateTotalAmount(from: startDate, to: endDate)
        }
        
        for (dateKey, value) in isEdited {
            if let date = dateFormatter.date(from: dateKey) {
                // startDate와 endDate 사이의 날짜에 대해서만 계산합니다.
                if date >= startDate && date <= endDate && value {
                    // 금액의 문자열에서 ','를 제거하고 Int64로 변환하여 총합에 더합니다.
                    let formattedValue = amountInfo[dateKey]?.replacingOccurrences(of: ",", with: "") ?? "0"
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
    
    func convertToInt64Array(from dict: [String: String]) -> [Int64] {
        var intArray: [Int64] = []
        
        for (_, value) in dict {
            // 쉼표를 제거하고 숫자로 변환하여 배열에 추가
            let numericValue = value.replacingOccurrences(of: ",", with: "")
            if let intValue = Int64(numericValue) {
                intArray.append(intValue)
            } else {
                // 숫자로 변환할 수 없는 경우 0으로 처리하거나 오류 처리
                // 여기서는 일단 0으로 처리합니다.
                intArray.append(0)
            }
        }
        
        return intArray
    }
}
