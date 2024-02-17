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

    var goalID: Int?
    var icon: String?
    var goalTitle: String?
    var goalDetail: String? // Added detail property
    var goalBudget: Int64?
    var startDate: String?
    var endDate: String?
    var categoryGoals: [CategoryGoal] = [] // Assuming this matches your CategoryGoal structure
    var dailyBudgets: [Int64] = [] // Added dailyBudgets property

    private init() {} // Private initializer to ensure singleton usage

    func createGoalRequest() -> PostGoalRequest? {
        guard let icon = icon,
              let goalTitle = goalTitle,
              let goalDetail = goalDetail, // Ensure goalDetail is not nil
              let goalBudget = goalBudget,
              let startDate = startDate,
              let endDate = endDate else {
            return nil
        }

        return PostGoalRequest(icon: icon,
                               title: goalTitle,
                               detail: goalDetail,
                               startDate: startDate,
                               endDate: endDate,
                               totalBudget: goalBudget,
                               categoryGoals: categoryGoals,
                               dailyBudgets: dailyBudgets)
    }

    func addGoal() {
        
    }

    func clear() {
        icon = nil
        goalTitle = nil
        goalDetail = nil // Clear the detail
        goalBudget = nil
        startDate = nil
        endDate = nil
        categoryGoals = [] // Clear categoryGoals
        dailyBudgets = [] // Clear dailyBudgets
    }
}
