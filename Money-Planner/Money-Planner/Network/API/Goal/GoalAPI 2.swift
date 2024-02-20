//
//  GoalAPI.swift
//  apitrial
//
//  Created by 유철민 on 2/21/24.
//

import Foundation
import Moya

enum GoalAPI {
    case now
    case notNow(endDate: String?) // endDate를 쿼리 파라미터로 전달하기 위해 추가
    case previous
    case createGoal(CreateGoalRequest)
    case getGoal(goalId: Int64)
    case deleteGoal(goalId: Int64)
    case goalReport(goalId: Int64)
    case goalExpense(goalId: Int64, startDate: String, endDate: String, size: Int64, lastDate: String?, lastExpenseId: Int64?)
}

extension GoalAPI: TargetType {
    var baseURL: URL { return URL(string: "http://13.209.182.17:8080")! }
    
    var path: String {
        switch self {
        case .now:
            return "/api/goal/now"
        case .notNow:
            return "/api/goal/not-now"
        case .previous:
            return "/api/goal/previous"
        case .createGoal:
            return "/api/goal"
        case .getGoal(let goalId):
            return "/api/goal/\(goalId)"
        case .deleteGoal(let goalId):
            return "/api/goal/\(goalId)"
        case .goalReport(let goalId):
            return "/api/goal/report/\(goalId)"
        case .goalExpense(let goalId, _, _, _, _, _):
            return "/api/expense/weekly?goalId=\(goalId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .now:
            return .get
        case .notNow:
            return .get
        case .previous:
            return .get
        case .createGoal:
            return .post
        case .getGoal(_):
            return .get
        case .deleteGoal:
            return .delete
        case .goalReport:
            return .get
        case .goalExpense:
            return .get
            
        }
    }
    
    var task: Task {
        switch self {
        case .now:
            return .requestPlain
        case .notNow(let endDate):
            if let endDate = endDate {
                // endDate가 제공된 경우 쿼리 파라미터로 추가
                return .requestParameters(parameters: ["endDate": endDate], encoding: URLEncoding.default)
            } else {
                // endDate가 제공되지 않은 경우 단순한 GET 요청
                return .requestPlain
            }
        case .previous:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .createGoal(let request):
            // Convert the CreateGoalRequest object to a dictionary
            let parameters = try? JSONEncoder().encode(request)
            return .requestCompositeData(bodyData: parameters ?? Data(), urlParameters: [:])
        case .getGoal(let goalId):
            return .requestPlain
        case .deleteGoal:
            return .requestPlain
        case .goalReport:
            return .requestPlain
        case .goalExpense(let goalId, let startDate, let endDate, let size, let lastDate, let lastExpenseId):
            var parameters: [String: Any] = [
                "goalId": goalId,
                "startDate": startDate,
                "endDate": endDate,
                "size": size
            ]
            if let lastDate = lastDate {
                parameters["lastDate"] = lastDate
            }
            if let lastExpenseId = lastExpenseId {
                parameters["lastExpenseId"] = lastExpenseId
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
        
    }
    
    var headers: [String: String]? {
        // Replace 'YourTokenHere' with the actual bearer token.
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMjkwMTA2OTM0IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MDg0ODUzMTd9.XuzFNk-rsRpVzMjoRHnGLaAia9ghjQn66_M8w6CWNPA"]
    }
}
