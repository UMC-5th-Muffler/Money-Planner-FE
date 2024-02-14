//
//  ExpenseRepository.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/13.
//

import Foundation
import Moya
import RxMoya
import RxSwift


final class ExpenseRepository : BaseRepository<ExpenseAPI> {
    static let shared = ExpenseRepository()
    
    func getExpenseList(text: String, order: String?, size: Int?, completion: @escaping (Result<DailyExpenseList?, BaseError>) -> Void){
        provider.request(.getSearchExpense(title : text, order : order, size: size)) {
            result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<DailyExpenseList?>.self)
                    
                    if(response.isSuccess!){
                        completion(.success(response.result!))
                    }else{
                        completion(.failure(.failure(message: response.message!)))
                    }
                    
                } catch {
                    // 디코딩 오류 처리
                    print("Decoding error: \(error)")
                }
            case let .failure(error):
                // 네트워크 요청 실패 처리
                print("Network request failed: \(error)")
                completion(.failure(.networkFail(error: error)))
            }
        }
    }
}
