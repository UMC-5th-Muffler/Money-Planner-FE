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
            // Update properties based on the actual dictionary structure
            let key1: String
            let key2: Int
            // ...
        }
}
