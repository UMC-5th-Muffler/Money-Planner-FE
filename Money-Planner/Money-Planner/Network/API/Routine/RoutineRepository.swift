//
//  RoutineRepository.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/02/17.
//

import Foundation

final class RoutineRepository : BaseRepository<RoutineAPI> {
    static let shared = RoutineRepository()
    
    func getRoutineList(completion: @escaping (Result<RoutineList?, BaseError>) -> Void){
        provider.request(.getRoutineList) {
            result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<RoutineList?>.self)
                    
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
