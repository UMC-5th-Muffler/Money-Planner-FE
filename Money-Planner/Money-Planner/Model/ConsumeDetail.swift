//
//  ConsumeDetail.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/23.
//

import Foundation

struct ConsumeDetail: Codable {
    let expenseId: Int
    let title: String
    let cost: Int
    let categoryIcon: String

    enum CodingKeys: String, CodingKey {
        case expenseId, title, cost, categoryIcon
    }
}
