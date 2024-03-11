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
    case updateExpense(expenseRequest: UpdateExpenseRequest)
    case getExpense(expenseId: Int64)
    case deleteExpense(expenseId: Int64)
    case fetchAvailableExpenseDates(yearMonth : String)
    case getWeeklyExpense
    case searchExpense
    case getMonthlyExpense
    case getDailyExpense

    // Category Controller
    case getCategoryFilter
    case getCategory
    case createCategory(request : CreateCategoryRequest)
    case updateCategory(request : UpdateCategoryRequest)
    case deleteCategory(categoryId : Int64)

    // Daily Plan Controller
    case updateZeroDay
    
    // Routine Controller
    case getRoutine(routineId : Int64)
    case deleteRoutine(routineId : Int64)
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
        return URL(string: "https://muffler.world")!
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
        case .updateExpense:
            return "/api/expense"
        case .getExpense(let expenseId):
            return "/api/expense/\(expenseId)"
        case .deleteExpense(let expenseId):
            return "/api/expense/\(expenseId)"
        case .fetchAvailableExpenseDates(let yearMonth):
            return "/api/expense/overview/\(yearMonth)"
        case .getWeeklyExpense:
            return "/api/expense/weekly"
        case .searchExpense:
            return "/api/expense/search"
        case .getMonthlyExpense:
            return "/api/expense/monthly"
        case .getDailyExpense:
            return "/api/expense/daily"

        // Category Controller
        case .getCategory:
            return "api/category"
        case .getCategoryFilter:
            return "api/category/filter"
        case .createCategory:
            return "api/category"
        case .updateCategory:
            return "api/category"
        case .deleteCategory(let categoryId):
            return "api/category/\(categoryId)"
        // Daily Plan Controller
        case .updateZeroDay:
            return "/dailyPlan/zeroDay"
            
        // Routine Controller
        case .getRoutine(let routineId):
            return "api/routine/\(routineId)"
        case .deleteRoutine(let routineId):
            return "api/routine/\(routineId)"
            
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
                .createGoal, .createExpense, .updateRate, .updateZeroDay, .createCategory:
            return .post
        case .connect, .getPreviousGoals, .getExpense, .getWeeklyExpense, .searchExpense, .fetchAvailableExpenseDates,
             .getMonthlyExpense, .getDailyExpense, .getRates, .getNow, .getGoal,
             .getGoalByYearMonth, .getGoalByCategory, .getBasicHomeInfo, .getCategoryFilter,.getCategory, .getRoutine:
            return .get
        case .deleteGoal, .deleteExpense, .deleteCategory, .deleteRoutine:
            return .delete
        case .updateExpense,.updateCategory:
            return .patch
        }
    }

    // Define request parameters for each API endpoint
    var task: Task {
        switch self {
        case .refreshToken, .loginKakao, .loginApple, .connect,
                .createGoal, .getCategoryFilter,.getCategory,.updateRate, .updateZeroDay:
            return .requestPlain
        case .getPreviousGoals, .getExpense,.fetchAvailableExpenseDates, .getWeeklyExpense, .searchExpense,
             .getMonthlyExpense, .getDailyExpense, .getRates, .getNow, .getGoal,
             .getGoalByYearMonth, .getGoalByCategory, .getBasicHomeInfo, .getRoutine:
            return .requestPlain
        case .deleteGoal, .deleteExpense, .deleteCategory, .deleteRoutine:
            return .requestPlain
        case .createCategory(let request):
            return .requestJSONEncodable(request)
        case .createExpense(let expenseRequest):
                return .requestJSONEncodable(expenseRequest)
        case .updateExpense(let expenseRequest):
            return .requestJSONEncodable(expenseRequest)
        case .updateCategory(let request):
            return .requestJSONEncodable(request)

        }
        
    }

    // Define sample data for each API endpoint
    var sampleData: Data {
        return Data()
    }

    // Define headers for the request
    var headers: [String: String]? {
        let defaults = UserDefaults.standard
        if let token = defaults.string(forKey: "accessToken") {
            print("토큰 불러오기 성공")
            return ["Authorization": "Bearer \(token)"]
        } else {
            return nil
        }
    }
}


