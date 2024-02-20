//
//  GoalRepository.swift
//  apitrial
//
//  Created by 유철민 on 2/21/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import UIKit
import RxRelay


struct GoalServiceProvider {
    let provider = MoyaProvider<GoalAPI>()
    
    func getCurrentGoal() -> Single<NowGoalResponse> {
        return provider.rx.request(.now)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(NowGoalResponse.self)
    }
    
    func getNotNowGoal(endDate: String? = nil) -> Single<NotNowGoalResponse> {
        return provider.rx.request(.notNow(endDate: endDate))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(NotNowGoalResponse.self)
    }
    
    func getPreviousGoal() -> Single<PreviousGoalResponse> {
        return provider.rx.request(.previous)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(PreviousGoalResponse.self)
    }
    
    func createGoal(icon: String, title: String, startDate: String, endDate: String, totalBudget: Int64?, categoryGoals: [CategoryGoal], dailyBudgets: [Int64]) -> Single<CreateGoalResponse> {
        let request = CreateGoalRequest(icon: icon, title: title, startDate: startDate, endDate: endDate, totalBudget: totalBudget, categoryGoals: categoryGoals, dailyBudgets: dailyBudgets)
        
        return provider.rx.request(.createGoal(request))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(CreateGoalResponse.self)
    }
    
    func getGoal(goalId: Int64) -> Single<GoalByIdResponse> {
        return provider.rx.request(.getGoal(goalId: goalId))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(GoalByIdResponse.self)
    }
    
    func deleteGoal(goalId: Int64) -> Single<DeleteGoalResponse> {
        return provider.rx.request(.deleteGoal(goalId: goalId))
            .filterSuccessfulStatusCodes()
            .map(DeleteGoalResponse.self)
    }
    
    func getGoalReport(goalId: Int64) -> Single<GoalReportResponse> {
        return provider.rx.request(.goalReport(goalId: goalId))
            .filterSuccessfulStatusCodes()
            .map(GoalReportResponse.self)
    }
    
    func getWeeklyExpense(goalId: Int64, startDate: String, endDate: String, size: Int64, lastDate: String?, lastExpenseId: Int64?) -> Single<WeeklyExpenseResponse> {
        return provider.rx.request(.goalExpense(goalId: goalId, startDate: startDate, endDate: endDate, size: size, lastDate: lastDate, lastExpenseId: lastExpenseId))
            .filterSuccessfulStatusCodes()
            .map(WeeklyExpenseResponse.self)
    }
}
