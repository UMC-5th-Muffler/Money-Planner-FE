//
//  TestViewController.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/12.
//

import Foundation
import UIKit


//class TestViewController : UIViewController, DayGoalMonthViewDelegate {
//    
//    let monthView: DayGoalMonthView = {
//        let v = DayGoalMonthView()
//        v.translatesAutoresizingMaskIntoConstraints=false
//        return v
//    }()
//    
//    let calendarView : DayGoalCalendarView = {
//        let v = DayGoalCalendarView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        return v
//    }()
//    
//    override func viewDidLoad() {
//        monthView.delegate = self
//        view.backgroundColor = .mpWhite
//        view.addSubview(monthView)
//        view.addSubview(calendarView)
//        
//        NSLayoutConstraint.activate([
//            monthView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            monthView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40),
//            monthView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
//            
//            monthView.heightAnchor.constraint(equalToConstant: 46),
//            
//            calendarView.topAnchor.constraint(equalTo: monthView.bottomAnchor, constant: 36),
//            calendarView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
//            calendarView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
//            calendarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//        ])
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        calendarView.myCollectionView.collectionViewLayout.invalidateLayout()
//    }
//    
//    
//    func didChangeMonth(monthIndex: Int, year: Int) {
//        calendarView.changeMonth(monthIndex: monthIndex, year: year)
//    }
//}
