//
//  GoalMainViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 2/17/24.
//

import Foundation
import RxSwift
import RxMoya
import RxCocoa
import Moya


class GoalMainViewModel {
    
    static let shared = GoalMainViewModel()

    private let goalRepository = GoalRepository.shared
    private let disposeBag = DisposeBag()
    
    // Observables for goals
    let nowGoalResponse : BehaviorRelay<NowResponse?> = BehaviorRelay(value: nil)
    let nowGoal : BehaviorRelay<Goal_?> = BehaviorRelay(value: nil)
//    let notNowResult = BehaviorRelay<NotNowResult?>(value: nil) // Holds both past and future goals
    let notNowGoals = BehaviorRelay<[Goal_]>(value : [])
    let futureGoals = BehaviorRelay<[Goal_]>(value: [])
    let pastGoals = BehaviorRelay<[Goal_]>(value: [])
    let addedNotNowGoals = BehaviorRelay<[Goal_]>(value : [])
    
    var hasNext = BehaviorRelay<Bool>(value: true)
    private var endDate: String?

    private init() {}

    // Initial fetch without endDate
    func fetchInitialGoals() {
//        resetData()
        fetchNowGoal()
        fetchNotNowGoals()
    }
    
    func fetchNowGoal() {
        goalRepository.getNowGoal()
            .subscribe(onSuccess: { [weak self] nowResponse in
                self?.nowGoalResponse.accept(nowResponse)
            }, onFailure: { error in
                // Handle error
                print(error)
            })
            .disposed(by: disposeBag)
        print(self.nowGoal.value?.goalTitle ?? "1")
    }
    

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
                print(newGoals)
                self.notNowGoals.accept(currentGoals)
                print(currentGoals)
                // Update hasNext and endDate for pagination
                self.hasNext.accept(response.result.hasNext)
                self.endDate = currentGoals.last?.endDate
            }
        }, onFailure: { error in
            print(error)
        }).disposed(by: disposeBag)
    }
    
    // 초기화 용도
//    func resetData() {
//        nowGoals.accept(nil)
//        notNowGoals.accept([])
//        hasNext.accept(true)
//        endDate = nil
//    }
}
