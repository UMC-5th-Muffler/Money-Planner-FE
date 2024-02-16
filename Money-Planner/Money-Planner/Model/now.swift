//
//  now.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation

struct NowResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: Goal_
}

//struct Goal_: Codable {
//    let goalID: Int
//    let goalTitle: String
//    let icon: String
//    let totalBudget: Int64
//    let totalCost: Int64?
//    let endDate: String
//    
//    enum CodingKeys: String, CodingKey {
//        case goalID = "goalId"
//        case goalTitle, icon, totalBudget, totalCost, endDate
//    }
//}
