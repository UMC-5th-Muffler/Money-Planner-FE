//
//  Category.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/21.
//

import Foundation

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
    var categoryIcon : String? = ""
    var categoryBudget: Int? = 0
}
