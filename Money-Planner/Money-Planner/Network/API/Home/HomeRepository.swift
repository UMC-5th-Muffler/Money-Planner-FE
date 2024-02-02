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
    
    func getHomeNow() -> Observable<BaseResponse<HomeNow?>>{
        return rx.request(.getHomeNow)
            // 리턴값인 시퀀스를 Observable<> 형태로 묶어주는 것
            .asObservable()
            // Json 데이터를 BaseResponse 구조체에 담기
//            .map { try JSONDecoder().decode(BaseResponse<HomeNow?>.self, from: $0.data) }
            .map { response in
                do {
                    print("여기로 오나?")
                    return try JSONDecoder().decode(BaseResponse<HomeNow?>.self, from: response.data)
                } catch {
                    print("여기로 오나2?")
                    throw MoyaError.jsonMapping(response)
                }
            }
    }
    
    func gettesttest() -> Single<BaseResponse<HomeNow?>>{
        return rx.request(.getHomeNow)
            // 리턴값인 시퀀스를 Observable<> 형태로 묶어주는 것
            // Json 데이터를 BaseResponse 구조체에 담기
//            .map { try JSONDecoder().decode(BaseResponse<HomeNow?>.self, from: $0.data) }
            .map(BaseResponse<HomeNow?>.self)
    }
    
    func getTest(completion: @escaping (BaseResponse<Category>?, Error?) -> Void){
        provider.request(.getHomeNow) { result in
            switch result {
            case let .success(response):
                do {
                    //성공 후 로직처리
                    print(try JSONDecoder().decode(BaseResponse<HomeNow?>.self, from: response.data))
                    // 받은 값을
                    //                    let decodedResponse = try response.map(BaseResponse<Category>.self)
                    //                    // 성공적으로 디코딩된 응답을 처리
                    //                    print(decodedResponse)
                } catch {
                    // 디코딩 오류 처리
                    print("Decoding error: \(error)")
                }
            case let .failure(error):
                // 네트워크 요청 실패 처리
                print("Network request failed: \(error)")
            }
        }
    }
    
    
//    func requestDeletePost(completion: @escaping (Result<PostResponse, Error>) -> Void ) {
//            provider.request(.deletePost(index: postID)) { result in
//                self.process(type: PostResponse.self, result: result, completion: completion)
//            }
//        }
}
