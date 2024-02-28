//
//  KakaoLoginViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/6/24.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices


//rx login용
extension UserApi {
    
    func rx_loginWithKakaoAccount() -> Observable<OAuthToken> {
        return Observable.create { observer in
            self.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    observer.onError(error)
                } else if let oauthToken = oauthToken {
                    observer.onNext(oauthToken)
                    observer.onCompleted()
                } else {
                    observer.onError(RxError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    func rx_loginWithKakaoTalk() -> Observable<OAuthToken> {
        return Observable.create { observer in
            self.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    observer.onError(error)
                } else if let oauthToken = oauthToken {
                    observer.onNext(oauthToken)
                    observer.onCompleted()
                } else {
                    observer.onError(RxError.unknown)
                }
            }
            return Disposables.create()
        }
    }
    
    func rx_accessTokenInfo() -> Observable<AccessTokenInfo> {
        return Observable.create { observer in
            self.accessTokenInfo { (accessTokenInfo, error) in
                if let error = error {
                    observer.onError(error)
                } else if let accessTokenInfo = accessTokenInfo {
                    observer.onNext(accessTokenInfo)
                    observer.onCompleted()
                } else {
                    observer.onError(RxError.unknown)
                }
            }
            return Disposables.create()
        }
    }
}

class KakaoLogin {
    
    static let shared = KakaoLogin()
    private let disposeBag = DisposeBag()

    private init() {}
    
    func loginToKakao() {
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.rx_loginWithKakaoTalk()
                    .subscribe(onNext: { oauthToken in
                        print("로그인 성공: \(oauthToken)")
                        // 성공 처리 로직
                    }, onError: { error in
                        print("로그인 실패: \(error)")
                        // 실패 처리 로직
                    })
                    .disposed(by: disposeBag)
            } else {
                UserApi.shared.rx_loginWithKakaoAccount()
                    .subscribe(onNext: { oauthToken in
                        print("로그인 성공: \(oauthToken)")
                        // 성공 처리 로직
                    }, onError: { error in
                        print("로그인 실패: \(error)")
                        // 실패 처리 로직
                    })
                    .disposed(by: disposeBag)
            }
        }
    
    // 기타 카카오 로그인 관련 메소드 ...
}
