//
//  Repo.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/1/24.
//

import Foundation

struct ConnectModel: Decodable {
    let isSuccess: Bool
    let message: String?
    let result: ResultType?

    struct ResultType: Decodable {
        let key1: String
        let key2: Int
        // ... 다른 속성들
    }

    private enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
}
