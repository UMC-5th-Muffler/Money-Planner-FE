//
//  Dummy.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import Foundation

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

let pastGoal1: Goal = {
    let goal = Goal(
        goalID : 2,
        goalTitle: "거지 탈출",
        goalBudget: 200000,
        startDate: "2024-01-01",
        endDate: "2024-01-14",
        totalCost: 184200,
        icon: "🤑"
    )
    return goal
}()

let pastGoal2: Goal = {
    let goal = Goal(
        goalID : 3,
        goalTitle: "크리스마스까지 아끼자",
        goalBudget: 200000,
        startDate: "2023-12-01",
        endDate: "2023-12-14",
        totalCost: 234500,
        icon: "🌲"
    )
    return goal
}()

let pastGoal3: Goal = {
    let goal = Goal(
        goalID : 4,
        goalTitle: "한달 30만원 도전!",
        goalBudget: 300000,
        startDate: "2024-01-15",
        endDate: "2024-01-26",
        totalCost: 425500,
        icon: "👍"
    )
    return goal
}()

let futureGoal: Goal = {
    let goal = Goal(
        goalID : 5,
        goalTitle: "새해 몸매 만들기",
        goalBudget: 200000, 
        startDate: "2024-02-01",
        endDate: "2024-02-28",
        totalCost: 0,
        icon: "🏋️‍♀️"
    )
    return goal
}()
