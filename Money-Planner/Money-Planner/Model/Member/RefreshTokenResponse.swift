//
//  RefreshTokenResponse.swift
//  Money-Planner
//
//  Created by p_kxn_g on 3/7/24.
//

import Foundation

struct RefreshTokenResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: TokenInfo?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
    
    struct TokenInfo: Decodable {
        let type: String
        let accessToken : String
        let refreshToken : String
        
        enum TokenInfo: String, CodingKey {
            case type
            case accessToken
            case refreshToken
        }
    }
    
    
}
