//
//  now.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation

//now, 이용주소 : /api/goal/now
struct NowResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: Goal_
}

//not-now,이용주소 : /api/goal/not-now
struct NotNowResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: NotNowResult
}

struct NotNowResult: Codable {
    let futureGoal, endedGoal: [Goal_]
    let hasNext: Bool
}

struct Goal_: Codable {
    let goalID: Int
    let goalTitle: String
    let icon: String
    let totalBudget: Int64
    let totalCost: Int64?
    let endDate: String
    
    enum CodingKeys: String, CodingKey {
        case goalID = "goalId"
        case goalTitle, icon, totalBudget, totalCost, endDate
    }
}

//func makeDummyNotNow() {
//    let jsonString = """
//    {
//        "isSuccess": true,
//        "message": "성공입니다.",
//        "result": {
//            "futureGoal": [
//                {
//                    "goalId": 15,
//                    "goalTitle": "title",
//                    "icon": "icon",
//                    "totalBudget": 30000,
//                    "endDate": "2024-03-30"
//                }
//            ],
//            "endedGoal": [
//                {
//                    "goalId": 13,
//                    "goalTitle": "title",
//                    "icon": "icon",
//                    "totalBudget": 30000,
//                    "totalCost": 0,
//                    "endDate": "2024-01-30"
//                }
//                // 추가적인 데이터는 생략됨...
//            ],
//            "hasNext": true
//        }
//    }
//    """
//
//    guard let jsonData = jsonString.data(using: .utf8) else {
//        fatalError("Invalid JSON string")
//    }
//
//    do {
//        let response = try JSONDecoder().decode(NotNowResponse.self, from: jsonData)
//        print("isSuccess: \(response.isSuccess)")
//        print("Message: \(response.message)")
//        print("Future Goals Count: \(response.result.futureGoal.count)")
//        print("Ended Goals Count: \(response.result.endedGoal.count)")
//        print("Has Next: \(response.result.hasNext)")
//        
//        if let firstEndedGoal = response.result.endedGoal.first {
//            print("First Ended Goal ID: \(firstEndedGoal.goalID)")
//            print("First Ended Goal Title: \(firstEndedGoal.goalTitle)")
//            print("First Ended Goal Total Budget: \(firstEndedGoal.totalBudget)")
//            if let totalCost = firstEndedGoal.totalCost {
//                print("First Ended Goal Total Cost: \(totalCost)")
//            }
//        }
//    } catch {
//        print("Decoding error: \(error)")
//    }
//}
//
