//
//  Category.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/21.
//

import Foundation

// MARK: - Category
struct Category: Codable, Identifiable {
    let id: Int?
    let name: String?
    var categoryBudget: Int64? = 0
}


// 카테고리 리포트 : GoalDetails에도 있음.
//struct CategoryTotalCost: Codable {
//    let categoryName: String
//    let totalCost: Int
//}

struct CategoryReport: Codable {
    let categoryName: String
    let categoryIcon: String
    let categoryBudget: Int
    let totalCost: Int
    let avgCost: Int
    let maxCost: Int
    let expenseCount: Int
}

struct ReportResult: Codable {
    let zeroDayCount: Int
    let categoryTotalCosts: [CategoryTotalCost]
    let categoryGoalReports: [CategoryReport]
}

struct ReportData: Codable {
    let isSuccess: Bool
    let message: String
    let result: ReportResult
}
