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
    // 소비등록
    func createExpense(expenseRequest: ExpenseCreateRequest) -> Single<ExpenseCreateResponse> {
        return provider.request(.createExpense(expenseRequest: expenseRequest))
                .map(ExpenseCreateResponse.self)
    }
//
//    func updateExpense(expenseId: String, expenseRequest: ExpenseCreateRequest) -> Observable<MyRepo> {
//        return provider.request(.updateExpense(expenseId: expenseId, expenseRequest: expenseRequest))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getExpense(expenseId: String) -> Observable<MyRepo> {
//        return provider.request(.getExpense(expenseId: expenseId))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func deleteExpense(expenseId: String) -> Observable<MyRepo> {
//        return provider.request(.deleteExpense(expenseId: expenseId))
//            .map(MyRepo.self)
//            .asObservable()
//    }
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
//    // Category Controller
//    func createCategory() -> Observable<MyRepo> {
//        return provider.request(.createCategory)
//            .map(MyRepo.self)
//            .asObservable()
//    }
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
//
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
