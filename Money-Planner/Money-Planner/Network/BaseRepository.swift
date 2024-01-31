//
//  BaseRepository.swift
//  Money-Planner
//
//  Created by seonwoo on 2024/01/31.
//

import Foundation
import RxSwift
import Moya
import RxMoya

typealias DictionaryType = [String: Any]

class BaseRepository<API: TargetType> {
    let disposeBag = DisposeBag()
    let provider = MoyaProvider<API>()
    // 일단은 그냥 moya
//    lazy var rx = provider.rx
}
