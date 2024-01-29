//
//  Category.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/21.
//

import Foundation

// MARK: - Category
struct Category: Codable, Identifiable {
    let id: Int
    let name: String
    var categoryBudget: Int? = 0
}
