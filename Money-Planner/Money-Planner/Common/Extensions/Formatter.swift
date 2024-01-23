//
//  Formatter.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/23.
//

import Foundation

extension Formatter {
    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
