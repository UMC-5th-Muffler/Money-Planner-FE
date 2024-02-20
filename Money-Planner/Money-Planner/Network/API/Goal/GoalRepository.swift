//
//  GoalRepository.swift
//  Money-Planner
//
//  Created by 유철민 on 1/30/24.
//

import Foundation
import RxSwift
import Moya

final class GoalRepository {
    
    static let shared = GoalRepository()
    private let provider = MoyaProvider<GoalAPI>()
    
    private init() {}
    
    // 현재 진행 중인 목표를 가져오는 메서드
    func getNowGoal() -> Single<NowResponse> {
        return provider.rx.request(.now)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(NowResponse.self)
    }
    
    // 과거 및 미래의 목표들을 가져오는 메서드
    func getNotNowGoals(endDate: String? = nil) -> Single<NotNowResponse> {
        return provider.rx.request(.notNow(endDate: endDate))
            .filterSuccessfulStatusCodes()
            .map(NotNowResponse.self)
    }
    
    // 목표 상세 페이지 상단 정보를 가져오는 메서드
    func getGoalDetail(goalId: Int) -> Single<GoalDetailResponse> {
        return provider.rx.request(.getGoalDetail(goalId: goalId))
            .filterSuccessfulStatusCodes()
            .map(GoalDetailResponse.self)
    }
    
    // 목표를 생성하는 메서드
    func postGoal(request: PostGoalRequest) -> Single<PostGoalResponse> {
        return provider.rx.request(.postGoal(request: request))
            .filterSuccessfulStatusCodes()
            .map(PostGoalResponse.self)
    }
    
    // 목표를 삭제하는 메서드
    func deleteGoal(goalId: Int) -> Single<DeleteGoalResponse> {
        return provider.rx.request(.deleteGoal(goalId: goalId))
            .filterSuccessfulStatusCodes()
            .map(DeleteGoalResponse.self)
    }
    
    // 이미 만든 목표들의 기간 전부 불러오기
    func getPreviousGoals() -> Single<PreviousGoalResponse> {
        return provider.rx.request(.getPreviousGoals)
            .filterSuccessfulStatusCodes()
            .map(PreviousGoalResponse.self)
    }
    
    // 목표 상세페이지에서 소비내역 불러오는 용도.
    func getGoalExpenses(goalId: Int, startDate: String, endDate: String, size: Int, lastDate: String?, lastExpenseId: Int?) -> Single<GoalExpenseResponse> {
        return provider.rx.request(.goalExpense(goalId: goalId, startDate: startDate, endDate: endDate, size: size, lastDate: lastDate, lastExpenseId: lastExpenseId))
            .filterSuccessfulStatusCodes()
            .map(GoalExpenseResponse.self)
    }
    
    // 목표 상세페이지의 목표 리포트용
    func getGoalReport(goalId: Int) -> Single<GoalReportResponse> {
        return provider.rx.request(.goalReport(goalId: goalId))
            .filterSuccessfulStatusCodes()
            .map(GoalReportResponse.self)
    }
    
}

