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
    private let subLabel = MPLabel()

    private let kakaoLoginButton = UIButton()
    private let appleLoginButton = UIButton()//ASAuthorizationAppleIDButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .mpWhite
        
        // 뷰 설정
        setupSloganLabel()
        setupSubLabel()
        setuplogoImageView()
        setupButtons()
        bindEvents()
    }
    
    //아래에서부터 setup 함수들이다. 위의 4가지 요소의 '구성 + 오토레이아웃' 이다.
    

    
    private func setupSloganLabel() {
        // NSMutableParagraphStyle 객체 생성 및 행 간격 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5 // 원하는 행 간격 값 설정
        
        // NSAttributedString 설정
        let attributedString = NSMutableAttributedString(string: "나의 소비목표 달성을\n도와줄 머플러",
                                                         attributes: [.paragraphStyle: paragraphStyle,
                                                                      .foregroundColor: UIColor.mpBlack,
                                                                      .font: UIFont.mpFont26B()])
        
        sloganLabel.attributedText = attributedString
        sloganLabel.textAlignment = .center
        sloganLabel.numberOfLines = 2 // 여러 줄로 표시 가능하도록 설정
        
        sloganLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sloganLabel)
        
        NSLayoutConstraint.activate([
            sloganLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120), // 예시 상수 값
            sloganLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sloganLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sloganLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            // 높이 제약 조건을 삭제하거나 수정할 수 있습니다. 높이가 고정되어 있으면 행 간격 변경이 제대로 반영되지 않을 수 있습니다.
        ])
    }

    
    private func setupSubLabel() {
        subLabel.text = "디테일한 목표로 소비내역을 관리해요"
        subLabel.textColor = .mpDarkGray
        subLabel.font = UIFont.mpFont14M()
        subLabel.textAlignment = .center
        subLabel.numberOfLines = 0 // 여러 줄로 표시 가능하도록 설정
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subLabel)
        
        NSLayoutConstraint.activate([
            subLabel.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 12), // 예시 상수 값
            subLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    private func setuplogoImageView() {
        logoImageView.image = UIImage(named: "img_popup_save") // "logoImage"는 이미지 이름
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 12), // 예시 상수 값
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 280),
            logoImageView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func setupButtons() {
        setupKakaoButton(kakaoLoginButton)
        setupAppleButton(appleLoginButton)

        // Apple 로그인 버튼 설정
        NSLayoutConstraint.activate([
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.bottomAnchor.constraint(equalTo: kakaoLoginButton.topAnchor, constant: -16),
            appleLoginButton.widthAnchor.constraint(equalToConstant: 332),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // 카카오 로그인 버튼 설정
        NSLayoutConstraint.activate([
            kakaoLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kakaoLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: 332),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 50)
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
        kakaoLoginButton.rx.tap
            .bind { [weak self] in self?.loginToKakao() }
            .disposed(by: disposeBag)
        
        // 애플 로그인 버튼 이벤트 바인딩=> 수정해야 됨.
        //        secondButton.rx.tap
        //            .bind { [weak self] in self?.loginToApple() }
        //            .disposed(by: disposeBag)
    }
    
    
    
    @objc private func loginToKakao() {
            guard let url = URL(string: "https://muffler.world/api/member/login/kakao") else {
                print("유효하지 않은 URL입니다.")
                return
            }
            // Safari로 URL 열기
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
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
            // 로그인 성공 후에 토큰을 저장합니다.
            print(oauthToken)
            saveTokenToUserDefaults(token: oauthToken.accessToken)
            // 홈화면으로 이동
            // 홈 화면으로 이동합니다.
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.setupMainInterface()
        }
        
        
    }
    // 토큰을 UserDefaults에 저장하는 함수
    func saveTokenToUserDefaults(token: String) {
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "accessToken")
    }
  
    

}

