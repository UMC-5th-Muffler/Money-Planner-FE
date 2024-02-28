//
//  GoalSpendingViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation
import RxSwift
import RxRelay

class GoalExpenseViewModel {
    
    static let shared = GoalExpenseViewModel()
    private let goalRepository = GoalRepository.shared
    
    var goalExpenses = BehaviorRelay<[DailyExpense]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    private var hasNext = true
    private var startDate: String?
    private var endDate: String?
    private var lastDate: String?
    private var lastExpenseId: Int?
    
    var goalId: Int? // 현재 조회하고 있는 목표의 ID

    private init() {}
    
    func initialFetchWeeklyExpenses(goalId: Int, startDate: String, endDate: String) {
        resetData() // 초기화
        self.goalId = goalId
        self.startDate = startDate
        self.endDate = endDate
        fetchWeeklyExpenses(goalId: goalId)
    }

    func fetchWeeklyExpenses(goalId: Int) {
//        guard let goalId = self.goalId, hasNext else { return }
//
//        if let lastDate = lastDate, let lastExpenseId = lastExpenseId, self.goalId == goalId && hasNext {
//            // Pagination 정보가 있고, 동일한 goalId에 대한 요청이고, hasNext가 true이면
//            //10개씩 페이징
//            goalRepository.getGoalExpenses(goalId: goalId, startDate: startDate!, endDate: endDate!, size: 10, lastDate: lastDate, lastExpenseId: lastExpenseId)
//                .subscribe(onSuccess: { [weak self] response in
//                    self?.processExpensesResponse(response)
//                }, onFailure: { error in
//                    print("Error fetching weekly expenses: \(error.localizedDescription)")
//                }).disposed(by: disposeBag)
//        } else if self.goalId != goalId || (hasNext && lastDate == nil && lastExpenseId == nil) {
//            print("Error: Pagination data missing despite more data being available.")
//        }
    }
    
//    private func processExpensesResponse(_ response: GoalExpenseResponse) {
//        if response.isSuccess {
//            let newExpenses = response.result.dailyExpenseList
//            self.goalExpenses.accept(self.goalExpenses.value + newExpenses)
//            
//            // Pagination 정보 업데이트
//            self.hasNext = response.result.hasNext
//            self.lastDate = newExpenses.last?.date
//            self.lastExpenseId = newExpenses.last?.expenseDetailList.last?.expenseId
//        } else {
//            self.hasNext = false
//        }
//    }
    
    // 내부 상태를 초기화합니다.
    func resetData() {
        goalExpenses.accept([])
        hasNext = true
        startDate = nil
        endDate = nil
        lastDate = nil
        lastExpenseId = nil
    }
}
