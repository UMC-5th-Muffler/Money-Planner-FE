//
//  CategoryFilterResponse.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/16/24.
//

import Foundation

struct ResponseGetCategoryListResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: GetCategoryListResponse

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
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

    enum CodingKeys: String, CodingKey {
        case categoryId
        case name
        case icon
    }
}



