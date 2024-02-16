//
//  GoalSpendingViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class GoalSpendingViewModel {
    static let shared = GoalSpendingViewModel()
    private let provider = MoyaProvider<GoalService>()
    
    var goalExpenseRelay = BehaviorRelay<GoalExpenseResult?>(value: nil)
    private let disposeBag = DisposeBag()
    
    func fetchWeeklyExpenses(for goalId: Int, startDate: String, endDate: String, size: Int, lastDate: String? = nil, lastExpenseId: Int? = nil) {
        provider.rx.request(.goalExpense(goalId: goalId, startDate: startDate, endDate: endDate, size: size, lastDate: lastDate, lastExpenseId: lastExpenseId))
            .filterSuccessfulStatusCodes()
            .map(GoalExpenseResponse.self)
            .subscribe { [weak self] event in
                switch event {
                case .success(let response):
                    if response.isSuccess {
                        self?.goalExpenseRelay.accept(response.result)
                    } else {
                        print("API call succeeded but returned with message: \(response.message)")
                    }
                case .failure(let error):
                    print("Error fetching weekly expenses: \(error.localizedDescription)")
                }
            }.disposed(by: disposeBag)
    }
    
    // Call this function to load next page of expenses
    func loadNextPage() {
        guard let currentData = goalExpenseRelay.value, currentData.hasNext else { return }
        let lastExpense = currentData.dailyExpenseList.last?.expenseDetailList.last
        fetchWeeklyExpenses(for: 4, startDate: "2024-01-07", endDate: "2024-01-19", size: 10, lastDate: currentData.dailyExpenseList.last?.date, lastExpenseId: lastExpense?.expenseId)
    }
}
