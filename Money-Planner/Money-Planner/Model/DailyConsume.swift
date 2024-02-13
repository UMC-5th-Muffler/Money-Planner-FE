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
