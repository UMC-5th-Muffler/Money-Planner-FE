//
//  NotificationAPI.swift
//  Money-Planner
//
//  Created by Jini on 5/7/24.
//

import Foundation
import Moya

enum NotificationAPI  {
    case agreeAlarm(param: NotificationEditModel) //put
    case getAgree //get
    case deleteToken //delete
    case patchToken(token: String) //patch
    case sendToken(token: String) //post
}

extension NotificationAPI : BaseAPI {
    
    // request 데이터 제작(요청 파라미터 제작)
    public var task: Task {
        switch self {
        case .agreeAlarm(let param):
            return .requestJSONEncodable(param)
        case .getAgree:
            return .requestPlain
        case .deleteToken:
            return .requestPlain
        case .patchToken(let token):
            let parameters: [String: Any] = ["token": token]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .sendToken(let token):
            let parameters: [String: Any] = ["token": token]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    public var method: Moya.Method {
        // 파라미터값을 통신요청 타입을 제작
        switch self {
        case .agreeAlarm:
            return .put
        case .getAgree:
            return .get
        case .deleteToken:
            return .delete
        case .patchToken(_):
            return .patch
        case .sendToken(_):
            return .post
        }
    }
    
    public var path : String {
        switch self {
        case .agreeAlarm(param: _), .getAgree:
            return "/api/member/alarm/agree"
        case .deleteToken, .patchToken(_), .sendToken(_):
            return "/api/member/alarm/token"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMjkwMTA2OTM0IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MDg0MTI1Nzl9.t1NusZW7wFB2BQ7Y8jVuRTrpbWe6X8v4Enib0yfmyDA"] // 억세스토큰
        // 실제 사용하는 헤더로 변경해야 합니다.
    }
}

