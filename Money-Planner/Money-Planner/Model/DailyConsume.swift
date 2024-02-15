//
//  DailyConsume.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/23.
//

import Foundation

// MARK: - DailyConsume
struct DailyConsume: Codable {
    let date: String
    let dailyTotalCost: Int?
    let expenseDetailList: [ConsumeDetail]?
    
    enum CodingKeys: String, CodingKey {
        case date, dailyTotalCost, expenseDetailList
    }
}

struct DailyExpenseList : Codable {
    let dailyExpenseList : [DailyConsume]?
    let hasNext : Bool
}

// 일일소비내역 조회
// MARK: - ConsumeHistory
struct DailyInfo: Codable {
    let date: String?
    let isZeroDay: Bool?
    let dailyTotalCost: Int?
    let rate, rateMemo: String?
    let expenseDetailList: [ExpenseDetailList]?
    let hasNext: Bool
}

// MARK: - ExpenseDetailList
struct ExpenseDetailList: Codable {
    let expenseID: Int
    let title: String
    let cost: Int
    let memo: String?
    let categoryIcon: String

    enum CodingKeys: String, CodingKey {
        case expenseID = "expenseId"
        case title, cost, memo, categoryIcon
    }
}
