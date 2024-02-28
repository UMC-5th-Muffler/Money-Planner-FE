//
//  GetRoutineIdResponse.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/21/24.
//

import Foundation

struct GetRoutineIdResponse : Decodable {
    let isSuccess: Bool
    let message: String
    let result: RoutineDetail

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
    struct RoutineDetail: Decodable {
        let routineMemo: String
        let categoryName: String
    }
 
    
}

