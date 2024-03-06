//
//  GoalRepository.swift
//  Money-Planner
//
//  Created by 유철민 on 1/30/24.
//

import Foundation
import RxSwift
import Moya

enum NetworkError: Error {
    case nilResponse
    case decodingError
    // 기타 네트워크 관련 에러
}


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
    
    
    func getGoalDetail(goalId: String) -> Single<GoalDetailResponse> {
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
    
    func getGoalReport(goalId: String) -> Single<GoalReportResponse> {
        return provider.rx.request(.getGoalReport(goalId: goalId))
            .filterSuccessfulStatusCodes()
            .map(GoalReportResponse.self)
    }
    
    func getWeeklyExpenses(goalId: String, startDate: String, endDate: String, size: String, lastDate: String? = nil, lastExpenseId: String? = nil) -> Single<WeeklyExpenseResponse> {
        return provider.rx.request(.getWeeklyExpenses(goalId: goalId, startDate: startDate, endDate: endDate, size: size, lastDate: lastDate, lastExpenseId: lastExpenseId))
            .filterSuccessfulStatusCodes()
            .map(WeeklyExpenseResponse.self)
    }
    
    func postContent( icon: String, title: String, startDate : String, endDate : String, totalBudget : Int64, categoryGoals : [CategoryGoal], dailyBudgets: [Int64], completion: @escaping (Result<Goal?, BaseError>) -> Void){
        
        let request = PostGoalRequest(icon: icon, title: title, startDate: startDate, endDate: endDate, totalBudget: totalBudget, categoryGoals: categoryGoals, dailyBudgets: dailyBudgets)
        
        provider.request(.postContent(request: request)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<Goal>.self)
                    print(response)
                    if(response.isSuccess!){
                        completion(.success(response.result))
                    }else{
                        completion(.failure(.failure(message: response.message!)))
                    }
                    
                } catch {
                    // 디코딩 오류 처리
                    print("Decoding error: \(error)")
                }
            case let .failure(error):
                // 네트워크 요청 실패 처리
                print("Network request failed: \(error)")
                completion(.failure(.networkFail(error: error)))
            }
        }
    }
    
}

