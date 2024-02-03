//
//  UnregisterViewController.swift
//  Money-Planner
//
//  Created by p_kxn_g on 2/3/24.
//

import Foundation
import UIKit

//protocol ProfileViewDelegate : AnyObject{
//    func profileNameChanged(_ userName : String)
//
//}
class UnregisterViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate, ReasonModalDelegate {
    func reasonChecked(_ reason: String) {
        reasonTextField.text = reason
        print(reason)
        view.layoutIfNeeded()

    }
    

    
    
//    func popupChecked() {
//        // 확인 누르면 문의하기 화면도 없어짐
//        dismiss(animated: true)
//    }
    
    private var UserName: String?
    //weak var delegate: ProfileViewDelegate?
    var completeCheck = compeleBtnCheck()
    var currTextSize : Int?

    private lazy var headerView = HeaderView(title: "")

    private var completeButton = MainBottomBtn(title: "탈퇴하기")
    private let NameTextField : UITextField = {
        let text = UITextField()
        text.placeholder = "조혜원" // 사용자 이름 넣기 (데이터)
        text.layer.cornerRadius = 8
        text.layer.borderWidth = 1.0
        text.layer.borderColor = UIColor.mpLightGray.cgColor
        text.layer.masksToBounds = true
        text.borderStyle = .none
        text.font = UIFont.mpFont20M()
        text.backgroundColor = .clear
        text.keyboardType = .default
        // 여백 추가
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: text.frame.height)) // 조절하고자 하는 여백 크기
        text.leftView = leftView
        text.leftViewMode = .always
        // 활성화
        text.isEnabled = false

        return text
    }()
    private let reasonTextField : UITextField = {
        let text = UITextField()
        text.text = "탈퇴사유를 선택해주세요"
        text.layer.cornerRadius = 8
        text.layer.masksToBounds = true
        text.font = UIFont.mpFont18M()
        text.tintColor = UIColor.mpMainColor
        text.textColor = .mpGray
        text.backgroundColor = .mpGypsumGray
        text.keyboardType = .default
        text.isMultipleTouchEnabled = true
        // 여백 추가
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: text.frame.height)) // 조절하고자 하는 여백 크기
        text.leftView = leftView
        text.leftViewMode = .always
        // Set placeholder
        text.textColor = .mpBlack
        text.isEnabled = false
        // 여백 추가
        text.addSubview(leftView)        // 활성화
        
        return text
    }()
    private let titleLabel : TitleLabel = {
        let label = TitleLabel()
        label.font = .mpFont26B()
        label.text = "머플러를 탈퇴하기 전에\n확인해주세요"
        label.numberOfLines = 2
        label.lineSpacing = 8.0
        label.textColor = .mpBlack
        return label
    }()
    private let nameLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14B()
        label.text = "이름"
        label.textColor = .mpGray
        return label
    }()
    private let emailLabel2 : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14M()
        label.text = "문의에 대한 답변을 이메일로 보내드려요"
        label.textColor = .mpDarkGray
        return label
    }()
    private let reasonLabel : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14B()
        label.text = "탈퇴사유"
        label.textColor = .mpGray
        return label
    }()
    // 탈퇴사유 선택 버튼
    lazy var reasonChooseButton: UIButton = {
        let button = UIButton()
        let arrowImage = UIImage(systemName:"chevron.down")?
            .withTintColor(.mpBlack, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)) // 조정하고자 하는 크기 설정

        button.setImage(arrowImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  // 클릭 활성화
        //button.backgroundColor = UIColor.red
        //button.addTarget(self, action: #selector(showCategoryModal), for: .touchUpInside) //클릭시 모달 띄우기
        return button
        
    }()
    private let contentsSize : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14M()
        label.text = "0/250"
        label.textColor = .mpDarkGray
        return label
    }()
    private let contentsError : MPLabel = {
        let label = MPLabel()
        label.font = .mpFont14M()
        label.text = "최대 글자수는 250자입니다."
        label.textColor = .clear
        return label
    }()
    override func viewDidLoad() {
        setupUI()
    }
    private func setupUI() {
        // 배경색상 추가
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mpWhite")
        view.backgroundColor = .systemBackground
        // 완료 버튼 활성화 확인
        print(completeCheck.contentsError)
        // 헤더
        setupHeader()
        
        // 완료 버튼 추가
        setupCompleteButton()
        setupTitleLabel()
        setupNameLabel()
        setupNameTextField()
        setupReasonLabel()
        setupReasonTextField()

        //setupContentsTextField()
        

    }
    
    // 세팅 : 헤더
    private func setupHeader(){
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        headerView.addBackButtonTarget(target: self, action: #selector(previousScreen), for: .touchUpInside)
    }
    @objc private func previousScreen(){
        dismiss(animated: true)
    }
    private func setupTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
                                             
    private func setupNameLabel(){
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        

    }
    private func setupNameTextField(){
        NameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(NameTextField)
        NSLayoutConstraint.activate([
            
            NameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            NameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            NameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            NameTextField.heightAnchor.constraint(equalToConstant: 64)
        ])
        
//        emailLabel2.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(emailLabel2)
//        NSLayoutConstraint.activate([
//            
//            emailLabel2.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
//            emailLabel2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            emailLabel2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//        ])


    }
    private func setupReasonLabel(){
        view.addSubview(reasonLabel)
        reasonLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reasonLabel.topAnchor.constraint(equalTo: NameTextField.bottomAnchor, constant: 36),
            reasonLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reasonLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        
    }
    private func setupReasonTextField(){
        view.addSubview(reasonTextField)
        reasonTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reasonTextField.topAnchor.constraint(equalTo: reasonLabel.bottomAnchor, constant: 10),
            reasonTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reasonTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reasonTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reasonTextField.heightAnchor.constraint(equalToConstant: 64)
            
        ])
        let buttonContianer = UIView()
        view.addSubview(buttonContianer)
        buttonContianer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonContianer.centerYAnchor.constraint(equalTo: reasonTextField.centerYAnchor),
            buttonContianer.widthAnchor.constraint(equalToConstant: 50),
            buttonContianer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            buttonContianer.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        // 카테고리 선택 버튼 추가
        buttonContianer.addSubview(reasonChooseButton)
        reasonChooseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reasonChooseButton.topAnchor.constraint(equalTo: buttonContianer.topAnchor),
            reasonChooseButton.bottomAnchor.constraint(equalTo: buttonContianer.bottomAnchor),
            reasonChooseButton.leadingAnchor.constraint(equalTo: buttonContianer.leadingAnchor),
            reasonChooseButton.trailingAnchor.constraint(equalTo: buttonContianer.trailingAnchor)
            
        ])
        reasonChooseButton.addTarget(self, action: #selector(reasonButtonTapped), for: .touchUpInside)

    }
    
    // 세팅 : 완료 버튼
    private func setupCompleteButton(){
        completeButton.isEnabled = false // 버튼 활성화
        view.addSubview(completeButton)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
    
        
    }
    
    


    // MARK: - UITextViewDelegate

       func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.textColor == UIColor.lightGray {
               textView.text = nil
               textView.textColor = UIColor.black
           }
       }

       func textViewDidEndEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               textView.text = "Placeholder Text"
               textView.textColor = UIColor.lightGray
               completeCheck.contentsWriten = false
               updateCompleteButtonState()
           }
           completeCheck.contentsWriten = true
           updateCompleteButtonState()
       }
   
   
    // MARK: - UItextFieldDelegate

    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        return true
    }
    
    // 이메일 형식 검사 함수
        func isValidEmail(email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    
    @objc
    private func reasonButtonTapped(){
        print("탈퇴사유 설정")
        let reasonVC = ReasonModalViewController() // 로그아웃 완료 팝업 띄우기
        reasonVC.delegate = self
        present(reasonVC, animated: true)
        completeButton.isEnabled = true // 탈퇴하기 버튼 활성화
        //dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func completeButtonTapped(){
        print("탈퇴가 완료되었습니다..")
        dismiss(animated: true)
    }
    
    struct compeleBtnCheck {
        var contentsWriten : Bool = false
        var emailWriten : Bool = false
        var emailError : Bool = true
        var contentsError : Bool = true

        
    }
    // 완료 버튼 상태 갱신
        private func updateCompleteButtonState() {
            // email, contents 입력 여부 및 에러 상태에 따라 버튼 활성화/비활성화 결정
            let isButtonEnabled = completeCheck.emailWriten && completeCheck.contentsWriten && completeCheck.emailError && completeCheck.contentsError
            print(isButtonEnabled)
            print(completeCheck.emailWriten )
            print(completeCheck.emailError )
            print(completeCheck.contentsWriten )
            print(completeCheck.contentsError )

            completeButton.isEnabled = isButtonEnabled
        }
}
