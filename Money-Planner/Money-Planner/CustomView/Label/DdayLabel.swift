//
//  Dday.swift
//  Money-Planner
//
//  Created by 유철민 on 2/7/24.
//

import Foundation
import UIKit

class DdayLabel: MPLabel {

    // You can add custom initialization if needed
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // Common setup for the DdayLabel
    private func commonInit() {
        self.textAlignment = .center
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        // Any other common setup can go here
    }
    
    // Method to configure the label for a specific goal
    func configure(for goal: GoalDetail) {
        self.font = .mpFont14B()

        let currentDate = Date()
        let isPastGoal = currentDate > goal.endDate.toMPDate() ?? Date()
        let isFutureGoal = currentDate < goal.startDate.toMPDate() ?? Date()

        let daysLeft = isPastGoal ? 0 : Calendar.current.dateComponents([.day], from: currentDate, to: goal.endDate.toMPDate() ?? Date()).day ?? 0

        var ddayText = "D-\(daysLeft)"
        self.backgroundColor = UIColor.mpCalendarHighLight
        self.textColor = UIColor.mpMainColor

        if isPastGoal {
            ddayText = "종료"
            self.backgroundColor = UIColor.mpLightGray
            self.textColor = UIColor.mpDarkGray
        } else if isFutureGoal {
            ddayText = "시작 전"
            self.backgroundColor = UIColor.mpLightGray
            self.textColor = UIColor.mpDarkGray
        } else {
            if daysLeft == 0 {
                ddayText = "D-Day"
            } else {
                ddayText = "D-\(daysLeft)"
            }
        }

        self.text = ddayText
    }
}
