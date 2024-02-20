//
//  GoalMainViewController.swift
//  apitrial
//
//  Created by 유철민 on 2/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class GoalMainViewModel {
    let now: BehaviorRelay<NowGoalResponse?> = BehaviorRelay(value: nil)
    let notNow: BehaviorRelay<NotNowGoalResponse?> = BehaviorRelay(value: nil)
    let goalById: BehaviorRelay<GoalByIdResponse?> = BehaviorRelay(value: nil)
    private let disposeBag = DisposeBag()
    
    private let serviceProvider = GoalServiceProvider()
    
    func fetchCurrentGoal() {
        serviceProvider.getCurrentGoal()
            .subscribe(onSuccess: { [weak self] goal in
                self?.now.accept(goal)
            }, onFailure: { error in
                // Handle error
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchNotNowGoal() {
        serviceProvider.getNotNowGoal()
            .subscribe(onSuccess: { [weak self] goal in
                self?.notNow.accept(goal)
            }, onFailure: { error in
                // Handle error
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchGoalById(goalId: Int64) {
        serviceProvider.getGoal(goalId: goalId)
            .subscribe(onSuccess: { [weak self] goalByIdResponse in
                self?.goalById.accept(goalByIdResponse)
            }, onFailure: { error in
                // Handle error
                print("Error fetching goal by ID: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func createGoal(icon: String, title: String, startDate: String, endDate: String, totalBudget: Int64?, categoryGoals: [CategoryGoal], dailyBudgets: [Int64]) {
        serviceProvider.createGoal(icon: icon, title: title, startDate: startDate, endDate: endDate, totalBudget: totalBudget, categoryGoals: categoryGoals, dailyBudgets: dailyBudgets)
            .subscribe(onSuccess: { response in
                // Handle success
                print("Goal created successfully")
                print("Response: \(response)")
            }, onFailure: { error in
                // Handle error
                print("Error creating goal: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
