//
//  GoalAPI.swift
//  Money-Planner
//
//  Created by 유철민 on 1/26/24.
//

import Foundation
import RxMoya
import Moya
import RxSwift

enum GoalAPI {
    case postGoal(request: PostGoalRequest)
    case deleteGoal(goalId: Int)
    case getGoalDetail(goalId: Int)
    case now
    case notNow(endDate: String?)
    case goalReport(goalId: Int)
    case goalExpense(goalId: Int, startDate: String, endDate: String, size: Int, lastDate: String?, lastExpenseId: Int?)
    case getPreviousGoals
    case postContent(request: PostGoalRequest)
}

extension GoalAPI : BaseAPI {
    
    var headers: [String: String]? {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "accessToken") {
            print("토큰 불러오기 성공")
            return ["Authorization": "Bearer \(token)"]
        } else {
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .postGoal(let request):
            return "/api/goal"
        case .deleteGoal(let goalId):
            return "/api/goal/\(goalId)"
        case .getGoalDetail(let goalId):
            return "/api/goal/\(goalId)"
        case .now:
            return "/api/goal/now"
        case .notNow:
            return "/api/goal/not-now"
        case .goalReport(let goalId):
            return "/api/goal/report/\(goalId)"
        case .goalExpense(let goalId, _, _, _, _, _):
            return "/api/expense/weekly?goalId=\(goalId)"
        case .getPreviousGoals:
            return "/api/goal/previous"
        case .postContent :
            return "/api/goal"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .now:
            return .get
        case .postGoal:
            return .post
        case .deleteGoal:
            return .delete
        case .postContent:
            return .post
        default :
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .postGoal(let request):
            return .requestJSONEncodable(request)
        case .goalReport:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case .now:
            return .requestPlain
        case .notNow(let endDate):
            var parameters: [String: Any] = [:]
            if let endDate = endDate {
                parameters["endDate"] = endDate
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
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
            
        case .getGoalDetail:
            return .requestPlain
        case .deleteGoal:
            return .requestPlain
            
        case .postContent(let request):
            return .requestJSONEncodable(request)
            
        default:
            return .requestPlain
        }
    }
    
    var sampleData: Data { return Data() }
}


//let provider = MoyaProvider<GoalAPI>()
//let disposeBag = DisposeBag()

//func postGoal(request: PostGoalRequest) {
//    provider.rx.request(.postGoal(request: request))
//        .filterSuccessfulStatusCodes()
//        .subscribe { event in
//            switch event {
//            case .success(let response):
//                print("Goal successfully posted")
//                // 추가적인 성공 처리 로직
//            case .failure(let error):
//                print("Error posting goal: \(error.localizedDescription)")
//            }
//        }
//        .disposed(by: disposeBag)
//}
//
//
//func fetchNowGoal() {
//    provider.rx.request(.now)
//        .filterSuccessfulStatusCodes()
//        .map(NowResponse.self)
//        .subscribe(onSuccess: { response in
//            print("Now Goal Title: \(response.result.goalTitle)")
//        }, onFailure: { error in
//            print("Error: \(error)")
//        })
//        .disposed(by: disposeBag)
//}
//
//func fetchNotNowGoals() {
//    provider.rx.request(.notNow)
//        .filterSuccessfulStatusCodes()
//        .map(NotNowResponse.self)
//        .subscribe(onSuccess: { response in
//            print("Not Now Future Goals Count: \(response.result.futureGoal.count)")
//            print("Not Now Ended Goals Count: \(response.result.endedGoal.count)")
//            print("Has Next: \(response.result.hasNext)")
//        }, onFailure: { error in
//            print("Error: \(error)")
//        })
//        .disposed(by: disposeBag)
//}
//
//func fetchGoalDetail(goalId: Int) {
//    provider.rx.request(.getGoalDetail(goalId: goalId)) { result in
//        switch result {
//        case .success(let response):
//            do {
//                let goalDetailResponse = try JSONDecoder().decode(GoalDetailResponse.self, from: response.data)
//                // 여기서 goalDetailResponse.result를 사용하는 로직 구현
//            } catch {
//                print("Error decoding GoalDetail: \(error)")
//            }
//        case .failure(let error):
//            print("Error fetching goal detail: \(error.localizedDescription)")
//        }
//    }
//}
//
//func fetchGoalReport(for goalId: Int) {
//    provider.rx.request(.goalReport(goalId: goalId))
//        .filterSuccessfulStatusCodes()
//        .map(GoalReportResponse.self)
//        .subscribe { event in
//            switch event {
//            case .success(let response):
//                print("Zero Day Count: \(response.result.zeroDayCount)")
//                // 카테고리 별 총 비용 출력
//                response.result.categoryTotalCosts.forEach { cost in
//                    print("\(cost.categoryName): \(cost.totalCost)")
//                }
//                // 카테고리 목표 보고서 출력
//                response.result.categoryGoalReports.forEach { report in
//                    print("Category: \(report.categoryName), Budget: \(report.categoryBudget), Total Cost: \(report.totalCost)")
//                }
//            case .failure(let error):
//                print("Error fetching goal report: \(error.localizedDescription)")
//            }
//        }.disposed(by: disposeBag)
//}
