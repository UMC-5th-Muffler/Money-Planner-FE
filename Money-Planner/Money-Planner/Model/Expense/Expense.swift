//
//  Expense.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/4/24.
//

import Foundation

struct Expense: Codable {
    let expenseCost: Int
    let categoryId: Int
    let expenseTitle: String
    let expenseMemo: String?
    let expenseDate: String
    let routineRequest: RoutineRequest?
    let isRoutine: Bool
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
