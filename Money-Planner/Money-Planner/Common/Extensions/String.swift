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
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
