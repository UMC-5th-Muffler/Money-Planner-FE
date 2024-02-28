//
//  CategoryRepository.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/08.
//

import Foundation

final class CategoryRepository : BaseRepository<CategoryAPI>{
    static let shared = CategoryRepository()
    
    func getCategoryFilteredList(completion: @escaping (Result<[Category]?, BaseError>) -> Void){
        provider.request(.getCategoryFilteredList) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<CategoryList>.self)
                    
                    if(response.isSuccess!){
                        completion(.success(response.result!.categories))
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
    
    func getCategoryAllList(completion: @escaping (Result<[Category]?, BaseError>) -> Void){
        provider.request(.getCategoryAllList) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<CategoryList>.self)
                                        
                    if(response.isSuccess!){
                        completion(.success(response.result!.categories))
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
    
    
    func updateCategoryFilter(categories : [Category] ,completion: @escaping (Result<Bool, BaseError>) -> Void){
        let categoryList : CategoryList = CategoryList.init(categories: categories)
        
        provider.request(.updateCategoryFilter(categories: categoryList)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<CategoryList>.self)
                                        
                    if(response.isSuccess!){
                        completion(.success(response.isSuccess!))
                    }else{
                        completion(.failure(.failure(message: response.message!)))
                    }
                    
                } catch {
                    // 디코딩 오류 처리
                    print("Decoding error: \(error)")
                    completion(.failure(.networkFail(error: error)))
                }
            case let .failure(error):
                // 네트워크 요청 실패 처리
                print("Network request failed: \(error)")
                completion(.failure(.networkFail(error: error)))
            }
        }
    }
}
