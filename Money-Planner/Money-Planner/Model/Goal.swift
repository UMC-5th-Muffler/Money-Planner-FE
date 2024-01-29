//
//  Goal.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import Moya

struct Goal : Codable{
    var goalEmoji : String
    var goalName : String
    var goalAmount : Int
    var usedAmount : Int
    var goalStart : Date
    var goalEnd : Date
    var dailyGoal : [Int]
    var isEdited : [Bool]
}

typealias LoadGoalResponse = [LoadGoalResponseElement]

// LoadGoalResponseElement
struct LoadGoalResponseElement: Codable {
    var goalEmoji: String
    var goalName: String
    var goalAmount: Int
    var usedAmount: Int
    var goalStart: Date
    var goalEnd: Date
    var dailyGoal: [Int]
    var isEdited: [Bool]
}

// CreateGoalRequest
struct CreateGoalRequest: Codable {
    var goalEmoji: String
    var goalName: String
    var goalAmount: Int
    var goalStart: Date
    var goalEnd: Date
}

// GoalResponse
struct GoalResponse: Codable {
    let msg: String
}

