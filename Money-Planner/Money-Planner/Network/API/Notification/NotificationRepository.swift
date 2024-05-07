//
//  NotificationRepository.swift
//  Money-Planner
//
//  Created by Jini on 5/7/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift


final class NotificationRepository : BaseRepository<NotificationAPI> {
    static let shared = NotificationRepository()
    
    //agreeAlarm
    func agreeAlarm(agreeInfo: NotificationEditModel, completion: @escaping (Result<NotificationEditModel?, BaseError>) -> Void){
        provider.request(.agreeAlarm(param: agreeInfo)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<NotificationEditModel?>.self)
                    
                    if (response.isSuccess!){
                        completion(.success(response.result!))
                    } else{
                        completion(.failure(.failure(message: response.message!)))
                    }
                    
                } catch {
                    // 디코딩 오류 처리
                    print("동의Decoding error: \(error)")
                }
            case let .failure(error):
                // 네트워크 요청 실패 처리
                print("Network request failed: \(error)")
                completion(.failure(.networkFail(error: error)))
            }
        }
    }
    
    //getAgree
    func getAgreeInfo(completion: @escaping (Result<NotificationGetModel?, BaseError>) -> Void){
        provider.request(.getAgree) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<NotificationGetModel?>.self)
                    
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
    

    //deleteToken
    func deleteToken(completion: @escaping (Result<NotificationToken?, BaseError>) -> Void){
        provider.request(.deleteToken) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<NotificationToken?>.self)
                    
                    if (response.isSuccess!){
                        completion(.success(response.result!))
                    } else{
                        completion(.failure(.failure(message: response.message!)))
                    }
                    
                } catch {
                    // 디코딩 오류 처리
                    print("토큰삭제Decoding error: \(error)")
                }
            case let .failure(error):
                // 네트워크 요청 실패 처리
                print("Network request failed: \(error)")
                completion(.failure(.networkFail(error: error)))
            }
        }
    }
    
    
    //patchToken
    func patchToken(token: String, completion: @escaping (Result<NotificationToken?, BaseError>) -> Void){
        provider.request(.patchToken(token: token)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<NotificationToken?>.self)
                    
                    if (response.isSuccess!){
                        completion(.success(response.result!))
                    } else{
                        completion(.failure(.failure(message: response.message!)))
                    }
                    
                } catch {
                    // 디코딩 오류 처리
                    print("토큰패치Decoding error: \(error)")
                }
            case let .failure(error):
                // 네트워크 요청 실패 처리
                print("Network request failed: \(error)")
                completion(.failure(.networkFail(error: error)))
            }
        }
    }
    
    //sendToken
    func sendToken(token: String, completion: @escaping (Result<NotificationToken?, BaseError>) -> Void){
        provider.request(.sendToken(token: token)) { result in
            switch result {
            case let .success(response):
                do {
                    let response = try response.map(BaseResponse<NotificationToken?>.self)
                    
                    if (response.isSuccess!){
                        completion(.success(response.result!))
                    } else{
                        completion(.failure(.failure(message: response.message!)))
                    }
                    
                } catch {
                    // 디코딩 오류 처리
                    print("토큰보내기 Decoding error: \(error)")
                }
            case let .failure(error):
                // 네트워크 요청 실패 처리
                print("send Network request failed: \(error)")
                completion(.failure(.networkFail(error: error)))
            }
        }
    }
    
}
