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
    var expenseDetailList: [ConsumeDetail]?
    
    enum CodingKeys: String, CodingKey {
        case date, dailyTotalCost, expenseDetailList
    }
}

struct DailyExpenseList : Codable {
    let dailyExpenseList : [DailyConsume]?
    let hasNext : Bool
}

// 일일소비내역 조회
// MARK: - DailyInfo
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

// 소비평가
// MARK: - RateInfo
struct RateInfo: Codable {
    let rate, rateMemo: String?
    let dailyPlanBudget, dailyTotalCost: Int?
    let isZeroDay: Bool?
}

// MARK: - RateModel
struct RateModel: Codable {
    let rate, rateMemo: String?
}

//제로데이
// MARK: - ZeroModel
struct ZeroModel: Codable {
    let dailyPlanDate: String
}
