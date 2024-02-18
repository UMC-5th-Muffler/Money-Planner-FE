//
//  Goal.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/01.
//

import Foundation

struct Goal : Codable {
    let goalID: Int
    let goalTitle: String?
    let goalBudget: Int64?
    let startDate : String?
    let endDate: String?
    let totalCost: Int64?
    let icon : String? 

    enum CodingKeys: String, CodingKey {
        case goalID = "goalId"
        case goalTitle
        case goalBudget, startDate, endDate, totalCost, icon
    }
}

struct GoalList : Codable {
    let goalList : [Goal]?
}
