//
//  GoalDetailViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 2/17/24.
//

import Foundation
import RxSwift
import RxCocoa

class GoalDetailViewModel {
    
    static let shared = GoalDetailViewModel()
    private let goalRepository = GoalRepository.shared
    private let disposeBag = DisposeBag()

    // Relay for GoalDetail
    let goalDetail = BehaviorRelay<GoalDetail?>(value: nil)

    // Relays for GoalReport and GoalExpense
    let goalReport = BehaviorRelay<GoalReportResult?>(value: nil)
    let goalExpenses = BehaviorRelay<[DailyExpense]?>(value: nil)

    private init() {}

    func fetchGoalDetail(goalId: Int) {
        goalRepository.getGoalDetail(goalId: goalId).subscribe { [weak self] event in
            switch event {
            case .success(let response):
                self?.goalDetail.accept(response.result)
            case .failure(let error):
                print("Error fetching goal detail: \(error.localizedDescription)")
            }
        }.disposed(by: disposeBag)
    }

    func fetchGoalReport(goalId: Int) {
        goalRepository.getGoalReport(goalId: goalId).subscribe { [weak self] event in
            switch event {
            case .success(let response):
                self?.goalReport.accept(response.result)
            case .failure(let error):
                print("Error fetching goal report: \(error.localizedDescription)")
            }
        }.disposed(by: disposeBag)
    }

    func fetchGoalExpenses(goalId: Int, startDate: String, endDate: String, size: Int, lastDate: String? = nil, lastExpenseId: Int? = nil) {
        goalRepository.getGoalExpenses(goalId: goalId, startDate: startDate, endDate: endDate, size: size, lastDate: lastDate, lastExpenseId: lastExpenseId).subscribe { [weak self] event in
            switch event {
            case .success(let response):
                self?.goalExpenses.accept(response.result.dailyExpenseList)
            case .failure(let error):
                print("Error fetching goal expenses: \(error.localizedDescription)")
            }
        }.disposed(by: disposeBag)
    }
}
