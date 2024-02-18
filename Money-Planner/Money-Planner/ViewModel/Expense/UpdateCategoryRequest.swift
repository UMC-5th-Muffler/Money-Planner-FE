//
//  UpdateCategoryRequest.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/19/24.
//

import Foundation
struct UpdateCategoryRequest: Codable {
    let categoryId : Int64
    let name: String
    let icon: String
   

    enum CodingKeys: String, CodingKey {
        case categoryId
        case name
        case icon
    }

   
}
