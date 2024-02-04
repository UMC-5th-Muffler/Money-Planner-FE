//
//  PeriodCalendar.swift
//  Money-Planner
//
//  Created by 유철민 on 2/5/24.
//

import Foundation
import UIKit

class PeriodCalendar: UIView {
    
    let monthPickerBtn = MonthPickerButton()
    let prevMonthBtn = UIButton()
    let nextMonthBtn = UIButton()
    let daysOfWeekStack = UIStackView()
    var dailyViews = [[UIView]]() // 5x7 grid of UIViews
    
    enum BackgroundState {
        case lRrR, lSrR, lRrS, lSrS
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(monthPickerBtn)
        addSubview(prevMonthBtn)
        addSubview(nextMonthBtn)
        addSubview(daysOfWeekStack)
        
        // Layout configuration for monthPickerBtn
        monthPickerBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            monthPickerBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            monthPickerBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            monthPickerBtn.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Layout configuration for prevMonthBtn
        prevMonthBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            prevMonthBtn.centerYAnchor.constraint(equalTo: monthPickerBtn.centerYAnchor),
            prevMonthBtn.leadingAnchor.constraint(equalTo: monthPickerBtn.trailingAnchor, constant: 10),
            prevMonthBtn.heightAnchor.constraint(equalToConstant: 44),
            prevMonthBtn.widthAnchor.constraint(equalTo: prevMonthBtn.heightAnchor)
        ])
        
        // Layout configuration for nextMonthBtn
        nextMonthBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextMonthBtn.centerYAnchor.constraint(equalTo: monthPickerBtn.centerYAnchor),
            nextMonthBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            nextMonthBtn.heightAnchor.constraint(equalToConstant: 44),
            nextMonthBtn.widthAnchor.constraint(equalTo: nextMonthBtn.heightAnchor)
        ])
        
        // Layout configuration for daysOfWeekStack
        daysOfWeekStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            daysOfWeekStack.topAnchor.constraint(equalTo: monthPickerBtn.bottomAnchor, constant: 10),
            daysOfWeekStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            daysOfWeekStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            daysOfWeekStack.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Assuming you have a setupDailyViews method to setup the 5x7 grid
        setupDailyViews()
    }
    
    private func setupDailyViews() {
        // Configure your daily views grid (5x7)
        for _ in 0..<5 {
            var weekViews = [UIView]()
            for _ in 0..<7 {
                let dayView = UIView()
                dayView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(dayView)
                weekViews.append(dayView)
            }
            dailyViews.append(weekViews)
        }
        
        // Now add constraints for the dailyViews
        for (i, weekViews) in dailyViews.enumerated() {
            for (j, dayView) in weekViews.enumerated() {
                let topAnchor = i == 0 ? daysOfWeekStack.bottomAnchor : dailyViews[i-1][j].bottomAnchor
                NSLayoutConstraint.activate([
                    dayView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                    dayView.heightAnchor.constraint(equalToConstant: 40),
                    dayView.widthAnchor.constraint(equalTo: dayView.heightAnchor),
                    dayView.leadingAnchor.constraint(equalTo: j == 0 ? self.leadingAnchor : weekViews[j-1].trailingAnchor, constant: 5)
                ])
            }
        }
    }
}


class MonthPickerButton: UIButton {
    var picker = UIPickerView()
    var months: [String] = []
    var years: [String] = []
    var selectedMonth: String?
    var selectedYear: String?
    var onDateSelected: ((_ month: String, _ year: String) -> Void)?
    
    private let chevronImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        // Populate months and years arrays
        months = DateFormatter().shortMonthSymbols
        let currentYear = Calendar.current.component(.year, from: Date())
        years = (currentYear-10...currentYear+10).map { String($0) }
        
        // Set initial selected values to current month and year
        let currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        selectedMonth = months[currentMonthIndex]
        selectedYear = String(currentYear)
        
        // Set the button's title to the current month and year
        setTitle("\(selectedMonth!) \(selectedYear!)", for: .normal)
        setTitleColor(.black, for: .normal)
        alignTitleAndImage()
        
        addTarget(self, action: #selector(togglePicker), for: .touchUpInside)
        
        // Configure the picker
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true // Picker is hidden by default
    }
    
    private func alignTitleAndImage() {
        // Add the chevron image view
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chevronImageView)
        
        // Set constraints for the chevron image view
        NSLayoutConstraint.activate([
            chevronImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Ensure the title and chevron image are spaced properly
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -chevronImageView.frame.width, bottom: 0, right: chevronImageView.frame.width)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width - chevronImageView.frame.width, bottom: 0, right: -self.frame.width + chevronImageView.frame.width)
    }

    
    @objc func togglePicker() {
        // Toggle picker visibility
        picker.isHidden.toggle()
        
        // Optional: Animate the chevron rotation
        let chevronDirection = picker.isHidden ? "chevron.right" : "chevron.down"
        chevronImageView.image = UIImage(systemName: chevronDirection)
        
        // Optional: If the picker is part of the button, you may need to adjust the layout
        // to accommodate the picker's visibility change.
    }
}

// MARK: - UIPickerView Delegate & DataSource
extension MonthPickerButton: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2 // month and year
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return months.count
        } else {
            return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return months[row]
        } else {
            return years[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedMonth = months[row]
        } else {
            selectedYear = years[row]
        }
        // When a date is selected, invoke the callback
        if let month = selectedMonth, let year = selectedYear {
            setTitle("\(month) \(year)", for: .normal)
            onDateSelected?(month, year)
        }
    }
}
