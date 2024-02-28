//
//  User.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/3/24.
//

import Foundation
import UIKit

struct User {
    var userNameString: String = "조혜원"
    
    mutating func changeUserName(_ name: String) {
        userNameString = name
    }
}
