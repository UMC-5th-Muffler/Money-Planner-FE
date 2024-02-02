//
//  GoalRepository.swift
//  Money-Planner
//
//  Created by 유철민 on 1/30/24.
//

import Foundation
import Moya
import RxSwift


final class GoalRepository : BaseRepository<GoalAPI> {
    
    static let shared = GoalRepository()
    

    func getPreviousGoals() -> Single<GoalResponse> {
        return provider.rx.request(.getPreviousGoals)
            .filterSuccessfulStatusCodes()
            .map(GoalResponse.self)
    }
    
    func postGoal(request: PostGoalRequest) -> Single<PostGoalResponse> {
        return provider.rx.request(.postGoal(request: request))
            .filterSuccessfulStatusCodes()
            .map(PostGoalResponse.self)
    }
    
    func deleteGoal(goalId: Int) -> Single<BaseResponse<String>> {
        return provider.rx.request(.deleteGoal(goalId: goalId))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse.self)
    }
    
    
    
    
}
