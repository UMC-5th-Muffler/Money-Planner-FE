//
//  DeleteCategoryRequest.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/19/24.
//

import Foundation

struct DeleteCategoryResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: DeleteCategory?

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
    struct DeleteCategory: Decodable {
        let updatedRoutineRows: Int32


        enum CodingKeys: String, CodingKey {
            case updatedRoutineRows
        }
    }
}
   







