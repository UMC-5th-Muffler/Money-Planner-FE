//
//  GetGoalNowResponse.swift
//  Money-Planner
//
//  Created by 유철민 on 2/19/24.
//

import Foundation

struct GetGoalNowResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: GoalInfo

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
}

struct GoalInfo: Decodable {
    let goalId: Int64
    let goalTitle: String
    let icon: String
    let totalBudget: Int64
    let totalCost: Int64
    let endDate: String

    enum CodingKeys: String, CodingKey {
        case goalId, goalTitle, icon, totalBudget, totalCost, endDate
    }
}



