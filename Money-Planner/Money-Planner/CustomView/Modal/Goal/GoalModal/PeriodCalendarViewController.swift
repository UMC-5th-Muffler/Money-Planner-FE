//
//  PeriodCalendarViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 2/5/24.
//

import Foundation
import UIKit
import RxSwift
import FSCalendar

//기간 선택 프로토콜 정의
protocol PeriodSelectionDelegate: AnyObject {
    func periodSelectionDidSelectDates(startDate: Date, endDate: Date)
}

//선택된 날짜의 배경색 설정
extension PeriodCalendarModal: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .mpMainColor
    }
}

class PeriodCalendarModal: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    weak var delegate: PeriodSelectionDelegate?
    private let goalPeriodViewModel = GoalPeriodViewModel.shared //지금까지 만든 목표 확인용
    private let disposeBag = DisposeBag()
    
    // 구성요소
    let customModal = UIView()
    let grabber : UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .mpLightGray
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    let titleLabel: MPLabel = {
        let label = MPLabel()
        label.text = "시작일을 선택해주세요"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let subTitleLabel: MPLabel = {
        let label = MPLabel()
        label.text = "-"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    
    //picker 관련
    //    var pickerView: UIPickerView!
    //    var years: [Int] = []
    //    var months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    //completeBtn
    let completeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .mpGray
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    @objc func didTapCompleteButton() {
        print(startDate)
        print(endDate)
        if let start = startDate, let end = endDate {
            delegate?.periodSelectionDidSelectDates(startDate: start, endDate: end)
        }
        dismiss(animated: true, completion: nil)
    }
    
    //calendar 관련
    var calendar: FSCalendar!
    var startDate: Date?
    var endDate: Date?
    
    var unselectableDateRanges: [[Date]] = []
    
    let headerStackView = UIStackView()
    
    let monthButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        let scaledImage = image?.resizeImage(size: CGSize(width: 15, height: 15)) // Set your desired height
        button.setImage(scaledImage, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft // To make the image appear on the right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.tintColor = UIColor(hexCode: "6C6C6C")
        button.addTarget(self, action: #selector(monthButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let navigationStackView = UIStackView()
    let previousButton = UIButton()
    let nextButton = UIButton()
    
    
    let oneWeekButton : UIButton = createDurationButton(title: "1주")
    let twoWeeksButton : UIButton = createDurationButton(title: "2주")
    let oneMonthButton : UIButton = createDurationButton(title: "한 달")
    let selectTodayButton: UIButton = {
        let button = UIButton()
        let titleString = NSAttributedString(
            string: "오늘 선택하기",
            attributes: [
                .font: UIFont.mpFont14R(),
                .foregroundColor: UIColor.mpBlack,
                .underlineStyle: NSUnderlineStyle.single.rawValue // 밑줄 넣기 위함
            ]
        )
        button.setAttributedTitle(titleString, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.backgroundColor = .clear
        return button
    }()
    
    // Function to create duration buttons
    private static func createDurationButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.mpBlack, for: .normal)
        button.backgroundColor = .mpGypsumGray
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mpLightGray.cgColor
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // Define the stack view to hold the duration buttons
    let durationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    var containerView : UIView?
    
    private func setupDurationButtons() {
        // Add buttons to the stack view
        durationStackView.addArrangedSubview(oneWeekButton)
        durationStackView.addArrangedSubview(twoWeeksButton)
        durationStackView.addArrangedSubview(oneMonthButton)
        
        // Set button actions
        oneWeekButton.addTarget(self, action: #selector(selectOneWeek), for: .touchUpInside)
        twoWeeksButton.addTarget(self, action: #selector(selectTwoWeeks), for: .touchUpInside)
        oneMonthButton.addTarget(self, action: #selector(selectOneMonth), for: .touchUpInside)
        selectTodayButton.addTarget(self, action: #selector(selectToday), for: .touchUpInside)
    }
    
    // Button action methods
    @objc func selectOneWeek() {
        endDate = nil
        if startDate != nil {
            let day = Calendar.current.date(byAdding: .day, value: 6, to: startDate!)!
            selectDate(day)
            calendar.setCurrentPage(day, animated: true)
        }
    }
    
    @objc func selectTwoWeeks() {
        endDate = nil
        if startDate != nil {
            let day = Calendar.current.date(byAdding: .day, value: 13, to: startDate!)!
            selectDate(day)
            calendar.setCurrentPage(day, animated: true)
        }
    }
    
    @objc func selectOneMonth() {
        endDate = nil
        if startDate != nil {
            let day = Calendar.current.date(byAdding: .month, value: 1, to: startDate!)!
            let day2 = Calendar.current.date(byAdding: .day, value: -1, to: day)!
            selectDate(day2)
            calendar.setCurrentPage(day2, animated: true)
        }
    }
    
    @objc func selectToday() {
        selectDate(getTodayDate())
        calendar.setCurrentPage(Date(), animated: true)
    }
    
    func getTodayDate() -> Date {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        return calendar.date(from: components) ?? currentDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear // Replace with .mpWhite if it's a custom color in your project
        setupHeaderStackView()
        setupCalendar()
        completeBtn.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        setupLayoutConstraints()
        updateMonthLabelForDate(Date())
        setupDurationButtons()
        
        goalPeriodViewModel.previousGoalTerms
            .asObservable()
            .subscribe(onNext: { [weak self] terms in
                self?.updateUnselectableDateRanges(with: terms)
            })
            .disposed(by: disposeBag)
    }
    
    //요일 폰트 및 텍스트 반영
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupWeekdayLabels()
    }
    
    private func setupWeekdayLabels() {
        let calendarWeekdayView = calendar.calendarWeekdayView
        let weekdays = ["SUN", "MON", "TUE", "WED", "THR", "FRI", "SAT"]
        for (index, label) in calendarWeekdayView.weekdayLabels.enumerated() {
            label.text = weekdays[index]
            label.font = UIFont(name: "SFProText-Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 13)
        }
    }
    
    //픽커 내리는 용도
    @objc func dismissDatePicker() {
        UIView.animate(withDuration: 0.3, animations: {
            // Fade the background color to fully opaque
            self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(1)
            // Optionally, you can animate the containerView to fade out or move
            self.containerView?.alpha = 0
        }) { _ in
            // After the animation completes, remove the containerView from the view hierarchy
            self.containerView?.removeFromSuperview()
        }
    }
    
    //날짜 변경 반영
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        // Update the title of the monthButton with the selected month and year
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        monthButton.setTitle(dateString, for: .normal)
        calendar.setCurrentPage(datePicker.date, animated: true)
    }
    
    func setupHeaderStackView() {
        
        let image = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        let scaledImage = image?.resizeImage(size: CGSize(width: 40, height: 40))
        previousButton.setImage(image, for: .normal)
        previousButton.tintColor = UIColor(hexCode: "6C6C6C")
        previousButton.addTarget(self, action: #selector(goToPreviousMonth), for: .touchUpInside)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        
        let image2 = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        let scaledImage2 = image2?.resizeImage(size: CGSize(width: 40, height: 40))
        nextButton.setImage(image2, for: .normal)
        nextButton.tintColor = UIColor(hexCode: "6C6C6C")
        nextButton.addTarget(self, action: #selector(goToNextMonth), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Setup navigation stack view
        navigationStackView.axis = .horizontal
        navigationStackView.distribution = .fillEqually
        navigationStackView.addArrangedSubview(previousButton)
        navigationStackView.addArrangedSubview(nextButton)
        
        // Setup the main header stack view
        headerStackView.axis = .horizontal
        headerStackView.distribution = .equalSpacing
        headerStackView.addArrangedSubview(monthButton)
        headerStackView.addArrangedSubview(navigationStackView)
        
        
        NSLayoutConstraint.activate([
            previousButton.widthAnchor.constraint(equalToConstant: 40),
            previousButton.heightAnchor.constraint(equalToConstant: 40),
            nextButton.widthAnchor.constraint(equalToConstant: 40),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            navigationStackView.centerYAnchor.constraint(equalTo: headerStackView.centerYAnchor),
            navigationStackView.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor),
            navigationStackView.heightAnchor.constraint(equalToConstant: 40),
            navigationStackView.widthAnchor.constraint(equalToConstant: 51)
        ])
        
    }
    
    func setupCalendar() {
        calendar = FSCalendar()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.todayColor = .clear //일단 모두 날리고
        calendar.headerHeight = 0 //헤더 감추고 커스텀 헤더 넣기 위해서
        calendar.appearance.weekdayTextColor = .mpGray //요일 회색으로
        calendar.appearance.titlePlaceholderColor = .clear //안보여야 하는 녀석들
        calendar.appearance.weekdayFont = UIFont(name: "SFProText-Bold", size: 14) ?? .mpFont14B()
        calendar.appearance.titleFont = UIFont(name: "SFProDisplay-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)
        calendar.rowHeight = 52 // 높이 조절
    }
    
    private func setupLayoutConstraints() {
        
        view.addSubview(customModal)
        view.addSubview(grabber)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(completeBtn)
        view.addSubview(headerStackView)
        view.addSubview(calendar)
        view.addSubview(durationStackView)
        view.addSubview(selectTodayButton)
        // Assuming customModal is a container view that holds all your subviews
        
        customModal.backgroundColor = .mpWhite
        customModal.layer.cornerRadius = 25
        customModal.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customModal.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            customModal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customModal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customModal.heightAnchor.constraint(equalToConstant: 616)
        ])
        
        grabber.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        completeBtn.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        calendar.translatesAutoresizingMaskIntoConstraints = false
        selectTodayButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            grabber.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 12),
            grabber.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            grabber.widthAnchor.constraint(equalToConstant: 49),
            grabber.heightAnchor.constraint(equalToConstant: 4),
        ])
        
        // Constraints for titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: grabber.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24)
        ])
        
        // Constraints for subTitleLabel
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subTitleLabel.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 20),
            subTitleLabel.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -20),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 23)
        ])
        
        // Constraints for headerStackView
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 20),
            headerStackView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            headerStackView.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24)
        ])
        
        // Constraints for calendar
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
            calendar.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 15),
            calendar.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -15),
            calendar.heightAnchor.constraint(equalToConstant: 300) // Adjust height as necessary
        ])
        
        NSLayoutConstraint.activate([
            durationStackView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            durationStackView.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            durationStackView.widthAnchor.constraint(equalToConstant: 270),
            durationStackView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        // Constraints for doneButton
        NSLayoutConstraint.activate([
            completeBtn.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -20),
            completeBtn.leadingAnchor.constraint(equalTo: customModal.centerXAnchor, constant: 24),
            completeBtn.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -24),
            completeBtn.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        
        // Constraints for selectTodayButton
        NSLayoutConstraint.activate([
            selectTodayButton.centerYAnchor.constraint(equalTo: completeBtn.centerYAnchor),
            selectTodayButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            selectTodayButton.widthAnchor.constraint(equalToConstant: 80),
            selectTodayButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        grabber.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if translation.y > 0 { // Dismiss only on dragging down
            view.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }
        
        if gesture.state == .ended {
            let velocity = gesture.velocity(in: view)
            if velocity.y >= 1500 { // If the speed of dragging is high enough, dismiss
                self.dismiss(animated: true)
            } else {
                // Return to original position
                UIView.animate(withDuration: 0.3) {
                    self.view.transform = .identity
                }
            }
        }
    }
    
    
    @objc func goToPreviousMonth() {
        let currentPage = calendar.currentPage
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentPage)!
        calendar.setCurrentPage(previousMonth, animated: true)
    }
    
    @objc func goToNextMonth() {
        let currentPage = calendar.currentPage
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentPage)!
        calendar.setCurrentPage(nextMonth, animated: true)
    }
    
    func updateMonthLabelForDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy "
        monthButton.setTitle(dateFormatter.string(from: date), for: .normal)
        monthButton.titleLabel?.textColor = UIColor(hexCode: "6C6C6C")
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateMonthLabelForDate(calendar.currentPage)
    }
    
    // MARK: - FSCalendar Delegate Methods
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        // This method can be left empty if deselection is not needed
    }
    
    private func selectDate(_ date: Date) {
        
        if startDate != nil && endDate == nil && startDate == date {
            changeLabelWithAnimation(titleLabel, to: "시작일을 선택해주세요")
            changeLabelWithAnimation(subTitleLabel, to: "하루치 목표는 설정 불가능합니다.")
            subTitleLabel.textColor = .mpRed
            clearSelectedDates()
            completeBtn.isEnabled = false
            completeBtn.backgroundColor = .mpGray
            calendar.reloadData()
            return
        }
        
        if startDate == nil || endDate != nil || date < startDate! {
            // Start a new selection range
            startDate = date
            endDate = nil // Clear previous end date
            if endDate == nil {
                changeLabelWithAnimation(titleLabel, to: "종료일을 선택해주세요")
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                changeLabelWithAnimation(subTitleLabel, to: "\(dateFormatter.string(from: date)) - ")
            }
            subTitleLabel.textColor = .mpBlack
            completeBtn.isEnabled = false
            completeBtn.backgroundColor = .mpGray
            
        } else if let start = startDate, date > start {
            // Set end date and ensure it does not conflict with unselectable ranges
            if !isDateInRange(date, conflictingWith: unselectableDateRanges) {
                if !isRangeInRange(startDate: startDate!, endDate: date, unselectableRanges: unselectableDateRanges){
                    endDate = date
                    if let start = startDate, let end = endDate {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .none
                        changeLabelWithAnimation(titleLabel, to: "목표 기간")
                        changeLabelWithAnimation(subTitleLabel, to: "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))")
                        completeBtn.isEnabled = true
                        completeBtn.backgroundColor = .mpMainColor
                    }
                    subTitleLabel.textColor = .mpBlack
                }else{
                    changeLabelWithAnimation(titleLabel, to: "시작일을 선택해주세요")
                    changeLabelWithAnimation(subTitleLabel, to: "이미 존재하는 목표의 기간과 겹칩니다.")
                    subTitleLabel.textColor = .mpRed
                    clearSelectedDates()
                    completeBtn.isEnabled = false
                    completeBtn.backgroundColor = .mpGray
                }
            } else {
                //사실 이미 막아놓아서 이건 굳이 필요없긴 함.
                changeLabelWithAnimation(titleLabel, to: "시작일을 선택해주세요")
                changeLabelWithAnimation(subTitleLabel, to: "이미 존재하는 목표의 기간과 겹칩니다.")
                subTitleLabel.textColor = .mpRed
                clearSelectedDates()
                completeBtn.isEnabled = false
                completeBtn.backgroundColor = .mpGray
                print("End date selection conflicts with unselectable dates.")
                return // Exit without setting end date
            }
        }
        
        // After updating the dates, reload the calendar to refresh appearance
        calendar.reloadData()
    }
    
    private func selectDatesBetweenStartAndEnd() {
        guard let startDate = startDate, let endDate = endDate, startDate < endDate else { return }
        
        var currentDate = startDate
        while currentDate <= endDate {
            calendar.select(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        print("기간 선택 완료!")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate(date)
    }
    
    func isDateInRange(_ date: Date, conflictingWith unselectableRanges: [[Date]]) -> Bool {
        for range in unselectableRanges {
            if let start = range.first, let end = range.last, (start...end).contains(date) {
                return true
            }
        }
        return false
    }
    
    func isRangeInRange(startDate: Date, endDate: Date, unselectableRanges: [[Date]]) -> Bool {
        for range in unselectableRanges {
            if let unselectableStart = range.first, let unselectableEnd = range.last {
                if (startDate...endDate).overlaps(unselectableStart...unselectableEnd) {
                    // There is an overlap with unselectable ranges
                    return true
                }
            }
        }
        // No overlap with unselectable ranges
        return false
    }
    
    private func clearSelectedDates() {
        calendar.selectedDates.forEach { calendar.deselect($0) }
        startDate = nil
        endDate = nil
        // Reload calendar to refresh appearance after clearing selections
        calendar.reloadData()
    }
    
    //이미 선택된 date를 클릭해서 해제할 수 없음.
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }
    
    
    //날짜 배경색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        guard let start = startDate, let end = endDate else {
            // If only one date is selected, check if it's the start or end date and color it accordingly.
            if let startDate = startDate, date == startDate {
                return .mpMainColor
            }
            return nil // No special coloring for other dates
        }
        
        if date == start || date == end {
            // Start and end dates have the mpMainColor
            calendar.appearance.titleFont = UIFont(name: "SFProDisplay-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)
            return .mpMainColor
        } else if date > start && date < end {
            // Dates in between have the mpCalendarHighLight color
            return .mpCalendarHighLight
        }
        return nil
    }
    
    //날짜 글자 색
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
//        //placeholder는 안보이도록 한다.
//        self.calendar.appearance.titlePlaceholderColor = .clear
        
        //현재달의 오늘 날짜를 특수 표시
        
//        let currentYear = Calendar.current.component(.year, from: calendar.currentPage)
        let currentMonth = Calendar.current.component(.month, from: calendar.currentPage)
//        let dateYear = Calendar.current.component(.year, from: date)
        let dateMonth = Calendar.current.component(.month, from: date)
        
        if Calendar.current.isDateInToday(date) {
            if currentMonth != dateMonth { //placeholder는 안보이도록 처리
                return .clear
            }
            if date == startDate || date == endDate {
                return .mpWhite
            }
            return .mpMainColor
        }
        
        
        //제외 기간 처리
        for range in unselectableDateRanges {
            if let start = range.first, let end = range.last, start <= date && date <= end {
                if Calendar.current.isDateInToday(date) {
                    return .mpMainColor
                }
                if currentMonth == dateMonth{ // 해당 달이 아닌데도 떠서 취한 조치
                    return .lightGray // Return grey color for unselectable date texts
                }
            }
        }
        
        
        //period 날짜 보여주는 로직
        if let startDate = startDate, let endDate = endDate {
            if date == startDate || date == endDate {
                return .mpWhite // Text color for start and end dates
            } else if date > startDate && date < endDate {
                return .mpBlack // Text color for dates between start and end
            }
        } else if let startDate = startDate {
            if date == startDate {
                return .mpWhite // Text color for the start date
            }
        }
        
        return nil // Default text color for other dates
    }
    
    //폰트 적용 (이상하게 작동이 안되는 듯)
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleFontFor date: Date) -> UIFont? {
        
        let boldFont = UIFont(name: "SFProDisplay-Bold", size: 20) ?? .mpFont20B() //UIFont.boldSystemFont(ofSize: 20)
        let regularFont = UIFont(name: "SFProDisplay-Regular", size: 20) ?? .mpFont20M() //UIFont.systemFont(ofSize: 20)
        
        print("폰트적용")
        
        // Check if the date is the start or end date
        if let startDate = startDate{
            if(date == startDate){
                return boldFont
            }
        } else if let endDate = endDate{
            if(date == endDate){
                return boldFont
            }
        }
        
        // For any other date
        return regularFont
    }
    
    
    func setUnselectableDateRanges(_ ranges: [[Date]]) {
        unselectableDateRanges = ranges
        calendar.reloadData() // Reload calendar to refresh appearance
    }
    
    func updateUnselectableDateRanges(with terms: [Term]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let ranges = terms.map { term -> [Date] in
            let startDate = dateFormatter.date(from: term.startDate)!
            let endDate = dateFormatter.date(from: term.endDate)!
            return [startDate, endDate]
        }
        setUnselectableDateRanges(ranges)
    }
    
//    func generateUnselectableDateRanges() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        
//        let range1Start = dateFormatter.date(from: "2024/02/13")!
//        let range1End = dateFormatter.date(from: "2024/02/15")!
//        
//        let range2Start = dateFormatter.date(from: "2024/02/18")!
//        let range2End = dateFormatter.date(from: "2024/02/25")!
//        
//        unselectableDateRanges = [
//            [range1Start, range1End],
//            [range2Start, range2End]
//        ]
//        
//        // After setting the ranges, tell the calendar to refresh
//        calendar.reloadData()
//    }
    
    // 애니메이션으로 텍스트를 변경하는 함수
    func changeLabelWithAnimation(_ label: UILabel, to newText: String, duration: TimeInterval = 0.1) {
        UIView.transition(with: label, duration: duration, options: .transitionCrossDissolve, animations: {
            label.text = newText
        }, completion: nil)
    }
    
    
}


extension PeriodCalendarModal {
    
//    // 특정 날짜의 모서리 둥글기
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
//        if let start = startDate, let end = endDate {
//
//        }
//        return 1.0 // 기본값은 둥근 모서리
//    }

}


enum SelectedDateType {
    case singleDate    // 날짜 하나만 선택된 경우 (원 모양 배경)
    case firstDate    // 여러 날짜 선택 시 맨 처음 날짜
    case sundayDate // 일요일 => 왼쪽만 둥금
    case saturdayDate // 토요일 => 오른쪽만 둥금.
    case lastDate   // 여러 날짜 선택시 맨 마지막 날짜. 오른쪽만 둥금.
    case firstOfMonth // 달의 맨 처음 날짜. 왼쪽만 둥금.
    case lastOfMonth // 달의 맨 마지막 날짜. 오른쪽만 둥금
    case middleDate // 선택된 날 중에 위에 해당하지 않음. 모든 모서리가 둥글지 않음.
    case notSelected // 선택되지 않은 날짜
}



protocol MonthSelectionDelegate: AnyObject {
    func monthSelectionDidSelect(date: Date)
}

class MonthSelectionViewController: UIViewController {
    
    weak var delegate: MonthSelectionDelegate?
    
    private let customModal: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .mpWhite
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false // 활성화해야 auto layout이 작동합니다.
        return containerView
    }()
    
    private let titleLabel: MPLabel = {
        let label = MPLabel()
        label.text = "달력 이동 선택"
        label.textColor = .mpBlack
        label.font = .mpFont20B()
        label.translatesAutoresizingMaskIntoConstraints = false // 활성화해야 auto layout이 작동합니다.
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.translatesAutoresizingMaskIntoConstraints = false // 활성화해야 auto layout이 작동합니다.
        return picker
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택 완료", for: .normal)
        button.backgroundColor = .mpMainColor
        button.setTitleColor(.mpWhite, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false // 활성화해야 auto layout이 작동합니다.
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(customModal)
        customModal.addSubview(titleLabel)
        customModal.addSubview(datePicker)
        customModal.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            customModal.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            customModal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customModal.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customModal.heightAnchor.constraint(equalToConstant: 350),
            
            titleLabel.topAnchor.constraint(equalTo: customModal.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: customModal.centerXAnchor),
            
            datePicker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -10),
            
            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            doneButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 50),
            doneButton.trailingAnchor.constraint(equalTo: customModal.trailingAnchor, constant: -50),
            doneButton.bottomAnchor.constraint(equalTo: customModal.bottomAnchor, constant: -20)
        ])
    }

    @objc private func doneButtonTapped() {
        delegate?.monthSelectionDidSelect(date: datePicker.date)
        navigationController?.popViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}


// PeriodCalendarModal.swift (내부 코드 일부)
extension PeriodCalendarModal: MonthSelectionDelegate {
    
    @objc func monthButtonTapped() {
        let monthSelectionVC = MonthSelectionViewController()
        monthSelectionVC.delegate = self
        navigationController?.pushViewController(monthSelectionVC, animated: true)
    }

    func monthSelectionDidSelect(date: Date) {
        // 업데이트할 날짜를 여기에서 처리합니다.
        calendar.setCurrentPage(date, animated: true)
    }
}



//@objc func monthButtonTapped() {
//    // Container view for the date picker and toolbar
//    containerView = UIView()
//    containerView!.backgroundColor = .white
//    containerView!.layer.cornerRadius = 12
//    
//    containerView!.layer.shadowColor = UIColor.mpBlack.cgColor
//    containerView!.layer.shadowOpacity = 0.5
//    containerView!.layer.shadowOffset = CGSize(width: 0, height: 2)
//    containerView!.layer.shadowRadius = 8
//    
//    containerView!.translatesAutoresizingMaskIntoConstraints = false
//    view.addSubview(containerView!)
//    
//    // Date Picker setup
//    let datePicker = UIDatePicker()
//    datePicker.datePickerMode = .date
//    if #available(iOS 13.4, *) {
//        datePicker.preferredDatePickerStyle = .wheels
//    }
//    datePicker.translatesAutoresizingMaskIntoConstraints = false
//    
//    // Done Button setup
//    let doneButton = UIButton()
//    doneButton.layer.cornerRadius = 5
//    doneButton.backgroundColor = .mpMainColor
//    doneButton.setTitle("완료", for: .normal)
//    doneButton.setTitleColor(.mpWhite, for: .normal)
//    doneButton.translatesAutoresizingMaskIntoConstraints = false
//    doneButton.addTarget(self, action: #selector(dismissDatePicker), for: .touchUpInside)
//    
//    containerView!.addSubview(datePicker)
//    containerView!.addSubview(doneButton)
//    
//    NSLayoutConstraint.activate([
//        containerView!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        containerView!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        containerView!.widthAnchor.constraint(equalToConstant: 300),
//        containerView!.heightAnchor.constraint(equalToConstant: 250),
//        
//        datePicker.topAnchor.constraint(equalTo: containerView!.topAnchor, constant: 20),
//        datePicker.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: 10),
//        datePicker.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: -10),
//        
//        doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
//        doneButton.heightAnchor.constraint(equalToConstant: 44),
//        doneButton.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor, constant: 10),
//        doneButton.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor, constant: -10),
//        doneButton.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor, constant: -20)
//    ])
//    
//    // Only show month and year in the date picker
//    if #available(iOS 13.4, *) {
//        datePicker.locale = Locale(identifier: "en_GB")
//        datePicker.datePickerMode = .date
//        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
//    } else {
//        // Fallback for earlier versions
//    }
//}
