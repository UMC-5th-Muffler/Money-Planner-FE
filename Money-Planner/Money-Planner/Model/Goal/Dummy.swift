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

let currentGoal: Goal = {
    let goal = Goal(
        goalEmoji: "✈️",
        goalName: "일본여행 가기 전 돈모으기",
        goalAmount: 175000,
        usedAmount: 300000,
        goalStart: dateFormatter.date(from: "2024/01/01")!,
        goalEnd: dateFormatter.date(from: "2024/01/31")!,
        dailyGoal: [20, 30, 40, 35, 45, 50, 55, 30, 25, 40, 45, 50, 55, 60],
        isEdited: [Bool](repeating: false, count: 14)
    )
    return goal
}()

let pastGoal1: Goal = {
    let goal = Goal(
        goalEmoji: "🤑",
        goalName: "거지 탈출",
        goalAmount: 200000,
        usedAmount: 184200,
        goalStart: dateFormatter.date(from: "2024/01/01")!,
        goalEnd: dateFormatter.date(from: "2024/01/14")!,
        dailyGoal: [13208, 13128, 13255, 13045, 13045, 12975, 13298, 13043, 13016, 13256, 13236, 13222, 13210, 13263],
        isEdited: [true, true, true, true, true, true, true, false, false, false, false, false, false, false]
    )
    return goal
}()

let pastGoal2: Goal = {
    let goal = Goal(
        goalEmoji: "🌲",
        goalName: "크리스마스까지 아끼자",
        goalAmount: 200000,
        usedAmount: 234500,
        goalStart: dateFormatter.date(from: "2023/12/01")!,
        goalEnd: dateFormatter.date(from: "2023/12/14")!,
        dailyGoal: [16811, 16740, 16667, 16626, 16597, 16763, 16805, 16751, 16717, 16759, 16709, 16790, 16916, 16849],
        isEdited: [true, true, true, true, true, true, true, true, true, false, false, false, false, false]
    )
    return goal
}()

let pastGoal3: Goal = {
    let goal = Goal(
        goalEmoji: "👍",
        goalName: "한달 30만원 도전!",
        goalAmount: 300000,
        usedAmount: 425500,
        goalStart: dateFormatter.date(from: "2024/01/15")!,
        goalEnd: dateFormatter.date(from: "2024/01/26")!,
        dailyGoal: [30548, 30336, 30433, 30264, 30143, 30360, 30385, 30467, 30475, 30575, 30544, 30372, 30280, 30318],
        isEdited: [true, true, true, true, true, true, true, true, true, true, false, false, false, false]
    )
    return goal
}()


let futureGoal: Goal = {
    let goal = Goal(
        goalEmoji: "🏋️‍♀️",
        goalName: "새해 몸매 만들기",
        goalAmount: 200000, // 예시 금액
        usedAmount: 0, // 미래 목표이므로 사용 금액은 0
        goalStart: dateFormatter.date(from: "2024/02/01")!,
        goalEnd: dateFormatter.date(from: "2024/02/28")!,
        dailyGoal: [Int64](repeating: 7142, count: 28), // 200,000을 28일로 나눈 금액
        isEdited: [Bool](repeating: false, count: 28) // 아직 편집되지 않음
    )
    return goal
}()
