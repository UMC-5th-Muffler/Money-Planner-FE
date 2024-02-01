import Foundation
import Moya

enum MufflerAPI {
    // Member Controller
    case refreshToken
    case loginKakao
    case loginApple
    case connect

    // Goal Controller
    case createGoal
    case getPreviousGoals
    case deleteGoal(goalId: String)

    // Expense Controller
    case createExpense
    case getExpense(expenseId: String)
    case getWeeklyExpense
    case searchExpense
    case getMonthlyExpense
    case getDailyExpense

    // Category Controller
    case createCategory

    // Rate Controller
    case updateRate(date: String)
    case getRates

    // Home Controller
    case getNow
    case getGoal(goalId: String)
    case getGoalByYearMonth(goalId: String, yearMonth: String)
    case getGoalByCategory(goalId: String, categoryId: String)
    case getBasicHomeInfo
}

extension MufflerAPI : TargetType {
    var baseURL: URL {
        return URL(string: "http://13.209.182.17:8080")!
    }

    var path: String {
        switch self {
        // Member Controller
        case .refreshToken:
            return "/api/member/refresh-token"
        case .loginKakao:
            return "/api/member/login/kakao"
        case .loginApple:
            return "/api/member/login/apple"
        case .connect:
            return "/api/member/connect"

        // Goal Controller
        case .createGoal:
            return "/api/goal"
        case .getPreviousGoals:
            return "/api/goal/previous"
        case .deleteGoal(let goalId):
            return "/api/goal/\(goalId)"

        // Expense Controller
        case .createExpense:
            return "/api/expense"
        case .getExpense(let expenseId):
            return "/api/expense/\(expenseId)"
        case .getWeeklyExpense:
            return "/api/expense/weekly"
        case .searchExpense:
            return "/api/expense/search"
        case .getMonthlyExpense:
            return "/api/expense/monthly"
        case .getDailyExpense:
            return "/api/expense/daily"

        // Category Controller
        case .createCategory:
            return "/api/category"

        // Rate Controller
        case .updateRate(let date):
            return "/api/rate/\(date)"
        case .getRates:
            return "/api/rate"

        // Home Controller
        case .getNow:
            return "/api/home/now"
        case .getGoal(let goalId):
            return "/api/home/goal/\(goalId)"
        case .getGoalByYearMonth(let goalId, let yearMonth):
            return "/api/home/goal/\(goalId)/\(yearMonth)"
        case .getGoalByCategory(let goalId, let categoryId):
            return "/api/home/goal/\(goalId)/category/\(categoryId)"
        case .getBasicHomeInfo:
            return "/api/home/basic"
        }
    }

    var method: Moya.Method {
        // 각 API에 맞는 HTTP 메서드를 설정합니다.
        switch self {
        case .refreshToken, .loginKakao, .loginApple,
             .createGoal, .createExpense, .createCategory, .updateRate:
            return .post
        case .connect, .getPreviousGoals, .getExpense, .getWeeklyExpense, .searchExpense,
             .getMonthlyExpense, .getDailyExpense, .getRates, .getNow, .getGoal,
             .getGoalByYearMonth, .getGoalByCategory, .getBasicHomeInfo:
            return .get
        case .deleteGoal:
            return .delete

        }
    }

    // 각 API에 맞는 request 파라미터를 설정합니다.
    var task: Task {
        switch self {
        case .refreshToken, .loginKakao, .loginApple, .connect,
             .createGoal, .createExpense, .createCategory, .updateRate:
            return .requestPlain
        case .getPreviousGoals, .getExpense, .getWeeklyExpense, .searchExpense,
             .getMonthlyExpense, .getDailyExpense, .getRates, .getNow, .getGoal,
             .getGoalByYearMonth, .getGoalByCategory, .getBasicHomeInfo:
            return .requestPlain
        case .deleteGoal:
            return .requestPlain
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMzI0NjEzNzk1IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MDY4Njc2NzN9.SV_8eU2l19lQL87eGKHkAjy2Ls7sVRsDznWkZ4dJlOE"] // 엑세스 토큰 넣는 자리!
    }
}

