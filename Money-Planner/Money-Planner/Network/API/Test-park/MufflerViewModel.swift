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
    
    // member controller
    
    func connect() -> Observable<ConnectModel> {
        return provider.request(.connect)
            .map(ConnectModel.self)
            .asObservable()
    }

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
                }, onFailure: { [weak self] error in
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

    // routine controller
    
    // 루틴 디테일 조회
    // 소비등록 > 카테고리 선택 뷰에서 활용
    func getRoutine(routineId : Int64) -> Observable<GetRoutineIdResponse> {
        return provider.request(.getRoutine(routineId: routineId))
            .map(GetRoutineIdResponse.self)
            .asObservable()
    }
    // 소비내역 삭제 : [DELETE] /api/expense/{expenseId}
    func deleteRoutine(routineId: Int64) -> Observable<ConnectModel> {
        return provider.request(.deleteRoutine(routineId: routineId))
            .map(ConnectModel.self).asObservable()
    }
    

}


