//
//  LoginRepository.swift
//  Money-Planner
//
//  Created by p_kxn_g on 3/7/24.
//

import Foundation
import RxSwift
import RxMoya
import Moya

class LoginRepository {
    private let provider = MoyaProvider<LoginAPI>().rx
    let disposeBag = DisposeBag()
    
    // member controller
    
    func connect() -> Observable<ConnectModel> {
        return provider.request(.connect)
            .map(ConnectModel.self)
            .asObservable()
    }

    func refreshToken(refreshToken : RefreshTokenRequest)-> Observable<RefreshTokenResponse> {
        return provider.request(.refreshToken(refreshToken: refreshToken))
            .map(RefreshTokenResponse.self)
            .asObservable()
    }

}


