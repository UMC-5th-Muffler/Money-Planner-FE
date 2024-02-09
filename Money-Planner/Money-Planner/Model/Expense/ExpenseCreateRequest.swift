//
//  File.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/4/24.
//

import Foundation

struct ExpenseCreateRequest: Codable {
    let expenseCost: Int64
    let categoryId: Int64
    let expenseTitle: String
    let expenseMemo: String?
    let expenseDate: String
    let routineRequest: RoutineRequest?
    let isRoutine : Bool

    enum CodingKeys: String, CodingKey {
        case expenseCost
        case categoryId
        case expenseTitle
        case expenseMemo
        case expenseDate
        case routineRequest
        case isRoutine
    }

    struct RoutineRequest: Codable {
        let type: RoutineType
        let endDate: String?
        let weeklyRepeatDays: [String]?
        let weeklyTerm: String?
        let monthlyRepeatDay: String?
    }

    enum RoutineType: String, Codable {
        case weekly = "WEEKLY"
        case monthly = "MONTHLY"
    }
}
