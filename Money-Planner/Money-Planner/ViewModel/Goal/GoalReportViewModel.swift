//
//  GoalDetails.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxMoya
import Moya

class GoalReportViewModel {
    
    static let shared = GoalReportViewModel()
    private let goalRepository = GoalRepository.shared
    private let disposeBag = DisposeBag()
    
    var goalReportRelay = BehaviorRelay<GoalReportResult?>(value: nil)
    
    private init() {}
    
    func fetchGoalReport(for goalId: Int) {
        goalRepository.getGoalReport(goalId: goalId)
            .subscribe(onSuccess: { [weak self] response in
                if response.isSuccess {
                    self?.goalReportRelay.accept(response.result)
                } else {
                    print("API call succeeded but returned with message: \(response.message)")
                }
            }, onFailure: { error in
                print("Error fetching goal report: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
}
