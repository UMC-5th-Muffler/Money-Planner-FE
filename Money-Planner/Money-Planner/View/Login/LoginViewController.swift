//
//  ViewController.swift
//  Money-Planner
//
//  Created by 유철민 on 1/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import Moya


class LoginViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let sloganLabel = MPLabel()
    private let firstButton = UIButton()
    private let secondButton = UIButton()//ASAuthorizationAppleIDButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .mpWhite
        
        // 뷰 설정
        setuplogoImageView()
        setupSloganLabel()
        setupButtons()
        bindEvents()
    }
    
    //아래에서부터 setup 함수들이다. 위의 4가지 요소의 '구성 + 오토레이아웃' 이다.
    
    private func setuplogoImageView() {
        logoImageView.image = UIImage(named: "appstore") // "logoImage"는 이미지 이름
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150), // 예시 상수 값
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 193),
            logoImageView.heightAnchor.constraint(equalToConstant: 193)
        ])
    }
    
    private func setupSloganLabel() {
        sloganLabel.text = "당신의 현명한 소비습관 도우미, 머플러!"
        sloganLabel.textColor = .mpBlack
        sloganLabel.font = UIFont.mpFont26B()
        sloganLabel.textAlignment = .center
        sloganLabel.numberOfLines = 0 // 여러 줄로 표시 가능하도록 설정
        sloganLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sloganLabel)
        
        NSLayoutConstraint.activate([
            sloganLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40), // 예시 상수 값
            sloganLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sloganLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sloganLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
    private func setupButtons() {
        
        setupKakaoButton(firstButton)
        setupAppleButton(secondButton)
        
        // Apple 로그인 버튼 설정
        NSLayoutConstraint.activate([
            secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            secondButton.widthAnchor.constraint(equalToConstant: 332),
            secondButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 카카오 로그인 버튼 설정
        NSLayoutConstraint.activate([
            firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstButton.bottomAnchor.constraint(equalTo: secondButton.topAnchor, constant: -15),
            firstButton.widthAnchor.constraint(equalToConstant: 332),
            firstButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //위의 setupButtons의 부속 함수
    private func setupKakaoButton(_ button: UIButton) {
        button.setImage(UIImage(named: "btn_login_kakao"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(loginToKakao), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    private func setupAppleButton(_ button: UIButton /*ASAuthorizationAppleIDButton*/) {
        button.setImage(UIImage(named: "btn_login_apple"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(loginToApple), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
    }
    
    private func bindEvents() {
        // 카카오 로그인 버튼 이벤트 바인딩
        firstButton.rx.tap
            .bind { [weak self] in self?.loginToKakao() }
            .disposed(by: disposeBag)
        
        // 애플 로그인 버튼 이벤트 바인딩=> 수정해야 됨.
        //        secondButton.rx.tap
        //            .bind { [weak self] in self?.loginToApple() }
        //            .disposed(by: disposeBag)
    }
    
    @objc private func loginToKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx_loginWithKakaoTalk()
                .subscribe(onNext: { [weak self] oauthToken in
                    self?.handleLoginResult(oauthToken: oauthToken, error: nil)
                }, onError: { [weak self] error in
                    self?.handleLoginResult(oauthToken: nil, error: error)
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx_loginWithKakaoAccount()
                .subscribe(onNext: { [weak self] oauthToken in
                    self?.handleLoginResult(oauthToken: oauthToken, error: nil)
                }, onError: { [weak self] error in
                    self?.handleLoginResult(oauthToken: nil, error: error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    @objc private func loginToApple() {
        
    }
    
    
    private func handleLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print("로그인 실패: \(error.localizedDescription)")
        } else if let oauthToken = oauthToken {
            print("로그인 성공")
            // 로그인 성공 후 처리
            
        }
    }
    
}

