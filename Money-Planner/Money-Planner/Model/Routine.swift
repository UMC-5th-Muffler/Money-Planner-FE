//
//  Routine.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/17.
//

import Foundation

struct Routine : Codable {
    let routineId: Int?
    let routineTitle: String?
    let routineCost: Int?
    let categoryIcon: String?
    let monthlyRepeatDay: String?
    let weeklyDetail: RoutineWeeklyDetail?
}


struct RoutineWeeklyDetail : Codable {
    let weeklyTerm : Int?
    let weeklyRepeatDays : [Int]?
}


struct RoutineList : Codable {
    let routineList : [Routine]?
    let hasNext : Bool
}
