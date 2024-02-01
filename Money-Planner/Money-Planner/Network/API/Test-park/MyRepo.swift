//
//  Repo.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/1/24.
//

import Foundation

struct MyRepo : Decodable {
    let isSuccess: Bool
    let message: String?
    let result: ResultType?

    struct ResultType: Decodable {
        // You need to define the properties inside ResultType based on the actual response structure
    }
}
