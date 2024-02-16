//
//  GoalDetail.swift
//  Money-Planner
//
//  Created by 유철민 on 2/16/24.
//

import Foundation

//goal detail 최상단을 위한 정보
struct GoalDetailResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: GoalDetail
}

struct GoalDetail: Decodable {
    let title: String
    let icon: String
    let startDate: String
    let endDate: String
    let totalBudget: Int64
    let totalCost: Int64
}

//goaldetails - expense
struct GoalExpenseResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: GoalExpenseResult
}

struct GoalExpenseResult: Codable {
    let dailyExpenseList: [DailyExpense]
    let hasNext: Bool
}

struct DailyExpense: Codable {
    let date: String
    let dailyTotalCost: Int
    let expenseDetailList: [ExpenseDetail]
}

struct ExpenseDetail: Codable {
    let expenseId: Int
    let title: String
    let cost: Int
    let categoryIcon: String
}


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
