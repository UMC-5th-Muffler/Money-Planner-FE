//
//  TestRepository.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/30.
//

import Foundation
import Moya
import RxMoya

final class TestRepository : BaseRepository<TestAPI> {
    
    static let shared = TestRepository()
    
    // 그냥 moya
    func getTest(completion: @escaping (BaseResponse<Category>?, Error?) -> Void){
        provider.request(.getTest) { result in
            switch result {
            case let .success(response):
                do {
                    //성공 후 로직처리
                    print(response)
                    
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
    
    // rxmoya 적으로 하기
    func getTestRx(completion: @escaping (Any?, Error?) -> Void){
        MoyaProvider<TestAPI>().rx.request(.getTest)
            .filterSuccessfulStatusCodes().do(
                    onSuccess: { response in
                      print("성공")
                        print(response)
                    },
                    onError: { rawError in
                        print("에러")
                      print(rawError)
                    },
                    onSubscribe: {
                     print("여기")
                    }
                  )
    }
}


