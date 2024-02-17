//
//  CreateCategoryResponse.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/18/24.
//

import Foundation

struct CreateCategoryResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: CategoryDTO

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
  
    struct CategoryDTO: Decodable {
        let categoryId: Int64
   

        enum CodingKeys: String, CodingKey {
            case categoryId
        }
    }
 
    
}


