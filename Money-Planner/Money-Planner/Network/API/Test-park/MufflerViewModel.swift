//
//  GitHubViewModel.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/1/24.
//

import Foundation
import RxSwift
import RxMoya
import Moya

class MufflerViewModel {
    private let provider = MoyaProvider<MufflerAPI>().rx
    let disposeBag = DisposeBag()
    
    // 소비등록 > 달력 모달뷰
    // 초기값이 필요한 BehaviorSubject 선언
    private let expenseOverviewSubject = BehaviorSubject<OverViewExpenseResponse?>(value: nil)
    // 외부에서 구독 가능하도록 Observable로 노출
    var expenseOverviewObservable: Observable<OverViewExpenseResponse?> {
        return expenseOverviewSubject.asObservable()
    }
    
    // Member Controller
//    func refreshToken() -> Observable<MyRepo> {
//        return provider.request(.refreshToken)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//    func loginKakao() -> Observable<MyRepo> {
//        return provider.request(.loginKakao)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func loginApple() -> Observable<MyRepo> {
//        return provider.request(.loginApple)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
    func connect() -> Observable<ConnectModel> {
        return provider.request(.connect)
            .map(ConnectModel.self)
            .asObservable()
    }
//
//    // Goal Controller
//    func createGoal() -> Observable<MyRepo> {
//        return provider.request(.createGoal)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getPreviousGoals() -> Observable<MyRepo> {
//        return provider.request(.getPreviousGoals)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func deleteGoal(goalId: String) -> Observable<MyRepo> {
//        return provider.request(.deleteGoal(goalId: goalId))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
    // Expense Controller
    
    // 소비내역 등록 : [POST] /api/expense
    func createExpense(expenseRequest: ExpenseCreateRequest) -> Single<ExpenseCreateResponse> {
        return provider.request(.createExpense(expenseRequest: expenseRequest))
                .map(ExpenseCreateResponse.self)
    }
    // 소비내역 수정 : [PATCH] /api/expense
    func updateExpense(expenseRequest: UpdateExpenseRequest) -> Single<ExpenseCreateResponse> {
        return provider.request(.updateExpense(expenseRequest: expenseRequest))
            .map(ExpenseCreateResponse.self)
    }
  
    // 소비내역 삭제 : [DELETE] /api/expense/{expenseId}
    func deleteExpense(expenseId: Int64) -> Observable<ConnectModel> {
        return provider.request(.deleteExpense(expenseId: expenseId))
            .map(ConnectModel.self).asObservable()
    }
    
    // 소비가능날짜 조회 : [GET] /api/expense/overview/{yearMonth}
    func fetchAvailableExpenseDates(yearMonth : String){
        provider.request(.fetchAvailableExpenseDates(yearMonth: yearMonth))
                .map(OverViewExpenseResponse.self)
                .subscribe(onSuccess: { [weak self] response in
                    // BehaviorSubject 업데이트
                    self?.expenseOverviewSubject.onNext(response)
                }, onError: { [weak self] error in
                    print("Error: \(error)")
                    // 에러 핸들링 필요시 여기서 처리
                    self?.expenseOverviewSubject.onNext(nil)
                }).disposed(by: disposeBag)
    }
    
    // Expense View Controller
    // 일일소비내역 조회 : [GET] /api/expense/{expenseId}
    func getExpense(expenseId: Int64) -> Observable<ResponseExpenseDto> {
        return provider.request(.getExpense(expenseId: expenseId))
            .map(ResponseExpenseDto.self)
            .asObservable()
    }
//
//    func getWeeklyExpense() -> Observable<MyRepo> {
//        return provider.request(.getWeeklyExpense)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func searchExpense() -> Observable<MyRepo> {
//        return provider.request(.searchExpense)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getMonthlyExpense() -> Observable<MyRepo> {
//        return provider.request(.getMonthlyExpense)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getDailyExpense() -> Observable<MyRepo> {
//        return provider.request(.getDailyExpense)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
    // Category Controller
    // 소비등록 > 카테고리 선택 뷰에서 활용
    func getCategory() -> Observable<GetCategoryResponse> {
        return provider.request(.getCategory)
            .map(GetCategoryResponse.self)
            .asObservable()
    }
    // 모든 카테고리 조회
    func getCategoryFilter() -> Observable<ResponseGetCategoryListResponse> {
        return provider.request(.getCategory)
            .map(ResponseGetCategoryListResponse.self)
            .asObservable()
    }
    // 카테고리 추가
    func createCategory(request : CreateCategoryRequest) -> Observable<CreateCategoryResponse> {
        return provider.request(.createCategory(request: request))
            .map(CreateCategoryResponse.self)
            .asObservable()
    }
    
    // 카테고리 수정
    func updateCategory(request : UpdateCategoryRequest ) -> Observable<ConnectModel> {
        return provider.request(.updateCategory(request: request))
            .map(ConnectModel.self)
            .asObservable()
    }
    // 카테고리 삭제
    func deleteCategory(categoryId : Int64) -> Observable<DeleteCategoryResponse> {
        return provider.request(.deleteCategory(categoryId: categoryId))
            .map(DeleteCategoryResponse.self)
            .asObservable()
    }
//
//    // Rate Controller
//    func updateRate(date: String) -> Observable<MyRepo> {
//        return provider.request(.updateRate(date: date))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getRates() -> Observable<MyRepo> {
//        return provider.request(.getRates)
//            .map(MyRepo.self)
//            .asObservable()
//    }
    // daily plan controller
//    // 제로데이 확인
//    func checkZeroDay(expenseRequest: ZeroDayRequest) -> Single<ConnectModel> {
//        return provider.request((expenseRequest: expenseRequest))
//            .map(ConnectModel.self)
//    }
//    // Home Controller
//    func getNow() -> Observable<MyRepo> {
//        return provider.request(.getNow)
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getGoal(goalId: String) -> Observable<MyRepo> {
//        return provider.request(.getGoal(goalId: goalId))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getGoalByYearMonth(goalId: String, yearMonth: String) -> Observable<MyRepo> {
//        return provider.request(.getGoalByYearMonth(goalId: goalId, yearMonth: yearMonth))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getGoalByCategory(goalId: String, categoryId: String) -> Observable<MyRepo> {
//        return provider.request(.getGoalByCategory(goalId: goalId, categoryId: categoryId))
//            .map(MyRepo.self)
//            .asObservable()
//    }
//
//    func getBasicHomeInfo() -> Observable<MyRepo> {
//        return provider.request(.getBasicHomeInfo)
//            .map(MyRepo.self)
//            .asObservable()
//    }
}

