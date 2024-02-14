import Foundation
import Moya

enum HomeAPI  {
    // 홈 화면의 첫 API 요청
    case getHomeNow
    case getGoalList
    // 목표 없을때 달력 넘길 떄
    case getCalendarListWithDate(yearMonth : String)
    // 목표 있을때 달력 넘길 떄
    case getCalendarListWithGoal(goalId : Int, yearMonth : String)
    // 소비탭
    case getExpenseList( yearMonth : String?, size : Int?, goalId : Int?, order : String?, lastDate : String?, lastExpenseId : Int?, categoryId : Int?)
    
}

extension HomeAPI : BaseAPI {
    
    public var task: Task {
        switch self {
        case .getHomeNow, .getGoalList, .getCalendarListWithGoal:
            return .requestPlain
        case .getCalendarListWithDate(let yearMonth):
            let parameters: [String: String] = ["yearMonth": yearMonth]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getExpenseList(let yearMonth, let size, let goalId, let order, let lastDate, let lastExpenseId, let categoryId):
            var parameters: [String: Any] = [:]

            if let yearMonth = yearMonth {
                parameters["yearMonth"] = yearMonth
            }
            if let size = size {
                parameters["size"] = size
            }
            if let goalId = goalId {
                parameters["goalId"] = goalId
            }
            if let order = order {
                parameters["order"] = order
            }
            if let lastDate = lastDate {
                parameters["lastDate"] = lastDate
            }
            if let lastExpenseId = lastExpenseId {
                parameters["lastExpenseId"] = lastExpenseId
            }
            if let categoryId = categoryId {
                parameters["categoryId"] = categoryId
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getHomeNow, .getGoalList, .getCalendarListWithDate, .getCalendarListWithGoal, .getExpenseList:
            return .get
        }
    }
    
    public var path : String {
        switch self {
        case .getHomeNow:
            return "/api/home/now"
        case .getGoalList:
            return "/api/goal/list"
        case .getCalendarListWithDate:
            return "/api/home/basic"
        case .getCalendarListWithGoal(let goalId, let yearMonth):
            return "/api/home/goal/\(goalId)/\(yearMonth)"
        case .getExpenseList:
            return "/api/expense/monthly"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMjkwMTA2OTM0IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MDc4ODk1NzJ9.ECMCrOsH6ee6Q6bbkkjILlbGqYzp-Ni3aRhxgfIGSns"]
    }
}
