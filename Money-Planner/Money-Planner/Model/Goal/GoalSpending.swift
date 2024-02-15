//
//  GoalSpending.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation

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
