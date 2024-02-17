//
//  HomeRepository.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/01.
//

import Foundation
import Moya
import RxMoya
import RxSwift


final class HomeRepository : BaseRepository<HomeAPI> {
    
    static let shared = HomeRepository()
    
    
    func getHomeNow(completion: @escaping (Result<HomeNow?, BaseError>) -> Void){
        provider.request(.getHomeNow) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<HomeNow?>.self)
                    
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
    
    func getGoalList(completion: @escaping (Result<[Goal]?, BaseError>) -> Void){
        provider.request(.getGoalList) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<GoalList>.self)
                    
                    if(response.isSuccess!){
                        completion(.success(response.result!.goalList))
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
    
    func getCalendarListWithDate(yearMonth : String, completion: @escaping (Result<HomeNow?, BaseError>) -> Void){
        provider.request(.getCalendarListWithDate(yearMonth: yearMonth)) {
            result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<HomeNow?>.self)
                    
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
    
    
    func getCalendarListWithGoal(goalId : Int, yearMonth : String, completion: @escaping (Result<HomeNow?, BaseError>) -> Void){
        provider.request(.getCalendarListWithGoal(goalId: goalId, yearMonth: yearMonth)) {
            result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<HomeNow?>.self)
                    
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
    
    func getExpenseList(yearMonth: String?, size: Int?, goalId: Int?, order: String?, lastDate: String?, lastExpenseId: Int?, categoryId: Int?, completion: @escaping (Result<DailyExpenseList?, BaseError>) -> Void){
        provider.request(.getExpenseList(yearMonth: yearMonth, size: size, goalId: goalId, order: order, lastDate: lastDate, lastExpenseId: lastExpenseId, categoryId: categoryId)) {
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
