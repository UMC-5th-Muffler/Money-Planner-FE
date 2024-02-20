//
//  GoalPeriodViewModel.swift
//  apitrial
//
//  Created by 유철민 on 2/21/24.
//

import Foundation
import RxSwift
import RxCocoa

class GoalPeriodViewModel {
    let previous: BehaviorRelay<PreviousGoalResponse?> = BehaviorRelay(value: nil)
    private let disposeBag = DisposeBag()
    
    private let serviceProvider = GoalServiceProvider()
    
    func fetchPreviousGoal() {
        serviceProvider.getPreviousGoal()
            .subscribe(onSuccess: { [weak self] goal in
                self?.previous.accept(goal)
            }, onFailure: { error in
                // Handle error
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
