//
//  String.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/20.
//

import Foundation

extension String{
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var formatMonthAndDate : String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "M월 d일"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    var toDate: Date? {
        return String.dateFormatter.date(from: self)
    }
    
}
