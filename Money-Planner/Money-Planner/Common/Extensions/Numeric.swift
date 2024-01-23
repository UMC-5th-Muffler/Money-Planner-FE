//
//  Numeric.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/23.
//

import Foundation

extension Numeric {
    func formattedWithSeparator() -> String {
        return Formatter.decimalFormatter.string(for: self) ?? ""
    }
}
