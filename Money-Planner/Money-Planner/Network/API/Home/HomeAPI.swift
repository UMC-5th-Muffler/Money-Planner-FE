import Foundation
import Moya

enum HomeAPI  {
    // 홈 화면의 첫 API 요청
    case getHomeNow

}

extension HomeAPI : BaseAPI {

    public var task: Task {
        switch self {
        case .getHomeNow:
            return .requestPlain
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getHomeNow:
            return .get
        }
    }
    
    public var path : String {
        switch self {
        case .getHomeNow:
            return "/api/home/now"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer "]
    }
}
