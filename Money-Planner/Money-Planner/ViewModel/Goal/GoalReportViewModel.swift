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
    private let provider = MoyaProvider<GoalService>()
    
    // 결과를 저장할 BehaviorRelay 객체 생성
    var goalReportRelay = BehaviorRelay<GoalReportResult?>(value: nil)
    
    private let disposeBag = DisposeBag()
    
    private init() {} // Singleton pattern
    
    func fetchGoalReport(for goalId: Int) {
        provider.rx.request(.goalReport(goalId: goalId))
            .filterSuccessfulStatusCodes()
            .map(GoalReportResponse.self)
            .subscribe { [weak self] event in
                switch event {
                case .success(let response):
                    // 받아온 데이터를 BehaviorRelay에 저장
                    self?.goalReportRelay.accept(response.result)
                case .failure(let error):
                    print("Error fetching goal report: \(error.localizedDescription)")
                    // 실패 시, nil을 저장하거나 기존 값을 유지할 수 있습니다.
                    // self?.goalReportRelay.accept(nil)
                }
            }.disposed(by: disposeBag)
    }
}

import UIKit

class YourViewController: UIViewController {
    
    private let viewModel = GoalReportViewModel.shared
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchGoalReport(for: 1) // 예시 goalId 값은 1입니다.
    }
    
    private func bindViewModel() {
        viewModel.goalReportRelay
            .subscribe(onNext: { [weak self] goalReportResult in
                guard let result = goalReportResult else {
                    print("No data received or an error occurred.")
                    return
                }
                // 데이터 사용, 예: UI 업데이트
                print("Zero Day Count: \(result.zeroDayCount)")
            }).disposed(by: disposeBag)
    }
}
