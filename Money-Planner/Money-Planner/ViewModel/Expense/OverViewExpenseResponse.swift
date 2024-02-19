//
//  OverViewExpenseResponse.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/18/24.
//

import Foundation

struct OverViewExpenseResponse: Decodable {
    let isSuccess: Bool
    let message: String
    let result: ExpenseOverView

    enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case result
    }
    struct ExpenseOverView : Decodable {
        let overview: [ZeroDayInfo]?

        enum CodingKeys: String, CodingKey {
            case overview
        }
    }
    struct ZeroDayInfo: Decodable {
        let date: String
        let zeroDay : Bool
       
        enum CodingKeys: String, CodingKey {
            case date, zeroDay
        }
    }

}


