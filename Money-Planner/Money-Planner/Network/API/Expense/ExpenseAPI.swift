import Foundation
import Moya

enum ExpenseAPI  {
    case getSearchExpense(title : String, order : String?, size: Int?)
    case getDailyConsumeHistory(date: String, size: Int?, lastExpenseId: Int?)
    case getRateInfo(date: String)
    case rateDaily(date: String, rate: String, rateMemo: String?)
    case isZeroDay(dailyPlanDate: String)
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
            
        case .getRateInfo(let date):
            let parameters: [String: Any] = ["date": date]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .rateDaily(_, let rate, let rateMemo):
            var parameters: [String: Any] = ["rate": rate]
            if let rateMemo = rateMemo {
                parameters["rateMemo"] = rateMemo
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .isZeroDay(let dailyPlanDate):
            let parameters: [String: Any] = ["dailyPlanDate": dailyPlanDate]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    public var method: Moya.Method {
        // 파라미터값을 통신요청 타입을 제작
        switch self {
        case .getSearchExpense, .getDailyConsumeHistory, .getRateInfo:
            return .get
        case .rateDaily, .isZeroDay:
            return .patch
        }
    }
    
    public var path : String {
        switch self {
        case .getSearchExpense:
            return "/api/expense/search"
        case .getDailyConsumeHistory:
            return "/api/expense/daily"
        case .getRateInfo:
            return "/api/rate"
        case .rateDaily(let date, _, _):
            return "/api/rate/\(date)"
        case .isZeroDay(_):
            return "/api/dailyPlan/zeroDay"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMjkwMTA2OTM0IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MDgyNDc1NTR9.wOH46BMT5FnNkXWts9dRuRECdtvU8px_4m86yeVnru0"] // 억세스토큰
        // 실제 사용하는 헤더로 변경해야 합니다.
    }
}
