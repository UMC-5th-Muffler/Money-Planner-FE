//
//  Goal.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import Moya


//load
struct Term: Decodable {
    let startDate: String
    let endDate: String
}

struct LoadGoalResult: Decodable {
    let terms: [Term]
}

struct GoalResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: LoadGoalResult
}

//delete

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
    let result: [String: String] // Replace SomeDecodableType with the actual type you expect
}

// If the result is expected to be a dictionary with string keys and unknown value types,
// you could use a type like this:
struct SomeDecodableType: Decodable {
    // Define the properties you expect in the response
}

struct Goal : Codable{// => 이것만 있으면 사실상 다 됐다고 보면 돼서... => 이거에서
    var GoalID : Int
    var goalEmoji : String
    var goalName : String
    var goalAmount : Int64
    var usedAmount : Int64
    var goalStart : Date //=> String으로
    var goalEnd : Date //=> String으로
    var dailyGoal : [Int64]
    var isEdited : [Bool]
}

//typealias LoadGoalResponse = [LoadGoalResponseElement]
//
//// LoadGoalResponseElement
//struct LoadGoalResponseElement: Codable {
//    var goalEmoji: String
//    var goalName: String
//    var goalAmount: Int64
//    var usedAmount: Int64
//    var goalStart: Date
//    var goalEnd: Date
//    var dailyGoal: [Int64]
//    var isEdited: [Bool]
//}
//
// CreateGoalRequest
struct CreateGoalRequest: Codable {
    var goalEmoji: String
    var goalName: String
    var goalAmount: Int64
    var goalStart: Date
    var goalEnd: Date
}


//// MARK: Result
//struct Result: Codable {
//    let zeroDayCount: Int
//    let categoryTotalCosts: [CategoryTotalCost] 
//    let categoryGoalReports: [CategoryGoalReport]
//}
//// MARK: CategoryGoalReport
//struct CategoryGoalReport: Codable {
//    let categoryName, categoryIcon: String
//    let categoryBudget, totalCost, avgCost, maxCost: Int
//    let expenseCount: Int
//}
//// MARK: CategoryTotalCost
//struct CategoryTotalCost: Codable {
//    let categoryName: String
//    let totalCost: Int
//}

//Goal Home VC
//현재 진행 목표

//종료, 예정 목표