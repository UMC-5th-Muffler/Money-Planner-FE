//
//  Goal.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import Moya

struct Goal : Codable{
    var goalName : String
    var goalAmount : Int
    var goalStart : Date
    var goalEnd : Date
    var dailyGoal : [Int]
    var isEdited : [Bool]
}

struct LoadGoalResponseElement: Codable {
//    let id: Int
//    let name, icon, alarmTime, createdAt:String
//    let updatedAt: String
    
//    enum CodingKeys: String, CodingKey{
//        case id, name, icon
//    }
}

typealias LoadGoalResponse = [LoadGoalResponseElement]


struct CreateGoalRequest: Codable {
//    let type, identifier, name, icon: String
//
//    enum CodingKeys: String, CodingKey {
//        case type, identifier, name, icon
//        case alarmTime = "alarm_time"
//    }
}

struct GoalResponse : Codable {
//    let msg : String
}
