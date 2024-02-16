//
//  GoalDetails.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation

//goaldetails - report
struct GoalReportResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: GoalReportResult
}

struct GoalReportResult: Codable {
    let zeroDayCount: Int
    let categoryTotalCosts: [CategoryTotalCost]
    let categoryGoalReports: [CategoryGoalReport]
}

struct CategoryTotalCost: Codable {
    let categoryName: String
    let totalCost: Int
}

struct CategoryGoalReport: Codable {
    let categoryName: String
    let categoryIcon: String
    let categoryBudget: Int
    let totalCost: Int
    let avgCost: Int
    let maxCost: Int
    let expenseCount: Int
}
