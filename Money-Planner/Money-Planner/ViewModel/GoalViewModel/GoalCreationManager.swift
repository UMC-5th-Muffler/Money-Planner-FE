//
//  GoalCreationManager.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation

// GoalCreationManager
class GoalCreationManager {
    
    static let shared = GoalCreationManager()
    let goalViewModel = GoalViewModel.shared

    var goalID: Int?
    var goalEmoji: String?
    var goalName: String?
    var goalAmount: Int64?
    var goalStart: Date?
    var goalEnd: Date?
    
    
    var categories : [Category] = []
 
    private init() {} // Private initializer to ensure singleton usage

    func createGoalRequest() -> CreateGoalRequest? {
        guard let goalEmoji = goalEmoji,
              let goalName = goalName,
              let goalAmount = goalAmount,
              let goalStart = goalStart,
              let goalEnd = goalEnd else {
            return nil
        }

        return CreateGoalRequest(goalEmoji: goalEmoji, goalName: goalName, goalAmount: goalAmount, goalStart: goalStart, goalEnd: goalEnd)
    }
    
    func addGoal() {
        var currentGoals = try! goalViewModel.goalsSubject.value()
        var goal = Goal(GoalID: goalID!, goalEmoji: goalEmoji!, goalName: goalName!, goalAmount: goalAmount!, usedAmount: Int64(0), goalStart: goalStart!, goalEnd: goalEnd!, dailyGoal: [], isEdited: [])
        currentGoals.append(goal)
        goalViewModel.goals = currentGoals // This will trigger the update
    }
//    func createCategoryRequest() -> CreateCategoryRequest {
//
//    }
//
//    func postMultipleCreateCategoryRequest(){
//
//    }

    func clear() {
        goalEmoji = nil
        goalName = nil
        goalAmount = nil
        goalStart = nil
        goalEnd = nil
    }
}
