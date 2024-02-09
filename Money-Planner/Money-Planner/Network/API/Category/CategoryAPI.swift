import Foundation
import Moya

enum CategoryAPI  {
    case getCategoryFilteredList
    
}

extension CategoryAPI : BaseAPI {
    
    public var task: Task {
        switch self {
        case .getCategoryFilteredList:
            return .requestPlain
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getCategoryFilteredList:
            return .get
        }
    }
    
    public var path : String {
        switch self {
        case .getCategoryFilteredList:
            return "/api/category/filter"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer "]
    }
}
