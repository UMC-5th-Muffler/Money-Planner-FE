

import Foundation
import Moya

enum ExpenseAPI  {
    case getSearchExpense(title : String, order : String?, size: Int?)
    case getDailyConsumeHistory(date: String, size: Int?, lastExpenseId: Int?)
    
}

extension ExpenseAPI : BaseAPI {
    
    // request 데이터 제작(요청 파라미터 제작)
    public var task: Task {
        switch self {
        case .getSearchExpense(let title, let order, let size):
            var parameters: [String: Any] = [:]
            
            parameters["title"] = title
        
            
            if let order = order {
                parameters["order"] = order
            }
            
            if let size = size {
                parameters["size"] = size
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .getDailyConsumeHistory(let date, let size, let lastExpenseId):
            var parameters: [String: Any] = ["date": date]
            if let size = size {
                parameters["size"] = size
            }
            if let lastExpenseId = lastExpenseId {
                parameters["lastExpenseId"] = lastExpenseId
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    public var method: Moya.Method {
        // 파라미터값을 통신요청 타입을 제작
        switch self {
        case .getSearchExpense, .getDailyConsumeHistory:
            return .get
        }
    }
    
    public var path : String {
        switch self {
        case .getSearchExpense:
            return "/api/expense/search"
        case .getDailyConsumeHistory:
            return "/api/expense/daily"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMjkwMTA2OTM0IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MDgwNzQ1NTJ9.y1-7jbsain9TEDcLDN0A3daNvtK0xUwRqM1-ASvJARU"] // 억세스토큰
        // 실제 사용하는 헤더로 변경해야 합니다.
    }
}
