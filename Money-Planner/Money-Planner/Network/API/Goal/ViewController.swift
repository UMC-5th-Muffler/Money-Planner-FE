//
//  ViewController.swift
//  apitrial
//
//  Created by 유철민 on 2/19/24.
//


import Foundation
import Moya
import RxMoya
import RxSwift
import UIKit
import RxRelay


class GoalViewController: UIViewController {
    var mainViewModel = GoalMainViewModel()
    var periodviewModel = GoalPeriodViewModel()
    var detailViewModel = GoalDetailViewModel()
    private let disposeBag = DisposeBag()
    let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        mainViewModel.now.asObservable()
            .subscribe(onNext: { [weak self] goal in
                print("now")
                print(goal?.result as Any)
                self!.titleLabel.text = goal?.result.goalTitle
            })
            .disposed(by: disposeBag)
        
        mainViewModel.notNow.asObservable()
            .subscribe(onNext: { [weak self] goals in
                print("not-now")
                print(goals?.result.endedGoal?.first as Any)
            })
            .disposed(by: disposeBag)
        
        periodviewModel.previous.asObservable()
            .subscribe(onNext: { [weak self] previous in
                print("previous")
                print(previous?.result.terms as Any)
            })
            .disposed(by: disposeBag)
        
        mainViewModel.goalById.asObservable()
            .subscribe(onNext: { [weak self] goals in
                print("goalByID")
                print(goals?.result as Any)
            })
            .disposed(by: disposeBag)
        
        // Monitor expenses stream for more requests
        detailViewModel.hasNext
            .asObservable()
            .subscribe(onNext: { [weak self] hasNext in
                guard let strongSelf = self, hasNext, let lastExpenseId = self?.detailViewModel.lastExpenseId.value, let lastExpenseDate = self?.detailViewModel.lastExpenseDate.value else { return }
                strongSelf.detailViewModel.fetchWeeklyExpense(goalId: 5, startDate: "2024-01-07", endDate: "2024-01-19", size: 10, lastDate: lastExpenseDate, lastExpenseId: lastExpenseId)
                print("expense")
            })
            .disposed(by: disposeBag)

        
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        mainViewModel.fetchCurrentGoal()
        mainViewModel.fetchNotNowGoal() // 추가
        periodviewModel.fetchPreviousGoal()
        detailViewModel.fetchGoalById(goalId: 5)
        createGoal()
        
        // Upon initial load, or wherever your UI-Event-Data sequence triggers:
        detailViewModel.initialFetchWeeklyExpense(goalId: 5, startDate: "2024-01-07", endDate: "2024-01-19", size: 10)
        
    }
    
    func createGoal() {
        // Example data for the goal
        let icon = "goal_icon"
        let title = "My Goal_cm"
        let startDate = "2024-02-28"
        let endDate = "2024-02-28"
        let totalBudget: Int64? = 0
        let categoryGoals: [CategoryGoal] = [CategoryGoal(categoryId: 1, categoryBudget: 0)]
        let dailyBudgets: [Int64] = [0] // 9 elements with a sum of 1000
        
        // Call the service provider to create the goal
        mainViewModel.createGoal(icon: icon, title: title, startDate: startDate, endDate: endDate, totalBudget: totalBudget, categoryGoals: categoryGoals, dailyBudgets: dailyBudgets)
    }

}
