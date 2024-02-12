//
//  ViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/5/24.
//

import UIKit
import RxSwift
import RxMoya

//kakao
import RxKakaoSDKAuth
import RxKakaoSDKUser
import RxKakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

//apple
import AuthenticationServices

//암호화
import Security


class LoginViewController: UIViewController {
    
    var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tmpLogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //여기에다 addtarget하니 문제 생김
        return imageView
    }()
    
    var appleLoginBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btn_login_apple"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var kakaoLoginBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btn_login_kakao"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        appleLoginBtn.addTarget(self, action: #selector(appleLogin), for: .touchUpInside)
        kakaoLoginBtn.addTarget(self, action: #selector(kakaoLogin), for: .touchUpInside)
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(logoImageView)
        view.addSubview(kakaoLoginBtn)
        view.addSubview(appleLoginBtn)
        
        // LogoImageView constraints
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 182),
            logoImageView.widthAnchor.constraint(equalToConstant: 193),
            logoImageView.heightAnchor.constraint(equalToConstant: 193)
        ])
        
        // KakaoLoginBtn constraints
        NSLayoutConstraint.activate([
            kakaoLoginBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            kakaoLoginBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -31),
            kakaoLoginBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            kakaoLoginBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // AppleLoginBtn constraints
        NSLayoutConstraint.activate([
            appleLoginBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            appleLoginBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -31),
            appleLoginBtn.bottomAnchor.constraint(equalTo: kakaoLoginBtn.topAnchor, constant: -16),
            appleLoginBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func kakaoLogin() {
        // Class member property
        let disposeBag = DisposeBag()
        
        // 카카오톡 실행 가능 여부 확인 //userAPI => import KakaoSDKUser
        if (UserApi.isKakaoTalkLoginAvailable()) { //나중에 nonce
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ (oauthToken) in
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    UserApi.shared.rx.me()
                        .subscribe (onSuccess:{ user in
                            print("me() success.")
                            
                            //do something
                            let registerProfileVC = RegisterProfileViewController()
                            self.navigationController?.pushViewController(registerProfileVC, animated: true)
                            _ = user
                        }, onFailure: {error in
                            print(error)
                        })
                        .disposed(by: disposeBag)
                    
                    
                    _ = oauthToken
                }, onError: {error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }else{
            UserApi.shared.rx.loginWithKakaoAccount()//나중에 nonce
                .subscribe(onNext:{ (oauthToken) in
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    UserApi.shared.rx.me()
                        .subscribe (onSuccess:{ user in
                            print("me() success.")
                            
                            //do something
                            
                            guard let userID = user.id
                            else{
                                print("token, userID is nil")
                                return
                            }
                            
                            print("=========================")
                            print("user ID : ")
                            print(String(user.id!))
                            print("=========================")
                            
                            let registerProfileVC = RegisterProfileViewController()
                            self.navigationController?.pushViewController(registerProfileVC, animated: true)
                            
                            //                            _ = user
                        }, onFailure: {error in
                            print(error)
                        })
                        .disposed(by: disposeBag)
                    
                    guard let idToken = oauthToken.idToken
                    else{
                        print("ID Token is nil")
                        return
                    }
                    print("=========================")
                    print("user ID : ")
                    print(String(idToken))
                    print("=========================")
                    
                    //                    _ = oauthToken
                }, onError: {error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
        
        //        UserApi.shared.rx.me()
        //            .map({ (user) -> User in
        //
        //                //필요한 scope을 아래의 예제코드를 참고해서 추가한다.
        //                //아래 예제는 모든 스콥을 나열한것.
        //                var scopes = [String]()
        //
        //                if (user.kakaoAccount?.profileNeedsAgreement == true) { scopes.append("profile") }
        //                if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
        //                if (user.kakaoAccount?.birthdayNeedsAgreement == true) { scopes.append("birthday") }
        //                if (user.kakaoAccount?.birthyearNeedsAgreement == true) { scopes.append("birthyear") }
        //                if (user.kakaoAccount?.genderNeedsAgreement == true) { scopes.append("gender") }
        //                if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) { scopes.append("phone_number") }
        //                if (user.kakaoAccount?.ageRangeNeedsAgreement == true) { scopes.append("age_range") }
        //                if (user.kakaoAccount?.ciNeedsAgreement == true) { scopes.append("account_ci") }
        //
        //                if (scopes.count > 0) {
        //                    print("사용자에게 추가 동의를 받아야 합니다.")
        //
        //                    // OpenID Connect 사용 시
        //                    // scope 목록에 "openid" 문자열을 추가하고 요청해야 함
        //                    // 해당 문자열을 포함하지 않은 경우, ID 토큰이 재발급되지 않음
        //                    // scopes.append("openid")
        //
        //                    // scope 목록을 전달하여 SdkError 처리
        //                    throw SdkError(scopes:scopes) //=> kakaoCommon
        //                }
        //                else {
        //                    print("사용자의 추가 동의가 필요하지 않습니다.")
        //
        //                    return user
        //                }
        //            })
        //            .retry(when: Auth.shared.rx.incrementalAuthorizationRequired()) //Generic parameter 'TriggerObservable' could not be inferred, Value of type 'Auth' has no member 'rx'
        //            .subscribe(onSuccess:{ ( user ) in
        //                print("me() success.")
        //
        //                //do something
        //                _ = user
        //
        //            }, onFailure: {error in
        //                print(error)
        //            })
        //            .disposed(by: disposeBag)
    }
    
    @objc func appleLogin() {
        // Implement Apple login action
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

//애플 로그인을 위한 익스텐션
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        switch authorization.credential { // certificates,idetifiers 에서 sign in with apple 허용 안하면 로그인이후로 못넘어감.
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
//                print("authorizationCode: \(authorizationCode)")
//                print("identityToken: \(identityToken)")
//                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
            }
            
            //print("useridentifier: \(userIdentifier)")
            print("fullName: \(String(describing: fullName))")
            print("email: \(String(describing: email))")
            
            //vc 넘어가기
            DispatchQueue.main.async { [weak self] in
                let registerProfileVC = RegisterProfileViewController()
                self?.navigationController?.pushViewController(registerProfileVC, animated: true)
            }
            
            //Move to MainPage
            //let validVC = SignValidViewController()
            //validVC.modalPresentationStyle = .fullScreen
            //present(validVC, animated: true, completion: nil)
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
            //vc 넘어가기
            DispatchQueue.main.async { [weak self] in
                let registerProfileVC = RegisterProfileViewController()
                self?.navigationController?.pushViewController(registerProfileVC, animated: true)
            }
            
        default:
            break
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
