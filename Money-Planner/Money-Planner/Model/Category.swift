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
    var categoryIcon : String?
    let name: String
    var priority : Int?
    var categoryBudget: Int?
    var isVisible : Bool?
    var type : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "categoryId"
        case categoryIcon = "icon"
        case name, priority, isVisible, type
        
    }
}
