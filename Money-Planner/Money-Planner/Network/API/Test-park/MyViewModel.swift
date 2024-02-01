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
    private let provider = MoyaProvider<MyAPI>()
    func getUserRepos(username: String) -> Single<[MyRepo]> {
            return provider.rx.request(.getUserRepos(username: username))
                .map { response in
                    do {
                        return try response.map([MyRepo].self)
                    } catch {
                        // Try to handle the response as a single object (dictionary)
                        do {
                            let singleRepo = try response.map(MyRepo.self)
                            return [singleRepo]
                        } catch {
                            // If both array and single object decoding fail, return an empty array
                            print("Error decoding: \(error)")
                            return []
                        }
                    }
                }
        }
}
