//
//  GoalDetailViewModel.swift
//  apitrial
//
//  Created by 유철민 on 2/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class GoalDetailViewModel {
    // Existing property for goal by ID
    let goalById: BehaviorRelay<GoalByIdResponse?> = BehaviorRelay(value: nil)
    // Add new property for goal report
    let goalReport: BehaviorRelay<GoalReportResponse?> = BehaviorRelay(value: nil)
    let weeklyExpense: BehaviorRelay<WeeklyExpenseResponse?> = BehaviorRelay(value: nil)
    
    
    let hasNext: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let lastExpenseId: BehaviorRelay<Int64?> = BehaviorRelay(value: nil)
    let lastExpenseDate: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    
    
    private let disposeBag = DisposeBag()
    private let serviceProvider = GoalServiceProvider()
    
    // Existing function to fetch goal by ID
    func fetchGoalById(goalId: Int64) {
        serviceProvider.getGoal(goalId: goalId)
            .subscribe(onSuccess: { [weak self] goal in
                self?.goalById.accept(goal)
            }, onFailure: { error in
                // Handle error
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    // New function to fetch goal report
    func fetchGoalReport(goalId: Int64) {
        serviceProvider.getGoalReport(goalId: goalId)
            .subscribe(onSuccess: { [weak self] report in
                self?.goalReport.accept(report)
            }, onFailure: { error in
                // Handle error
                print("Error fetching goal report: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func initialFetchWeeklyExpense(goalId: Int64, startDate: String, endDate: String, size: Int64) {
        fetchWeeklyExpense(goalId: goalId, startDate: startDate, endDate: endDate, size: size, lastDate: nil, lastExpenseId: nil)
    }
    
    
    func fetchWeeklyExpense(goalId: Int64, startDate: String, endDate: String, size: Int64, lastDate: String?, lastExpenseId: Int64?) {
        serviceProvider.getWeeklyExpense(goalId: goalId, startDate: startDate, endDate: endDate, size: size, lastDate: lastDate, lastExpenseId: lastExpenseId)
            .subscribe(onSuccess: { [weak self] weeklyExpenseResponse in
                self?.weeklyExpense.accept(weeklyExpenseResponse)
                // Now, we handle the updates for hasNext, lastExpenseID, and the date of the last transaction
                // Assuming your API's "hasNext" is always accurate and you're interested in the last element's date and ID
                if let expenses = weeklyExpenseResponse.result.dailyExpenseList.last?.expenseDetailList, !expenses.isEmpty {
                    self?.hasNext.accept(weeklyExpenseResponse.result.hasNext)
                    
                    // Depending on your needs, this updates last known information
                    // Could adjust to look at all individual records if the order isn't by ID or data
                    if let lastExpense = expenses.last {
                        self?.lastExpenseId.accept(Int64(lastExpense.expenseId))
                        // If you want to maintain the record of the expense's own date
                        self?.lastExpenseDate.accept(weeklyExpenseResponse.result.dailyExpenseList.last?.date)
                    }
                }
            }, onFailure: { error in
                print("Error fetching weekly expenses: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

//
//// Upon initial load, or wherever your UI-Event-Data sequence triggers:
//detailViewModel.initialFetchWeeklyExpense(goalId: 5, startDate: "2024-01-07", endDate: "2024-01-19", size: 10)
//
//// Monitor expenses stream for more requests
//detailViewModel.hasNext
//    .asObservable()
//    .subscribe(onNext: { [weak self] hasNext in
//        guard let strongSelf = self, hasNext, let lastExpenseId = self?.detailViewModel.lastExpenseId.value, let lastExpenseDate = self?.detailViewModel.lastExpenseDate.value else { return }
//        strongSelf.detailViewModel.fetchWeeklyExpense(goalId: 5, startDate: "2024-01-07", endDate: "2024-01-19", size: 10, lastDate: lastExpenseDate, lastExpenseId: lastExpenseId)
//    })
//    .disposed(by: disposeBag)
