//
//  CreateCategoryResponse.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/18/24.
//

import Foundation

struct CreateCategoryRequest: Codable {
    let name: String
    let icon: String
   

    enum CodingKeys: String, CodingKey {
        case name
        case icon
    }

   
}
