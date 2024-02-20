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


