//
//  Progress.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/04.
//

import Foundation

func getProgress(numerator : Int, denominator : Int) -> CGFloat{
    let progress = (Double(numerator)/Double(denominator)) > 1.0 ? 1 : CGFloat(Double(numerator)/Double(denominator))
    return progress
}
