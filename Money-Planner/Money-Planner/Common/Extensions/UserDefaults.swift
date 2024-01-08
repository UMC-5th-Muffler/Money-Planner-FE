//
//  UserDefaults.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/08.
//

import Foundation

extension UserDefaults {
    static var group : UserDefaults{
        let appGroupId = "group.com.umc.Money-Planner"
        return UserDefaults(suiteName: appGroupId)!
    }
}
