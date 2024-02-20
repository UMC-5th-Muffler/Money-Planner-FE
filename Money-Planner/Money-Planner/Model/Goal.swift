//
//  Goal.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/01.
//

import Foundation

struct Goal : Codable {
    let goalID: Int
    let goalTitle: String?
    let goalBudget: Int64?
    let startDate : String?
    let endDate: String?
    let totalCost: Int64?
    let icon : String? 

    enum CodingKeys: String, CodingKey {
        case goalID = "goalId"
        case goalTitle
        case goalBudget, startDate, endDate, totalCost, icon
    }
}

struct GoalList : Codable {
    let goalList : [Goal]?
}


//previous goal 을 받을 용도
struct Term: Decodable {
    let startDate: String
    let endDate: String
}

struct PreviousGoalResult: Decodable {
    let terms: [Term]
}

struct PreviousGoalResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: PreviousGoalResult
}

//delete
struct DeleteGoalResponse: Codable {
    let isSuccess: Bool
    let message: String
}

//post
// The request structure for posting a new goal
struct PostGoalRequest: Encodable {
    let icon: String
    let title: String
    let detail: String
    let startDate: String
    let endDate: String
    let totalBudget: Int64
    let categoryGoals: [CategoryGoal]
    let dailyBudgets: [Int64]
}


// A substructure for the category goals within the PostGoalRequest
struct CategoryGoal: Encodable {
    let categoryId: Int64
    let categoryBudget: Int64
}

// The response structure after posting a new goal
struct PostGoalResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: [String: String]
}
 
//struct Goal : Codable{//
//    var GoalID : Int
//    var icon : String
//    var goalName : String
//    var goalAmount : Int64
//    var usedAmount : Int64
//    var goalStart : Date //=> String으로
//    var goalEnd : Date //=> String으로
//    var dailyGoal : [Int64]
//    var isEdited : [Bool]
//}


import Foundation

//DetailView에서 사용
struct NowGoalResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: GoalResult

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
}

struct GoalResult: Codable {
    let goalId: Int64?
    let goalTitle: String?
    let icon: String?
    let totalBudget: Int64?
    let totalCost: Int64?
    let endDate: String?

    enum CodingKeys: String, CodingKey {
        case goalId
        case goalTitle
        case icon
        case totalBudget
        case totalCost
        case endDate
    }
}

struct NotNowGoalResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: GoalResults

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
}

struct GoalResults: Codable {
    let futureGoal: [GoalResult]?
    let endedGoal: [GoalResult]?
    let hasNext: Bool?

    enum CodingKeys: String, CodingKey {
        case futureGoal
        case endedGoal
        case hasNext
    }
}



//Period

struct PreviousGoalResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: PreviousGoalResult

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
}

struct PreviousGoalResult: Codable {
    let terms: [GoalTerm]
}

struct GoalTerm: Codable {
    let startDate: String
    let endDate: String
}


//post

// Define the structure for the request body
struct CreateGoalRequest: Codable {
    let icon: String
    let title: String
    let startDate: String
    let endDate: String
    let totalBudget: Int64?
    let categoryGoals: [CategoryGoal]
    let dailyBudgets: [Int64?]
}

// Define the structure for the category goal
struct CategoryGoal: Codable {
    let categoryId: Int64?
    let categoryBudget: Int64?
}

// Define the structure for the response
struct CreateGoalResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: [String]? // You can replace Any with the actual type of result if it's known
}

//goaldetail 상단
struct GoalByIdResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: GoalInfo?
}

struct GoalInfo: Codable {
    let title: String
    let icon: String
    let startDate: String
    let endDate: String
    let totalBudget: Int64
    let totalCost: Int64
}

//delete
struct DeleteGoalResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: [String]? // 결과가 비어있는 dictionary인 경우
}

//goal report - detailview
// Goal report response structures
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

//소비
struct WeeklyExpenseResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: WeeklyExpenseResult
}

struct WeeklyExpenseResult: Codable {
    let dailyExpenseList: [DailyExpense]
    let hasNext: Bool
}

struct DailyExpense: Codable {
    let date: String
    let dailyTotalCost: Int64
    let expenseDetailList: [ExpenseDetail]
}

struct ExpenseDetail: Codable {
    let expenseId: Int64
    let title: String
    let cost: Int64
    let categoryIcon: String
}
