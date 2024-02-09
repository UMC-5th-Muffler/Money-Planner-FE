//
//  Progress.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/04.
//

import Foundation

func getProgress(numerator : Int, denominator : Int) -> CGFloat{
    return CGFloat(Double(numerator)/Double(denominator))
}
