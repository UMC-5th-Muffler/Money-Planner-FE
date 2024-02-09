//
//  Date.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/20.
//

import Foundation

extension Date {
    var weekday : Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var firstDayOfTheMonth : Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    func isInRange(startDate: Date, endDate: Date) -> Bool {
          return self >= startDate && self <= endDate
    }
}
