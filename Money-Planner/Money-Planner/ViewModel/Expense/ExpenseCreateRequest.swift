//
//  ExpenseCreateRequest.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/14/24.
//

import Foundation

struct ExpenseCreateRequest: Codable {
    let expenseCost: Int64
    let categoryId: Int64
    let expenseTitle: String
    let expenseMemo: String
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
        let monthlyRepeatType: monthlyRepeatType?
    }

    enum RoutineType: String, Codable {
        case weekly = "WEEKLY"
        case monthly = "MONTHLY"
    }
    enum monthlyRepeatType : String, Codable {
        case first = "FIRST_DAY_OF_MONTH"
        case specific = "SPECIFIC_DAY_OF_MONTH"
        case last = "LAST_DAY_OF_MONTH"
    }
}

