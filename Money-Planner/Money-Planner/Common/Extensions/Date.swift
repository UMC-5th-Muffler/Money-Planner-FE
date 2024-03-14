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
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static var todayAtMidnight: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let midnightDate = calendar.date(from: dateComponents)!
        return midnightDate
    }
}
