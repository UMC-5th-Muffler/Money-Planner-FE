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
    private let goalRepository = GoalRepository.shared
    private let disposeBag = DisposeBag()
    
    // Relay for GoalDetail
    let goalDetail = PublishRelay<GoalDetail>()
    
    // Relays for GoalReport and GoalExpense
    let goalReportRelay = PublishRelay<GoalReportResult>()
    let weeklyExpensesRelay = PublishRelay<WeeklyExpenseResult>()
    
    var hasNext = false
    private var lastDate: String?
    private var lastExpenseId: String?
    
    private init() {}
    
    func fetchGoalDetail(goalId: Int) {
        goalRepository.getGoalDetail(goalId: String(goalId))
            .subscribe { [weak self] event in
                switch event {
                case .success(let response):
                    self?.goalDetail.accept(response.result)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchGoalReport(goalId: Int) {
        goalRepository.getGoalReport(goalId: String(goalId))
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
    
    func fetchExpensesUsingGoalDetail(goalId: Int, forceRefresh: Bool = false) {
        
        if forceRefresh {
            lastDate = nil
            lastExpenseId = nil
        }
        
        goalRepository.getGoalDetail(goalId: String(goalId))
            .flatMap { [weak self] goalDetailResponse -> Single<WeeklyExpenseResponse> in
                guard let self = self else { return .never() }
                let startDate = goalDetailResponse.result.startDate
                let endDate = goalDetailResponse.result.endDate
                return self.goalRepository.getWeeklyExpenses(goalId: String(goalId), startDate: startDate, endDate: endDate, size: "10", lastDate: self.lastDate, lastExpenseId: self.lastExpenseId)
            }.subscribe(onSuccess: { [weak self] expenseResponse in
                // 마지막 날짜와 ID 업데이트
                if let lastExpense = expenseResponse.result.dailyExpenseList.last?.expenseDetailList.last {
                    self?.lastDate = expenseResponse.result.dailyExpenseList.last?.date
                    self?.lastExpenseId = String(lastExpense.expenseId)
                }
                
                // hasNext 업데이트
                self?.hasNext = expenseResponse.result.hasNext
                
                // 데이터 방출
                self?.weeklyExpensesRelay.accept(expenseResponse.result)
            }, onError: { error in
                print("Error fetching expenses: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    func fetchNextPageIfPossible(goalId: Int) {
        guard hasNext else { return }
        fetchExpensesUsingGoalDetail(goalId: goalId)
    }
}

class GoalAPIViewController: UIViewController {
    
    var viewModel = GoalDetailViewModel.shared
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ViewModel의 fetchGoal 메서드를 호출하여 데이터 요청
        viewModel.fetchGoalDetail(goalId: 14)
        viewModel.fetchGoalReport(goalId: 14)
        viewModel.fetchExpensesUsingGoalDetail(goalId: 14, forceRefresh: true)
        
        // 데이터 수신을 위한 구독 설정
        viewModel.goalDetail
            .subscribe(onNext: { [weak self] goal in
                // 여기서 goal 데이터를 사용하여 UI 업데이트
                print(goal)
            })
            .disposed(by: disposeBag)
        
        viewModel.goalReportRelay
            .subscribe(onNext: { [weak self] report in
                // report 데이터를 사용하여 UI 업데이트
                print(report)
            })
            .disposed(by: disposeBag)
        
        
        // 소비 내역 구독 설정
        viewModel.weeklyExpensesRelay
            .subscribe(onNext: { [weak self] weeklyExpenses in
                // 여기서 weeklyExpenses 데이터를 사용하여 UI 업데이트, 예를 들어 콘솔에 출력
                print("Weekly Expenses: \(weeklyExpenses)")
                // 추가적으로, 여기에서 테이블 뷰를 업데이트할 수도 있습니다.
                // self?.tableView.reloadData() // 예시: 테이블 뷰가 있다고 가정
            })
            .disposed(by: disposeBag)
    }

}
