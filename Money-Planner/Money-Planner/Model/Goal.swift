//
//  Goal.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/01.
//

import Foundation

struct Goal : Codable {
    let goalID: Int
    let goalTitle: String
    let goalBudget: Int
    let startDate, endDate: String
    let totalCost: Int
    let dailyList: [CalendarDaily]

    enum CodingKeys: String, CodingKey {
        case goalID = "goalId"
        case goalTitle, goalBudget, startDate, endDate, totalCost, dailyList
    }
}
