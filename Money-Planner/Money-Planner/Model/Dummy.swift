//
//  Dummy.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter
}()

let pastGoal: Goal = {
    let goal = Goal(
        goalEmoji: "📘",
        goalName: "Read Books",
        goalAmount: 3000000,
        usedAmount: 2000000,
        goalStart: dateFormatter.date(from: "2024/01/01")!,
        goalEnd: dateFormatter.date(from: "2024/01/14")!,
        dailyGoal: [20, 30, 40, 35, 45, 50, 55, 30, 25, 40, 45, 50, 55, 60],
        isEdited: [Bool](repeating: false, count: 14)
    )
    return goal
}()

let currentGoal: Goal = {
    let goal = Goal(
        goalEmoji: "🏃‍♂️",
        goalName: "Running",
        goalAmount: 100,
        usedAmount: 40,
        goalStart: dateFormatter.date(from: "2024/01/17")!,
        goalEnd: dateFormatter.date(from: "2024/01/30")!,
        dailyGoal: [5, 7, 6, 5, 8, 6, 7, 5, 6, 7, 0, 0, 0, 0],
        isEdited: [true, true, true, true, true, true, true, false, false, false, false, false, false, false]
    )
    return goal
}()
