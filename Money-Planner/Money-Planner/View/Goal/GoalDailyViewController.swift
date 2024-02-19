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

class GoalDailyViewController: UIViewController, DayGoalMonthViewDelegate {
    
    private let descriptionView = DescriptionView(text: "하루하루의 목표금액을\n조정해주세요", alignToCenter: false)
    private let subdescriptionView = SubDescriptionView(text: "일정에 맞게 일일 목표 금액을 변경하면\n나머지 금액은 1/n 해드릴게요", alignToCenter: false)
    private let btmBtn = MainBottomBtn(title: "다음")
    
    private let goalCreationManager = GoalCreationManager.shared
    private let isEdited : [Bool] = []
    
    let monthView: DayGoalMonthView = {
        let v = DayGoalMonthView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.hideButtons()
        v.setLayoutMiddle()
        return v
    }()
    
    let calendarView: DayGoalCalendarView = {
        let v = DayGoalCalendarView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        monthView.delegate = self
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        
        addSwipeGestures()
        
        let endDate = goalCreationManager.endDate?.toMPDate()
        if let startDate = goalCreationManager.startDate?.toMPDate() {
            
            let calendar = Calendar.current
            let year = calendar.component(.year, from: startDate)
            let month = calendar.component(.month, from: startDate)
            
            self.monthView.monthLabel.text = "\(year)년 \(month)월"
            self.monthView.currentYear = year
            self.monthView.currentMonth = month
            
            calendarView.changeMonth(monthIndex: month, year: year)
            calendarView.setPeriod(startDate: startDate, endDate: endDate)
        }
        
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
        view.addSubview(monthView)
        view.addSubview(calendarView)
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
            
            monthView.topAnchor.constraint(equalTo: subdescriptionView.bottomAnchor, constant: 20),
            monthView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            monthView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            monthView.heightAnchor.constraint(equalToConstant: 46),
            
            calendarView.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 5),
            calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            calendarView.bottomAnchor.constraint(equalTo: btmBtn.topAnchor, constant: -30),
            
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
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        calendarView.changeMonth(monthIndex: monthIndex, year: year)
    }
    
    private func addSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeRight.direction = .right
        calendarView.addGestureRecognizer(swipeRight) // calendarView에 제스처 추가
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeLeft.direction = .left
        calendarView.addGestureRecognizer(swipeLeft) // calendarView에 제스처 추가
    }

    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            changeMonth(moveNext: true)
        } else if sender.direction == .right {
            changeMonth(moveNext: false)
        }
    }

    private func changeMonth(moveNext: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            // 달력 뷰를 페이드 아웃 시킵니다.
            self.calendarView.alpha = 0.0
        }, completion: { _ in
            if moveNext {
                self.monthView.currentMonth += 1
                if self.monthView.currentMonth > 12 {
                    self.monthView.currentMonth = 1
                    self.monthView.currentYear += 1
                }
            } else {
                self.monthView.currentMonth -= 1
                if self.monthView.currentMonth < 1 {
                    self.monthView.currentMonth = 12
                    self.monthView.currentYear -= 1
                }
            }
            self.monthView.monthLabel.text = "\(self.monthView.currentYear)년 \(self.monthView.currentMonth)월"
            self.calendarView.changeMonth(monthIndex: self.monthView.currentMonth, year: self.monthView.currentYear)
            self.monthView.delegate?.didChangeMonth(monthIndex: self.monthView.currentMonth, year: self.monthView.currentYear)

            // 변경 후 달력 뷰를 다시 페이드 인 시킵니다.
            UIView.animate(withDuration: 0.3) {
                self.calendarView.alpha = 1.0
            }
        })
    }

}
