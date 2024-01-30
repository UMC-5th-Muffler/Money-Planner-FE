//
//  TestAPI.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/30.
//

import Foundation
import Moya

enum TestAPI  {
    
    ///클라이메이트 서비스에서 최근 업데이트 모델을 요청
    case getTest

}

extension TestAPI : BaseAPI {

    // request 데이터 제작(요청 파라미터 제작)
    public var task: Task {
        switch self {
        case .getTest:
//            var params: [String: Any] = [:]
//            var reqBody : [String: Any] = [:]
//            params["reqCode"] = "102"
//
//            for param in getParameter {
//                reqBody[param.key] = param.value
//            }
//            params["reqBody"] = reqBody
//            let paramsJson = try? JSONSerialization.data(withJSONObject:params)
            return .requestPlain
        }
    }
    
    public var method: Moya.Method {
// 파라미터값을 통신요청 타입을 제작
        switch self {
        case .getTest:
            return .get
        }
    }
    
    public var path : String {
        switch self {
        case .getTest:
            return "/api/member/connect"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer ??"]
        // 실제 사용하는 헤더로 변경해야 합니다.
    }
}
