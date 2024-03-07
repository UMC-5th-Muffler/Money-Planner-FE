//
//  RefreshTokenResponse.swift
//  Money-Planner
//
//  Created by p_kxn_g on 3/7/24.
//

import Foundation

struct RefreshTokenResponse: Codable {
    let isSuccess: Bool
    let message: String
    let result: ResultType

    struct ResultType: Codable {
        let type: String
        let accessToken : String
        let refreshToken : String

        enum CodingKeys: String, CodingKey {
            case type, accessToken, refreshToken
        }
    }
   

    private enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
}
