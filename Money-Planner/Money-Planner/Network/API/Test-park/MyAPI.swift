// GitHubAPI.swift
import Foundation
import Moya

enum MyAPI {
    case getUserRepos
}

extension MyAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.209.182.17:8080")!
    }

    var path: String {
        switch self {
        case .getUserRepos:
            return "/api/member/connect"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMzI0NjEzNzk1IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MDY4Njc2NzN9.SV_8eU2l19lQL87eGKHkAjy2Ls7sVRsDznWkZ4dJlOE"]
    }
}
