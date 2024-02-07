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
    case createExpense(expenseRequest: ExpenseCreateRequest)
    case updateExpense(expenseId: String, expenseRequest: ExpenseCreateRequest)
    case getExpense(expenseId: String)
    case deleteExpense(expenseId: String)
    case getWeeklyExpense
    case searchExpense
    case getMonthlyExpense
    case getDailyExpense

    // Category Controller
    case createCategory

    // Daily Plan Controller
    case updateZeroDay

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

extension MufflerAPI: TargetType {
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
        case .updateExpense(let expenseId, _):
            return "/api/expense/\(expenseId)"
        case .getExpense(let expenseId):
            return "/api/expense/\(expenseId)"
        case .deleteExpense(let expenseId):
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

        // Daily Plan Controller
        case .updateZeroDay:
            return "/dailyPlan/zeroDay"

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
        switch self {
        // Define HTTP methods for each API endpoint
        case .refreshToken, .loginKakao, .loginApple,
             .createGoal, .createExpense, .createCategory, .updateRate, .updateZeroDay:
            return .post
        case .connect, .getPreviousGoals, .getExpense, .getWeeklyExpense, .searchExpense,
             .getMonthlyExpense, .getDailyExpense, .getRates, .getNow, .getGoal,
             .getGoalByYearMonth, .getGoalByCategory, .getBasicHomeInfo:
            return .get
        case .deleteGoal, .deleteExpense:
            return .delete
        case .updateExpense:
            return .patch
        }
    }

    // Define request parameters for each API endpoint
    var task: Task {
        switch self {
        case .refreshToken, .loginKakao, .loginApple, .connect,
             .createGoal, .createCategory, .updateRate, .updateZeroDay:
            return .requestPlain
        case .getPreviousGoals, .getExpense, .getWeeklyExpense, .searchExpense,
             .getMonthlyExpense, .getDailyExpense, .getRates, .getNow, .getGoal,
             .getGoalByYearMonth, .getGoalByCategory, .getBasicHomeInfo:
            return .requestPlain
        case .deleteGoal, .deleteExpense:
            return .requestPlain
        case .updateExpense(_, let expenseRequest):
            return .requestJSONEncodable(expenseRequest as! Encodable)
        case .createExpense(let expenseRequest):
                return .requestJSONEncodable(expenseRequest)
        }
        
    }

    // Define sample data for each API endpoint
    var sampleData: Data {
        return Data()
    }

    // Define headers for the request
    var headers: [String: String]? {
        return ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzMjkwMTA2OTM0IiwiYXV0aCI6IlVTRVIiLCJleHAiOjE3MDc0MDA3NjN9.wsu2awnVWZoZkj5V_Wddd0NvoobzdoqhOMSliswq_jI"] // Replace with your actual access token
    }
}
