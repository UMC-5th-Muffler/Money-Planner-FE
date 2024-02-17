//
//  GoalCreationManager.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation
import RxSwift
import RxCocoa

// GoalCreationManager

class GoalCreationManager {
    
    static let shared = GoalCreationManager()

    var icon: String?
    var goalTitle: String?
    var goalDetail: String? // Added detail property
    var goalBudget: Int64?
    var startDate: String?
    var endDate: String?
    var categoryGoals: [CategoryGoal] = [] // Assuming this matches your CategoryGoal structure
    var dailyBudgets: [Int64] = [] // Added dailyBudgets property
    
    private let disposeBag = DisposeBag()
    let postGoalResultRelay = PublishRelay<Bool>()

    private init() {} // Private initializer to ensure singleton usage

    func createGoalRequest() -> PostGoalRequest? {
        guard let icon = icon,
              let goalTitle = goalTitle,
              let goalDetail = goalDetail, // Ensure goalDetail is not nil
              let goalBudget = goalBudget,
              let startDate = startDate,
              let endDate = endDate
        else {
            return nil
        }
        
        return PostGoalRequest(icon: icon,
                               title: goalTitle,
                               detail: goalDetail,
                               startDate: startDate,
                               endDate: endDate,
                               totalBudget: goalBudget,
                               categoryGoals: categoryGoals,
                               dailyBudgets: dailyBudgets)
    }

    //목표를 post하려 한다. 성공 여부에 따라 postGoalResultRelay를 사용
    func postGoal() {
        guard let request = createGoalRequest() else {
            postGoalResultRelay.accept(false) // Could not create request
            return
        }
        
        GoalRepository.shared.postGoal(request: request)
            .subscribe(onSuccess: { [weak self] response in // 성공 response
                // Assuming response has an isSuccess property or similar to indicate success
                self?.postGoalResultRelay.accept(response.isSuccess)
            }, onFailure: { [weak self] _ in
                self?.postGoalResultRelay.accept(false) //실패 response
            })
            .disposed(by: disposeBag)
    }

    //카테고리별 목표 추가 (카테고리VC에서 scrap해오는건 이녀석의 몫)
    func addCategoryGoals(categoryGoals: [CategoryGoal]) {
        var isUnique = true
        let existingCategoryIds = self.categoryGoals.map { $0.categoryId }
        
        for categoryGoal in categoryGoals {
            if existingCategoryIds.contains(categoryGoal.categoryId) {
                isUnique = false
                break
            }
        }
        
        if isUnique {
            self.categoryGoals.append(contentsOf: categoryGoals)
            print("Category goals added successfully.")
        } else {
            print("One or more category goals have duplicate category IDs.")
        }
    }
    
    //일별 목표를 등록
    func addDailyBudgets(budgets: [Int64]) {
        
        guard let startDateString = startDate, let endDateString = endDate,
            let startDate = startDate?.toMPDate(), let endDate = endDate?.toMPDate() else {
            print("Invalid dates")
            return
        }
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        guard let days = dateComponents.day else {
            print("Could not calculate the number of days")
            return
        }
        
        // endDate를 포함하기 위해 +1
        if days + 1 == budgets.count {
            self.dailyBudgets = budgets
        } else {
            print("The number of budgets does not match the number of days")
        }
    }

    func clear() {
        icon = nil
        goalTitle = nil
        goalDetail = nil // Clear the detail
        goalBudget = nil
        startDate = nil
        endDate = nil
        categoryGoals = [] // Clear categoryGoals
        dailyBudgets = [] // Clear dailyBudgets
    }
}
