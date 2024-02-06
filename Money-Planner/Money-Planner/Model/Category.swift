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
    var categoryIcon : String? = ""
    let name: String
    var priority : Int? = -1
    var categoryBudget: Int? = 0
    var isVisible : Bool? = nil
    var type : String? = nil
    
    enum CodingKeys: String, CodingKey {
        case id = "categoryId"
        case categoryIcon = "icon"
        case name, priority, isVisible, type
        
    }
}
