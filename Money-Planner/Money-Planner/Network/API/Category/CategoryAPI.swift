import Foundation
import Moya

enum CategoryAPI  {
    case getCategoryFilteredList
    case getCategoryAllList
    case updateCategoryFilter(categories : CategoryList)
}

extension CategoryAPI : BaseAPI {
    
    public var task: Task {
        switch self {
        case .getCategoryFilteredList, .getCategoryAllList:
            return .requestPlain
        case .updateCategoryFilter(let categories):
            return .requestJSONEncodable(categories)
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getCategoryFilteredList, .getCategoryAllList:
            return .get
        case .updateCategoryFilter:
            return .patch
        }
    }
    
    public var path : String {
        switch self {
        case .getCategoryFilteredList:
            return "/api/category/filter"
        case .getCategoryAllList:
            return "/api/category"
        case .updateCategoryFilter:
            return "/api/category/filter"
        }
    }
    
    public var headers: [String: String]? {
        return ["Authorization": "Bearer "]
    }
}
