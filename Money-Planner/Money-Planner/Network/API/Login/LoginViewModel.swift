//
//  LoginViewModel.swift
//  Money-Planner
//
//  Created by p_kxn_g on 3/7/24.
//

import Foundation
import RxSwift
import RxMoya
import Moya
import UIKit

class LoginViewModel {
    let loginRepository = LoginRepository()
    let disposeBag = DisposeBag()
    
    func isLoginEnabled(completion: @escaping (Bool) -> Void) {
        loginRepository.connect()
            .subscribe(onNext: { response in
                print(response)
                completion(response.isSuccess)
            }, onError: { error in
                // 오류가 발생한 경우에 대한 처리를 수행합니다.
                print(error)
                completion(false) // 로그인 불가능으로 처리
            })
            .disposed(by: disposeBag)
    }
    
    func refreshAccessTokenIfNeeded() {
        // 이미 저장된 리프레시 토큰이 있는 경우
        if let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") {
            print(refreshToken)
            // 리프레시 토큰을 사용하여 새로운 액세스 토큰을 가져오는 요청을 수행합니다.
            let refreshTokenRequest = RefreshTokenRequest(refreshToken: refreshToken)
            loginRepository.refreshToken(refreshToken: refreshTokenRequest)
                .subscribe(onNext: { response in
                    print(response)
                    // 새로운 액세스 토큰이 성공적으로 갱신된 경우
                    if response.isSuccess {
                        // 갱신된 액세스 토큰을 저장하거나, 필요한 처리를 수행합니다.
                        if let result = response.result {
                            let accessToken  = result.accessToken
                            let refreshToken = result.refreshToken
                            UserDefaults.standard.set(accessToken, forKey: "accessToken")
                            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                        }
                        
                        // 홈 화면으로 이동합니다.
                        self.MoveToHome()
                    } else {
                        // 실패한 경우에 대한 처리를 수행합니다.
                        print("Failed to refresh access token: \(response.message)")
                    }
                }, onError: { error in
                    // 오류가 발생한 경우에 대한 처리를 수행합니다.
                    print(error)
                    print("Error refreshing access token: \(error.localizedDescription)")
                })
                .disposed(by: disposeBag)
        }
    }
    func MoveToHome(){
        print("홈화면으로 이동")
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.setupMainInterface()
    }
}
