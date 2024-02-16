//
//  GoalAPI.swift
//  Money-Planner
//
//  Created by 유철민 on 1/26/24.
//

import Foundation
import Moya

enum GoalAPI {
    case getPreviousGoals
    case postGoal(request: PostGoalRequest)
    case deleteGoal(goalId: Int)
}

extension GoalAPI: BaseAPI {
    
    public var task: Task {
        switch self {
        case .getPreviousGoals:
            return .requestPlain
            
        case .postGoal(let request):
            // Here we are encoding the request as JSON
            return .requestJSONEncodable(request)
            
        case .deleteGoal(let goalId):
            // If you need to pass the goalId within the request body or as a URL parameter,
            // adjust the task accordingly.
            return .requestParameters(parameters: ["goalId": goalId], encoding: URLEncoding.default)
        }
    }

    var method: Moya.Method {
        switch self {
        case .getPreviousGoals:
            return .get
        case .postGoal:
            return .post
        case .deleteGoal:
            return .delete
        }
    }

    
    var path: String {
        switch self {
        case .getPreviousGoals:
            return "/api/goal/previous"
        case .postGoal:
            return "/api/goal"
        case .deleteGoal:
            return "/api/goal/{goalId}"
        }
    }
    
    var headers: [String: String]? {
        // Replace 'YourTokenHere' with the actual bearer token.
        return ["Authorization": "Bearer YourTokenHere"]
    }

    var sampleData: Data {
        // Provide a sample JSON response in Data type if needed for tests.
        return "{\"isSuccess\": true, \"message\": \"Success\", \"result\": {\"terms\": [{\"startDate\": \"2024-01-30\", \"endDate\": \"2024-01-30\"}]}}".data(using: .utf8)!
    }
}
