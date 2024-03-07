//
//  LoginAPI.swift
//  Money-Planner
//
//  Created by p_kxn_g on 3/7/24.
//

import Foundation
import Moya

enum LoginAPI {
    // Member Controller
    case refreshToken( refreshToken : RefreshTokenRequest)
    case loginKakao
    case loginApple
    case connect

}

extension LoginAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.209.182.17:8080")!
    }
    
    var path: String {
        switch self {
            // Member Controller
        case .refreshToken:
            return "/api/member/refresh-token"
        case .loginKakao:
            return "/api/member/login/kakao"
        case .loginApple:
            return "/api/member/login/apple"
        case .connect:
            return "/api/member/connect"
        }
    }
    
    var method: Moya.Method {
        switch self {
            // Define HTTP methods for each API endpoint
        case .refreshToken, .loginKakao, .loginApple:
            return .post
        case .connect:
            return .get
        }
    }
    
    // Define request parameters for each API endpoint
    var task: Task {
        switch self {
        case  .loginKakao, .loginApple, .connect:
            return .requestPlain
        case .refreshToken(let refreshTokenRequest):
            return .requestJSONEncodable(refreshTokenRequest)
            
        }
        
    }
    
    // Define sample data for each API endpoint
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return nil
    }
}


