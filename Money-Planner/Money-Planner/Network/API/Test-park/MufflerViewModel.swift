//
//  GitHubViewModel.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/1/24.
//

import Foundation
import RxSwift
import RxMoya
import Moya

class MufflerViewModel {
    private let provider = MoyaProvider<MufflerAPI>().rx

    // Member Controller
//    func refreshToken() -> Observable<MyRepo> {
//        return provider.request(.refreshToken)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//    func loginKakao() -> Observable<MyRepo> {
//        return provider.request(.loginKakao)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func loginApple() -> Observable<MyRepo> {
//        return provider.request(.loginApple)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
    func connect() -> Observable<ConnectModel> {
        return provider.request(.connect)
            .map(ConnectModel.self)
            .asObservable()
    }
//
//    // Goal Controller
//    func createGoal() -> Observable<MyRepo> {
//        return provider.request(.createGoal)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getPreviousGoals() -> Observable<MyRepo> {
//        return provider.request(.getPreviousGoals)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func deleteGoal(goalId: String) -> Observable<MyRepo> {
//        return provider.request(.deleteGoal(goalId: goalId))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    // Expense Controller
    // 소비내역 등록
    func createExpense(expenseRequest: ExpenseCreateRequest) -> Single<ExpenseCreateResponse> {
        return provider.request(.createExpense(expenseRequest: expenseRequest))
                .map(ExpenseCreateResponse.self)
    }
    // 소비내역 수정
    func updateExpense(expenseRequest: UpdateExpenseRequest) -> Single<ExpenseCreateResponse> {
        return provider.request(.updateExpense(expenseRequest: expenseRequest))
            .map(ExpenseCreateResponse.self)
    }
    // 소비내역 조회
    func getExpense(expenseId: Int64) -> Observable<ResponseExpenseDto> {
        return provider.request(.getExpense(expenseId: expenseId))
            .map(ResponseExpenseDto.self)
            .asObservable()
    }
    // 소비내역 삭제
    func deleteExpense(expenseId: Int64) -> Observable<ConnectModel> {
        return provider.request(.deleteExpense(expenseId: expenseId))
            .map(ConnectModel.self).asObservable()
    }
//
//    func getWeeklyExpense() -> Observable<MyRepo> {
//        return provider.request(.getWeeklyExpense)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func searchExpense() -> Observable<MyRepo> {
//        return provider.request(.searchExpense)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getMonthlyExpense() -> Observable<MyRepo> {
//        return provider.request(.getMonthlyExpense)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getDailyExpense() -> Observable<MyRepo> {
//        return provider.request(.getDailyExpense)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
    // Category Controller
    func getCategoryFilter() -> Observable<ResponseGetCategoryListResponse> {
        return provider.request(.getCategoryFilter)
            .map(ResponseGetCategoryListResponse.self)
            .asObservable()
    }
//
//    // Rate Controller
//    func updateRate(date: String) -> Observable<MyRepo> {
//        return provider.request(.updateRate(date: date))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getRates() -> Observable<MyRepo> {
//        return provider.request(.getRates)
//            .map(MyRepo.self)
//            .asObservable()
//    }
    // daily plan controller
//    // 제로데이 확인
//    func checkZeroDay(expenseRequest: ZeroDayRequest) -> Single<ConnectModel> {
//        return provider.request((expenseRequest: expenseRequest))
//            .map(ConnectModel.self)
//    }
//    // Home Controller
//    func getNow() -> Observable<MyRepo> {
//        return provider.request(.getNow)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getGoal(goalId: String) -> Observable<MyRepo> {
//        return provider.request(.getGoal(goalId: goalId))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getGoalByYearMonth(goalId: String, yearMonth: String) -> Observable<MyRepo> {
//        return provider.request(.getGoalByYearMonth(goalId: goalId, yearMonth: yearMonth))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getGoalByCategory(goalId: String, categoryId: String) -> Observable<MyRepo> {
//        return provider.request(.getGoalByCategory(goalId: goalId, categoryId: categoryId))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getBasicHomeInfo() -> Observable<MyRepo> {
//        return provider.request(.getBasicHomeInfo)
//            .map(MyRepo.self)
//            .asObservable()
//    }
}
