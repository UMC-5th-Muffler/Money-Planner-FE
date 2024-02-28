//
//  ShowingPeriodSelectionModal.swift
//  Money-Planner
//
//  Created by 유철민 on 2/12/24.
//

import Foundation
import UIKit
import FSCalendar


//선택된 날짜의 배경색 설정
extension ShowingPeriodSelectionModal : FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return .mpMainColor
    }
}

class ShowingPeriodSelectionModal : UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    weak var delegate: PeriodSelectionDelegate?
    
    init(startDate: Date, endDate: Date) {
        self.selectableDateRanges = [[startDate, endDate]]
        self.startDate = startDate
        self.endDate = endDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        label.text = "선택 기간"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let subTitleLabel: MPLabel = {
        let label = MPLabel()
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
        if let start = startDate, let end = endDate {
            delegate?.periodSelectionDidSelectDates(startDate: start, endDate: end)
        }
        dismiss(animated: true, completion: nil)
    }
    
    //calendar 관련
    var calendar: FSCalendar!
    var startDate: Date?
    var endDate: Date?
    
    var selectableDateRanges: [[Date]] = []
    
    let headerStackView = UIStackView()
    
    let monthButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        let scaledImage = image?.resizeImage(size: CGSize(width: 15, height: 15)) // Set your desired height
        button.setImage(scaledImage, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft // To make the image appear on the right
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.tintColor = UIColor(hexCode: "6C6C6C")
        button.addTarget(ShowingPeriodSelectionModal.self, action: #selector(monthButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let navigationStackView = UIStackView()
    let previousButton = UIButton()
    let nextButton = UIButton()
    
    
    let oneWeekButton : UIButton = createDurationButton(title: "1주")
    let twoWeeksButton : UIButton = createDurationButton(title: "2주")
    let oneMonthButton : UIButton = createDurationButton(title: "한 달")
    let selectWholeButton: UIButton = {
        let button = UIButton()
        let titleString = NSAttributedString(
            string: "목표 기간 전체 조회",
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
        selectWholeButton.addTarget(self, action: #selector(objcSelectWhole), for: .touchUpInside)
    }
    
    // Button action methods
    @objc func selectOneWeek() {
        endDate = nil
        if startDate != nil {
            let day = Calendar.current.date(byAdding: .day, value: 6, to: startDate!)!
            if day > selectableDateRanges[0][1] {
                selectDate(selectableDateRanges[0][1])
                calendar.setCurrentPage(selectableDateRanges[0][1], animated: true)
            }else{
                selectDate(day)
                calendar.setCurrentPage(day, animated: true)
            }
        }
    }
    
    @objc func selectTwoWeeks() {
        endDate = nil
        if startDate != nil {
            let day = Calendar.current.date(byAdding: .day, value: 13, to: startDate!)!
            if day > selectableDateRanges[0][1] {
                selectDate(selectableDateRanges[0][1])
                calendar.setCurrentPage(selectableDateRanges[0][1], animated: true)
            }else{
                selectDate(day)
                calendar.setCurrentPage(day, animated: true)
            }
        }
    }
    
    @objc func selectOneMonth() {
        endDate = nil
        if startDate != nil {
            let day = Calendar.current.date(byAdding: .month, value: 1, to: startDate!)!
            let day2 = Calendar.current.date(byAdding: .day, value: -1, to: day)!
            if day2 > selectableDateRanges[0][1] {
                selectDate(selectableDateRanges[0][1])
                calendar.setCurrentPage(selectableDateRanges[0][1], animated: true)
            }else{
                selectDate(day2)
                calendar.setCurrentPage(day2, animated: true)
            }
        }
    }
    
    @objc func objcSelectWhole() {
        selectWhole()
    }
    
    func selectWhole(){
        clearSelectedDates()
        startDate = selectableDateRanges[0][0]
        selectDate(selectableDateRanges[0][1])
        calendar.setCurrentPage(startDate!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear // Replace with .mpWhite if it's a custom color in your project
        setupHeaderStackView()
        setupCalendar()
        subTitleLabel.text = ""
        completeBtn.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        setupLayoutConstraints()
        updateMonthLabelForDate(startDate!)
        setupDurationButtons()
        selectWhole()
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
        view.addSubview(selectWholeButton)
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
        selectWholeButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        
        // Constraints for selectWholeButton
        NSLayoutConstraint.activate([
            selectWholeButton.centerYAnchor.constraint(equalTo: completeBtn.centerYAnchor),
            selectWholeButton.leadingAnchor.constraint(equalTo: customModal.leadingAnchor, constant: 24),
            selectWholeButton.widthAnchor.constraint(equalToConstant: 90),
            selectWholeButton.heightAnchor.constraint(equalToConstant: 56)
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
        
//        if startDate != nil && endDate == nil && startDate == date {
//            changeLabelWithAnimation(titleLabel, to: "조회 시작일을 선택해주세요")
//            changeLabelWithAnimation(subTitleLabel, to: "하루치 목표는 설정 불가능합니다.")
//            subTitleLabel.textColor = .mpRed
//            clearSelectedDates()
//            completeBtn.isEnabled = false
//            completeBtn.backgroundColor = .mpGray
//            calendar.reloadData()
//            return
//        }
        
        if startDate == nil || endDate != nil || date < startDate! {
            if isDateInRange(date, conflictingWith: selectableDateRanges) {
                // Start a new selection range
                startDate = date
                endDate = nil // Clear previous end date
                if endDate == nil {
                    changeLabelWithAnimation(titleLabel, to: "조회 종료일을 선택해주세요")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    changeLabelWithAnimation(subTitleLabel, to: "\(dateFormatter.string(from: date)) - ")
                }
                subTitleLabel.textColor = .mpBlack
                completeBtn.isEnabled = false
                completeBtn.backgroundColor = .mpGray
            }else{
                //changeLabelWithAnimation(titleLabel, to: "시작일을 선택해주세요")
                changeLabelWithAnimation(subTitleLabel, to: "조회 목표 기간 밖입니다.")
                subTitleLabel.textColor = .mpRed
                clearSelectedDates()
                completeBtn.isEnabled = false
                completeBtn.backgroundColor = .mpGray
                print("End date selected unselectable dates.")
                return
            }
        } else if let start = startDate, date > start {
            // Set end date and ensure it does not conflict with unselectable ranges
            if isDateInRange(date, conflictingWith: selectableDateRanges) {
                endDate = date
                if let start = startDate, let end = endDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    changeLabelWithAnimation(titleLabel, to: "선택 조회 기간")
                    changeLabelWithAnimation(subTitleLabel, to: "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))")
                    completeBtn.isEnabled = true
                    completeBtn.backgroundColor = .mpMainColor
                }
                subTitleLabel.textColor = .mpBlack
            } else {
                changeLabelWithAnimation(titleLabel, to: "조회 시작일을 선택해주세요")
                changeLabelWithAnimation(subTitleLabel, to: "목표 기간 밖입니다.")
                subTitleLabel.textColor = .mpRed
                clearSelectedDates()
                completeBtn.isEnabled = false
                completeBtn.backgroundColor = .mpGray
                print("End date selected unselectable dates.")
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
    
    //기간 제한
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        for range in selectableDateRanges {
            if let start = range.first, let end = range.last, start <= date && date <= end {
                return true
            }
        }
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
        
        //현재달의 오늘 날짜를 특수 표시
        let currentMonth = Calendar.current.component(.month, from: calendar.currentPage)
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
        
        
        //선택 불가능한 달만 회색으로 리턴
        if !isDateInRange(date, conflictingWith: selectableDateRanges){
            return .mpGray
        }
        
        
        if let startDate = startDate, let endDate = endDate {
            if date == startDate || date == endDate {
                return .mpWhite // Text color for start and end dates
            }else{
                return .mpBlack
            }
            
//            else if date > startDate && date < endDate {
//                return .mpBlack // Text color for dates between start and end
//            }
        } else if let startDate = startDate {
            if date == startDate {
                return .mpWhite // Text color for the start date
            }else{
                return .mpBlack
            }
        } else {
            return .mpBlack
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
    
    // 애니메이션으로 텍스트를 변경하는 함수
    func changeLabelWithAnimation(_ label: UILabel, to newText: String, duration: TimeInterval = 0.1) {
        UIView.transition(with: label, duration: duration, options: .transitionCrossDissolve, animations: {
            label.text = newText
        }, completion: nil)
    }
    
    
}

// ShowingPeriodSelectionModal.swift (내부 코드 일부)
extension ShowingPeriodSelectionModal : MonthSelectionDelegate {
    
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
