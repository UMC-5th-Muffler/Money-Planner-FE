

import Foundation
import Moya

enum ExpenseAPI  {
    case getSearchExpense(title : String, order : String?, size: Int?)
    
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
        }
    }
    
    public var method: Moya.Method {
        // 파라미터값을 통신요청 타입을 제작
        switch self {
        case .getSearchExpense:
            return .get
        }
    }
    
    public var path : String {
        switch self {
        case .getSearchExpense:
            return "/api/expense/search"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer "] // 억세스토큰
        // 실제 사용하는 헤더로 변경해야 합니다.
    }
}
