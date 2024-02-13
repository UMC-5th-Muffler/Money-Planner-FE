//
//  ExpenseIDResponse.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/14/24.
//

import Foundation

struct ResponseExpenseDto: Decodable {
    let isSuccess: Bool
    let message: String
    let result: ExpenseDto

    struct ExpenseDto: Decodable {
        let expenseId: Int64
        let date: String
        let title: String
        let memo: String
        let cost: Int64
        let categoryId: Int64
        let categoryName: String
        let categoryIcon: String
    }
}
