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

class MyViewModel {
    private let provider = MoyaProvider<MyAPI>().rx // rxmoya 적용
    
    func getUserRepos() -> Observable<MyRepo> {
        return provider.request(.getUserRepos)
            .map(MyRepo.self)
            .asObservable()
    }
}
