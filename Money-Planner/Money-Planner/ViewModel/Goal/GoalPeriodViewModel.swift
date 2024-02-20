//
//  GoalPeriodViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 2/17/24.
//

import Foundation
import RxSwift
import RxCocoa

class GoalPeriodViewModel {
    
    static let shared = GoalPeriodViewModel()
    private let goalRepository = GoalRepository.shared
    private let disposeBag = DisposeBag()
    
    // RxSwift Relay to hold and emit changes in the periods of previous goals
    let previousGoalTerms = BehaviorRelay<[Term]>(value: [])
    
    // Initializer
    init() {
        fetchPreviousGoals()
    }
    
    private func fetchPreviousGoals() {
        goalRepository.getPreviousGoals()
            .subscribe(onSuccess: { [weak self] response in
                if response.isSuccess {
                    // Update the Relay with the new terms
                    self?.previousGoalTerms.accept(response.result.terms)
                } else {
                    // Handle the error or failed case, e.g., show an error message.
                    print("Failed to fetch previous goals: \(response.message)")
                }
            }, onFailure: { error in
                // Handle any errors that occurred during the network request.
                print("Error fetching previous goals: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
}
