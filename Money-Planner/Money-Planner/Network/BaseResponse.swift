//
//  BaseResponse.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/31.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let isSuccess: Bool?
    let message: String?
    let result: T?
    
    // CodingKey는 json에서 예를 들어 msg 이런 형식으로 왔으면 msg를
    // message로 연결할 수 있게 도와주는 프로토콜
    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isSuccess = try values.decode(Bool.self, forKey: .isSuccess)
        message = try values.decode(String.self, forKey: .message)
        result = try values.decode(T.self, forKey: .result)
    }
}
