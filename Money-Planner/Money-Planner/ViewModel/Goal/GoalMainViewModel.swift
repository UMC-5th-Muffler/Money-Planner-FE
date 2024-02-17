//
//  GoalMainViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 2/17/24.
//

import Foundation
import RxSwift
import RxMoya
import Moya
import RxRelay

class GoalMainViewModel {
    
    static let shared = GoalMainViewModel()

    private let goalRepository = GoalRepository.shared
    private let disposeBag = DisposeBag()
    
    // Observables for goals
    let nowGoals = BehaviorRelay<Goal_?>(value: nil)
//    let notNowResult = BehaviorRelay<NotNowResult?>(value: nil) // Holds both past and future goals
    let notNowGoals = BehaviorRelay<[Goal_]>(value : [])
//    let futureGoals = BehaviorRelay<[Goal_]>(value: [])
//    let pastGoals = BehaviorRelay<[Goal_]>(value: [])
    let addedNotNowGoals = BehaviorRelay<[Goal_]>(value : [])
    
    var hasNext = BehaviorRelay<Bool>(value: true)
    private var endDate: String?

    private init() {}

    func fetchNowGoal() {
        goalRepository.getNowGoal().subscribe { [weak self] event in
            switch event {
            case .success(let response):
                self?.nowGoals.accept(response.result) // Cannot convert value of type 'Goal_' to expected argument type '[Goal_]'
            case .failure(let error):
                print("Error fetching current goals: \(error.localizedDescription)")
            }
        }.disposed(by: disposeBag)
    }
    
    // Initial fetch without endDate
    func fetchInitialNotNowGoals() {
        fetchNotNowGoals()
    }
    
    // Fetch not-now goals, considering pagination
    func fetchNotNowGoals() {
        //hasNext가 true일때만 받을 수 있도록 처리
        guard hasNext.value else { return }
        GoalRepository.shared.getNotNowGoals(endDate: endDate).subscribe(onSuccess: { [weak self] response in
            guard let self = self else { return }
            if response.isSuccess {
                let newGoals = response.result.futureGoal + response.result.endedGoal
                self.addedNotNowGoals.accept(newGoals)
                var currentGoals = self.notNowGoals.value
                currentGoals.append(contentsOf: newGoals)
                self.notNowGoals.accept(currentGoals)
                
                // Update hasNext and endDate for pagination
                self.hasNext.accept(response.result.hasNext)
                self.endDate = currentGoals.last?.endDate
            }
        }, onFailure: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    // 초기화 용도
    func resetData() {
        nowGoals.accept(nil)
        notNowGoals.accept([])
        hasNext.accept(true)
        endDate = nil
    }
}
