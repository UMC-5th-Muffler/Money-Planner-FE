//
//  PeriodSelectionModalViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/30/24.
//

import Foundation
import UIKit

class PeriodSelectionModalViewController: UIViewController {
    
    weak var delegate: CalendarSelectionDelegate?
    
    // UI Elements: titleLabel, datePicker, completeButton, etc.
    var titleLabel = MPLabel()
    
    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModal()
        setupDatePicker()
        setupPeriodSelectionButtons()
    }
    
    private func setupModal() {
        // Add titleLabel, completeButton, etc. to customModal
        // Configure constraints and styles
    }
    
    private func setupDatePicker() {
//        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        // Add datePicker to containerView and set constraints
    }
    
    private func setupPeriodSelectionButtons() {
        // Create buttons for 1 week, 2 weeks, 1 month
        // Add target actions for each button
        // Add buttons to a UIStackView and configure the stack view
        // Add the stack view to the customModal below the datePicker
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        
        if let startDate = startDate {
            if selectedDate < startDate {
                self.startDate = selectedDate
                updateTitleForStartDate()
            } else {
                endDate = selectedDate
                updateTitleForEndDate()
            }
        } else {
            startDate = selectedDate
            updateTitleForStartDate()
        }
    }
    
    private func updateTitleForStartDate() {
        titleLabel.text = "시작일을 선택해주세요"
        // Update subtitle if necessary
    }
    
    private func updateTitleForEndDate() {
        titleLabel.text = "종료일을 선택해주세요"
        // Update subtitle to show the selected start date
        // Check if the period exceeds 4 weeks and show a warning if needed
    }
    
    @objc private func oneWeekButtonTapped() {
        // Calculate end date based on one week from start date
        // Update endDate and update the UI accordingly
    }
    
    // Similar implementations for twoWeekButtonTapped and oneMonthButtonTapped
    
    @objc private func completeButtonTapped() {
        // Handle completion logic, possibly involving delegate
    }
}
