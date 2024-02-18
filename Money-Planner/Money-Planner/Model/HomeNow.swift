//
//  HomeNow.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/01.
//

import Foundation

struct HomeNow : Codable {
    let calendarInfo : Goal?
    let dailyList: [CalendarDaily]?
}
