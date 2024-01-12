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
    
    private init() {}
    
    func loginToKakao() {
        // 여기에 카카오 로그인 로직 구현
    }
    
    // 기타 카카오 로그인 관련 메소드 ...
}
