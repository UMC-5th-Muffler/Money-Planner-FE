//
//  Category.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/21.
//

import Foundation

// MARK: - Category
struct Category: Codable {
    let id: Int
    var categoryIcon : String?
    let name: String
    var priority : Int?
    var categoryBudget: Int64?
    var isVisible : Bool?
    var type : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "categoryId"
        case categoryIcon = "icon"
        case name, priority, isVisible, type
        
    }
}

struct CategoryList : Codable {
    let categories : [Category]?
}



// MARK: - Category
//struct Category: Codable, Identifiable {
//    let id: Int?
//    let name: String?
//    var categoryBudget: Int64? = 0
//}


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

struct GoalCategory : Codable {
    var id: Int?
    var name: String?
    var categoryBudget : Int64 = 0
}
