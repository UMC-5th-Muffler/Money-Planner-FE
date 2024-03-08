//
//  GoalDetailViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 2/17/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class GoalDetailViewModel {
    
    static let shared = GoalDetailViewModel()
    let repository = GoalRepository.shared
    let disposeBag = DisposeBag()
    let goalRelay = PublishRelay<GoalDetail>()
    let goalReportRelay = PublishRelay<GoalReportResult>()
    let weeklyExpensesRelay = PublishRelay<WeeklyExpenseResult>()
    let dailyExpenseListRelay = PublishRelay<[DailyExpense]>()
    
    var hasNext = false
    private var lastDate: String?
    private var lastExpenseId: String?
    private var selectedStartDate: String?
    private var selectedEndDate: String?
    
    func fetchGoal(goalId: String) {
        repository.getGoalDetail(goalId: goalId)
            .subscribe { [weak self] event in
                switch event {
                case .success(let response):
                    self?.goalRelay.accept(response.result)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchGoalReport(goalId: String) {
        repository.getGoalReport(goalId: goalId)
            .subscribe { [weak self] event in
                switch event {
                case .success(let response):
                    self?.goalReportRelay.accept(response.result)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchNextPageIfPossible(goalId: String, completion: @escaping () -> Void) {
        guard hasNext else {
            completion()
            return
        }
        fetchBySelectedDates(goalId: goalId, startDate: self.selectedStartDate!, endDate: self.selectedEndDate!, forceRefresh: false, completion: completion)
    }
    
    func fetchBySelectedDates(goalId: String, startDate: String, endDate: String, forceRefresh: Bool = false, completion: @escaping () -> Void) {
        if forceRefresh {
            lastDate = nil
            lastExpenseId = nil
            // Emit an empty list to clear existing data
            dailyExpenseListRelay.accept([])
        }
        
        self.selectedStartDate = startDate
        self.selectedEndDate = endDate
        
        repository.getWeeklyExpenses(goalId: goalId, startDate: startDate, endDate: endDate, size: "10", lastDate: lastDate, lastExpenseId: lastExpenseId)
            .subscribe(onSuccess: { [weak self] expenseResponse in
                self?.updatePaginationInfo(from: expenseResponse.result)
                
                // Decide to either clear existing data and emit new or append to existing data
                if forceRefresh {
                    // Directly emit the new data
                    self?.dailyExpenseListRelay.accept(expenseResponse.result.dailyExpenseList)
                } else {
                    // Append new data to existing and emit
                    self?.dailyExpenseListRelay
                        .take(1) // Take the current state before appending
                        .subscribe(onNext: { currentList in
                            let updatedList = currentList + expenseResponse.result.dailyExpenseList
                            self?.dailyExpenseListRelay.accept(updatedList)
                        })
                        .disposed(by: self!.disposeBag)
                }
                completion()
            }, onFailure: { error in
                print("Error fetching expenses: \(error.localizedDescription)")
                completion()
            })
            .disposed(by: disposeBag)
    }
    
    func fetchExpensesUsingGoalDetail(goalId: String, forceRefresh: Bool = false) {
        if forceRefresh {
            lastDate = nil
            lastExpenseId = nil
            // Emit an empty list to clear existing data
            dailyExpenseListRelay.accept([])
        }
        
        repository.getGoalDetail(goalId: goalId)
            .flatMap { [weak self] goalDetailResponse -> Single<WeeklyExpenseResponse> in
                guard let self = self else { return .never() }
                let startDate = goalDetailResponse.result.startDate
                let endDate = goalDetailResponse.result.endDate
                self.selectedStartDate = startDate
                self.selectedEndDate = endDate
                return self.repository.getWeeklyExpenses(goalId: goalId, startDate: startDate, endDate: endDate, size: "10", lastDate: self.lastDate, lastExpenseId: self.lastExpenseId)
            }.subscribe(onSuccess: { [weak self] expenseResponse in
                self?.updatePaginationInfo(from: expenseResponse.result)
                
                // Check if it's a force refresh or a subsequent fetch
                if forceRefresh {
                    // For force refresh, directly emit the new list
                    self?.dailyExpenseListRelay.accept(expenseResponse.result.dailyExpenseList)
                } else {
                    // For subsequent fetches, append new data to the existing data
                    self?.dailyExpenseListRelay
                        .take(1) // Take the current value of the relay
                        .subscribe(onNext: { currentList in
                            let updatedList = currentList + expenseResponse.result.dailyExpenseList
                            self?.dailyExpenseListRelay.accept(updatedList)
                        })
                        .disposed(by: self!.disposeBag)
                }
            }, onFailure: { error in
                print("Error fetching expenses: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    private func updatePaginationInfo(from result: WeeklyExpenseResult) {
        if let lastExpenseDay = result.dailyExpenseList.last,
           let lastExpense = lastExpenseDay.expenseDetailList.last {
            self.lastDate = lastExpenseDay.date
            self.lastExpenseId = String(lastExpense.expenseId)
        }
        self.hasNext = result.hasNext
    }
    
    
}
