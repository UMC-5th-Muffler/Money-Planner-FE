////
////  GoalAPI.swift
////  Money-Planner
////
////  Created by 유철민 on 1/12/24.
////
//
//import Foundation
//import Moya
//
//enum GoalAPI {
//    
//    case createGoal(params: CreateGoalRequest)
//    case loadGoal(type: String, identifier: String)
//    case updateGoal(type: String, identifier: String, Goal_id: Int, title: String?, comment: String?, url: URL?, thumbURL: URL?, noti_cycle: Int?, noti_preset: Int?)
//    case deleteGoal(type: String, identifier: String, Goal_id: Int)
//}
//
//extension GoalAPI: TargetType {
//    
//    var path: String {
//        switch self {
//        case .createGoal, .loadGoal:
//            return "/Goal"
//        case .updateGoal(_, _, let Goal_id, _, _, _, _, _, _), .deleteGoal(_, _, let Goal_id):
//            return "/Goal/\(Goal_id)"
//        }
//    }
//
//    var method: Moya.Method {
//        switch self {
//        case .createGoal:
//            return .post
//        case .loadGoal:
//            return .get
//        case .updateGoal:
//            return .put
//        case .deleteGoal:
//            return .delete
//        }
//    }
//    
//    
//    var task: Task {
//        switch self {
//        case .createGoal(let params):
//            return .requestJSONEncodable(params)
//            
//        case .loadGoal(let type, let identifier):
//            let params: [String: Any] = ["type": type, "identifier": identifier]
//            
//            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
//            
//        case .updateGoal(let type, let identifier, _, let title, let comment, let url, let thumbURL, let noti_cycle, let noti_preset):
//            var parameters: [String: Any] = ["type": type, "identifier": identifier]
//            var bodyParams: [String: Any] = [:]
//            if let title = title { bodyParams["title"] = title }
//            if let comment = comment { bodyParams["comment"] = comment }
//            if let url = url?.absoluteString { bodyParams["url"] = url }
//            if let thumbURL = thumbURL?.absoluteString { bodyParams["thumbURL"] = thumbURL }
//            if let noti_cycle = noti_cycle { bodyParams["noti_cycle"] = noti_cycle }
//            if let noti_preset = noti_preset { bodyParams["noti_preset"] = noti_preset }
//
//            return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: JSONEncoding.default, urlParameters: parameters)
//
//            
//        case .deleteGoal(let type, let identifier, _):
//            let parameters = ["type": type, "identifier": identifier]
//
//            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
//        }
//        
//    }
//}
