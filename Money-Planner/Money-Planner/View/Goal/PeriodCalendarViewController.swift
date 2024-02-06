//
//  PeriodCalendarViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 2/5/24.
//

import Foundation
import UIKit

class PeriodCalendarViewController: UIViewController {
    var periodCalendar: PeriodCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupPeriodCalendar()
    }

    private func setupPeriodCalendar() {
        // Initialize the PeriodCalendar
        periodCalendar = PeriodCalendar()
        periodCalendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(periodCalendar)
        
        // Setup constraints for PeriodCalendar
        NSLayoutConstraint.activate([
            periodCalendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            periodCalendar.leftAnchor.constraint(equalTo: view.leftAnchor),
            periodCalendar.rightAnchor.constraint(equalTo: view.rightAnchor),
            // Set the height for the periodCalendar or bottomAnchor based on your design.
            periodCalendar.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Handle any PeriodCalendar events
        setupPeriodCalendarHandlers()
    }

    private func setupPeriodCalendarHandlers() {
        // Assuming PeriodCalendar has a closure or delegate to handle date changes
//        periodCalendar.monthPickerButton.onDateSelected = { [weak self] month : Date., year in
//            // Do something with the selected month and year
//            print("Selected Month: \(month), Year: \(year)")
//        }
    }
    
    //btmBtn 눌렀을때
    @objc func btmButtonTapped() {
        print("목표 생성 완료. 목표 화면으로.")
        //api 호출
        //navigation root로 돌아가기
    }
}
