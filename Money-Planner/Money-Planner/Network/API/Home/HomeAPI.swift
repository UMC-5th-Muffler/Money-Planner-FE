import Foundation
import Moya

enum HomeAPI  {
    // 홈 화면의 첫 API 요청
    case getHomeNow
    case getGoalList

}

extension HomeAPI : BaseAPI {

    public var task: Task {
        switch self {
        case .getHomeNow, .getGoalList:
            return .requestPlain
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getHomeNow, .getGoalList:
            return .get
        }
    }
    
    public var path : String {
        switch self {
        case .getHomeNow:
            return "/api/home/now"
        case .getGoalList:
            return "/api/goal/list"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer "]
    }
}
