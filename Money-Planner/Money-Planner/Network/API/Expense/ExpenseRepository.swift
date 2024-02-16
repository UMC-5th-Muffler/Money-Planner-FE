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
    
    func getDailyConsumeHistory(date: String, size: Int?, lastExpenseId: Int?, completion: @escaping (Result<DailyInfo?, BaseError>) -> Void){
        provider.request(.getDailyConsumeHistory(date: date, size: size, lastExpenseId: lastExpenseId)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<DailyInfo?>.self)
                    
                    if (response.isSuccess!){
                        completion(.success(response.result!))
                    } else{
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
    
    func getRateInformation(date: String, completion: @escaping (Result<RateInfo?, BaseError>) -> Void){
        provider.request(.getRateInfo(date: date)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<RateInfo?>.self)
                    
                    if (response.isSuccess!){
                        completion(.success(response.result!))
                    } else{
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
    
    func rateDailyConsume(date: String, rate: String, rateMemo: String?, completion: @escaping (Result<RateModel?, BaseError>) -> Void){
        var parameters: [String: Any] = ["rate": rate]
        
        // rateMemo가 있는 경우에만 parameters에 추가합니다.
        if let rateMemo = rateMemo {
            parameters["rateMemo"] = rateMemo
        }
        
        provider.request(.rateDaily(date: date, rate: rate, rateMemo: rateMemo)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<RateModel?>.self)
                    
                    if (response.isSuccess!){
                        completion(.success(response.result!))
                    } else{
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
