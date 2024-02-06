//
//  CalendarDaily.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/01.
//

import Foundation

struct CalendarDaily: Codable {
    let date : String
    let dailyBudget : Int?
    let dailyTotalCost: Int?
    let dailyRate: String?
    var isZeroDay: Bool?
}
