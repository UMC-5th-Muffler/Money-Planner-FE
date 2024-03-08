//
//  GoalAPI.swift
//  Money-Planner
//
//  Created by 유철민 on 1/26/24.
//

import Foundation
import RxMoya
import Moya
import RxSwift

enum GoalAPI : TargetType {
    
    //가능
    case postGoal(request: PostGoalRequest)
    
    //모름
    case deleteGoal(goalId: Int)
    case getGoalDetail(goalId: String)
    
    //가능
    case now
    case notNow(endDate: String?)
    case getGoalReport(goalId: String)
    case getWeeklyExpenses(goalId: String, startDate: String, endDate: String, size: String, lastDate: String?, lastExpenseId: String?)
    
    //시험
    case getPreviousGoals
    case postContent(request: PostGoalRequest)
}

extension GoalAPI : BaseAPI {
    
    var headers: [String: String]? {
        // Replace 'YourTokenHere' with the actual bearer token.
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMjkwMTA2OTM0IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MDk4OTE3MzF9.qZ5Ee8XIIAcXNzYAZXXdfQFmFSOoUvKhyQxZHl88S7s"]
    }
    
    var path: String {
        switch self {
        case .postGoal(let request):
            return "/api/goal"
        case .deleteGoal(let goalId):
            return "/api/goal/\(goalId)"
        case .getGoalDetail(let goalId):
            return "/api/goal/\(goalId)"
        case .getGoalReport(let goalId):
            return "/api/goal/report/\(goalId)" // 새로운 경로 추가
        case .getWeeklyExpenses:
            return "/api/expense/weekly"
        case .now:
            return "/api/goal/now"
        case .notNow:
            return "/api/goal/not-now"
        case .getPreviousGoals:
            return "/api/goal/previous"
        case .postContent :
            return "/api/goal"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .now:
            return .get
        case .postGoal:
            return .post
        case .getGoalDetail:
            return .get
        case .getWeeklyExpenses:
            return .get
        case .deleteGoal:
            return .delete
        case .postContent:
            return .post
        case .getGoalReport:
            return .get
        default :
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postGoal(let request):
            return .requestJSONEncodable(request)
        case .getGoalReport: // getGoalReport 추가
            return .requestPlain
        case .now:
            return .requestPlain
        case .notNow(let endDate):
            var parameters: [String: Any] = [:]
            if let endDate = endDate {
                parameters["endDate"] = endDate
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getGoalDetail:
            return .requestPlain
        case .getWeeklyExpenses(let goalId, let startDate, let endDate, let size, let lastDate, let lastExpenseId):
            var parameters: [String: Any] = ["goalId": goalId, "startDate": startDate, "endDate": endDate, "size": size]
            if let lastDate = lastDate {
                parameters["lastDate"] = lastDate
            }
            if let lastExpenseId = lastExpenseId {
                parameters["lastExpenseId"] = lastExpenseId
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .deleteGoal:
            return .requestPlain
            
        case .postContent(let request):
            return .requestJSONEncodable(request)
            
        default:
            return .requestPlain
        }
    }
    
    var sampleData: Data { return Data() }
}
