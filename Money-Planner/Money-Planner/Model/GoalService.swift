//
//  GoalService.swift
//  Money-Planner
//
//  Created by 유철민 on 2/15/24.
//

import Foundation
import RxMoya
import Moya
import RxSwift

enum GoalService {
    case now
    case notNow
    case goalReport(goalId: Int)
    case goalExpense(goalId: Int, startDate: String, endDate: String, size: Int, lastDate: String?, lastExpenseId: Int?)
}

extension GoalService: BaseAPI {
    
    var headers: [String: String]? {
        // Replace 'YourTokenHere' with the actual bearer token.
        return ["Authorization": "Bearer YourTokenHere"]
    }
    
    var path: String {
        switch self {
        case .now:
            return "/api/goal/now"
        case .notNow:
            return "/api/goal/not-now"
        case .goalReport(let goalId):
            return "/api/goal/report/\(goalId)"
        case .goalExpense(let goalId, _, _, _, _, _):
            return "/api/expense/weekly?goalId=\(goalId)"
        
        }
    }
    
    var method: Moya.Method { return .get }
    
    var task: Task {
        switch self {
        case .goalReport:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
            
        case .goalExpense(let goalId, let startDate, let endDate, let size, let lastDate, let lastExpenseId):
            var parameters: [String: Any] = [
                "goalId": goalId,
                "startDate": startDate,
                "endDate": endDate,
                "size": size
            ]
            if let lastDate = lastDate {
                parameters["lastDate"] = lastDate
            }
            if let lastExpenseId = lastExpenseId {
                parameters["lastExpenseId"] = lastExpenseId
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        default:
            return .requestPlain
        }
    }
    
    var sampleData: Data { return Data() }
}


let provider = MoyaProvider<GoalService>()
let disposeBag = DisposeBag()

func fetchNowGoal() {
    provider.rx.request(.now)
        .filterSuccessfulStatusCodes()
        .map(NowResponse.self)
        .subscribe(onSuccess: { response in
            print("Now Goal Title: \(response.result.goalTitle)")
        }, onFailure: { error in
            print("Error: \(error)")
        })
        .disposed(by: disposeBag)
}

func fetchNotNowGoals() {
    provider.rx.request(.notNow)
        .filterSuccessfulStatusCodes()
        .map(NotNowResponse.self)
        .subscribe(onSuccess: { response in
            print("Not Now Future Goals Count: \(response.result.futureGoal.count)")
            print("Not Now Ended Goals Count: \(response.result.endedGoal.count)")
            print("Has Next: \(response.result.hasNext)")
        }, onFailure: { error in
            print("Error: \(error)")
        })
        .disposed(by: disposeBag)
}

func fetchGoalReport(for goalId: Int) {
    provider.rx.request(.goalReport(goalId: goalId))
        .filterSuccessfulStatusCodes()
        .map(GoalReportResponse.self)
        .subscribe { event in
            switch event {
            case .success(let response):
                print("Zero Day Count: \(response.result.zeroDayCount)")
                // 카테고리 별 총 비용 출력
                response.result.categoryTotalCosts.forEach { cost in
                    print("\(cost.categoryName): \(cost.totalCost)")
                }
                // 카테고리 목표 보고서 출력
                response.result.categoryGoalReports.forEach { report in
                    print("Category: \(report.categoryName), Budget: \(report.categoryBudget), Total Cost: \(report.totalCost)")
                }
            case .failure(let error):
                print("Error fetching goal report: \(error.localizedDescription)")
            }
        }.disposed(by: disposeBag)
}
