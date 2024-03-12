//
//  BaseAPI.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/31.
//

import Foundation
import Moya

//Moya 라이브러리의 타겟타입을 기본적으로 종속한 BaseAPI
protocol BaseAPI: TargetType {
    
}
//기본값을 세팅
extension BaseAPI {
    var baseURL: URL {
        let url = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
        let serverURL = "https://muffler.world/" + url
        return URL(string: serverURL)!
    }
    
    var path: String {
        return ""
    }
    
    // method 이 없을경우 default는 get 방식
    var method: Moya.Method { .get }
    var sampleData: Data { Data() }
    var task: Task { .requestPlain }
    var headers: [String: String]? { nil }
}
