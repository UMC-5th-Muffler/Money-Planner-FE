//
//  UpdateExpenseRequest.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/14/24.
//

import Foundation

struct UpdateExpenseRequest: Encodable {
    var expenseId: Int64
    var expenseCost : Int64
    var categoryId: Int64
    var expenseTitle: String
    var expenseMemo: String
    var expenseDate: String
   
}
