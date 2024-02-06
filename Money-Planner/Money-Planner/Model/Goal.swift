//
//  Goal.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/01.
//

import Foundation

struct Goal : Codable {
    let goalID: Int
    let goalTitle: String? = nil
    let goalBudget: Int? = nil
    let startDate : String? = nil
    let endDate: String? = nil
    let totalCost: Int? = nil
    let icon : String? = nil

    enum CodingKeys: String, CodingKey {
        case goalID = "goalId"
        case goalTitle = "title"
        case goalBudget, startDate, endDate, totalCost, icon
    }
}

struct GoalList : Codable {
    let goalList : [Goal]?
}
