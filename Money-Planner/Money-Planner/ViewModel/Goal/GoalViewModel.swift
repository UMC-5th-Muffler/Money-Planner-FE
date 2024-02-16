//
//  GoalViewModel.swift
//  Money-Planner
//
//  Created by 유철민 on 1/12/24.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class GoalViewModel {
    
    private let disposeBag = DisposeBag()
    private let provider = MoyaProvider<GoalService>()

    // RxSwift를 사용하여 관찰 가능한 프로퍼티 선언
    let nowGoal = BehaviorRelay<Goal_?>(value: nil)
    let notNowGoals = BehaviorRelay<NotNowResult?>(value: nil)
    let selectedGoalDetail = BehaviorRelay<GoalDetail?>(value: nil)

    // 현재 진행 중인 목표를 가져오는 메서드
    func fetchNowGoal() {
        provider.rx.request(.now)
            .filterSuccessfulStatusCodes()
            .map(NowResponse.self)
            .subscribe(onSuccess: { [weak self] response in
                self?.nowGoal.accept(response.result)
            }, onFailure: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    // 과거 및 미래의 목표들을 가져오는 메서드
    func fetchNotNowGoals() {
        provider.rx.request(.notNow)
            .filterSuccessfulStatusCodes()
            .map(NotNowResponse.self)
            .subscribe(onSuccess: { [weak self] response in
                self?.notNowGoals.accept(response.result)
            }, onFailure: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

    // 선택된 목표의 상세 정보를 가져오는 메서드
    func fetchGoalDetail(goalId: Int) {
        provider.rx.request(.getGoalDetail(goalId: goalId))
            .filterSuccessfulStatusCodes()
            .map(GoalDetailResponse.self)
            .subscribe(onSuccess: { [weak self] response in
                self?.selectedGoalDetail.accept(response.result)
            }, onFailure: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }

}
