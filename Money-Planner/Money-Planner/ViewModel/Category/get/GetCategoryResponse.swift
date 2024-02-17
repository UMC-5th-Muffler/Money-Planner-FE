//
//  GetCategoryResponse.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/18/24.
//

import Foundation
// api/category
// 카테고리 조회 시 사용하는 구조
struct GetCategoryResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: GetCategoryListResponse

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
    struct GetCategoryListResponse: Decodable {
        let categories: [CategoryDTO]

        enum CodingKeys: String, CodingKey {
            case categories
        }
    }
    struct CategoryDTO: Decodable {
        let categoryId: Int64
        let name: String
        let icon: String
        let priority : Int64
        let isVisible : Bool
        let type : String

        enum CodingKeys: String, CodingKey {
            case categoryId, name, icon, priority, isVisible,type
        }
    }
    enum type: String, Decodable {
        case DEFAULT = "DEFAULT"
        case CUSTOM = "CUSTOM"
      
    }
    
}






